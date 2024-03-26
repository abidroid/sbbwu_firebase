import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/utility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot? documentSnapshot;
  File? imageFile;
  bool imagePicked = false;

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  getUserProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {});
  }

  pickImageAndUpload(ImageSource imageSource) async {
    // pick image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: imageSource);

    if (image == null) return;

    setState(() {
      imagePicked = true;
      imageFile = File(image.path);
    });

    // display on UI

    // Upload to storage
    FirebaseStorage storage = FirebaseStorage.instance;

    var fileName = documentSnapshot!['email'] + '.png';

    UploadTask uploadTask = storage
        .ref()
        .child('profile_images')
        .child(fileName)
        .putFile(imageFile!, SettableMetadata(contentType: 'image/png'));

    TaskSnapshot snapshot = await uploadTask;

    String profileImageUrl = await snapshot.ref.getDownloadURL();
    print(profileImageUrl);

    // get its download url

    // update the database
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'photo': profileImageUrl});

    Fluttertoast.showToast(msg: 'Profile image uploaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: documentSnapshot == null
            ? const Center(
                child: SpinKitWave(
                  color: Colors.blue,
                ),
              )
            : ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: imagePicked
                            ? FileImage(imageFile!) as ImageProvider
                            : documentSnapshot!['photo'] != null
                                ? NetworkImage(documentSnapshot!['photo'])
                                : null,
                        radius: 100,
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.camera_alt),
                                              title: const Text('Camera'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                pickImageAndUpload(
                                                    ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.photo),
                                              title: const Text('Gallery'),
                                              onTap: () {
                                                Navigator.pop(context);

                                                pickImageAndUpload(
                                                    ImageSource.gallery);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.camera_alt))),
                      ),
                    ],
                  ),
                  Text(documentSnapshot!['name']),
                  Text(documentSnapshot!['email']),
                  Text(documentSnapshot!['gender']),
                  Text(getHumanReadableDate(documentSnapshot!['createdOn'])),
                ],
              ),
      ),
    );
  }
}
