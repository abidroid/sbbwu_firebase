import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController mobileC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  bool obscureText = true;

  String genderValue = 'Male';
  String countryCode = '+93';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Row(
                children: [
                   CountryCodePicker(
                    onChanged: (CountryCode? cc){
                      setState(() {
                        countryCode = cc!.toString();
                      });
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'IT',
                    favorite: ['+92', 'PK'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      controller: mobileC,
                      decoration: const InputDecoration(
                        hintText: 'Mobile',
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder()),
            ),
            const Gap(16),
            TextField(
              controller: passC,
              obscureText: obscureText,
              decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: const OutlineInputBorder()),
            ),
            const Gap(16),
            TextField(
              controller: confirmPassC,
              obscureText: obscureText,
              decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: const OutlineInputBorder()),
            ),
            const Gap(16),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: 'Male',
                        groupValue: genderValue,
                        onChanged: (String? text) {
                          setState(() {
                            genderValue = text!;
                          });
                        }),
                    const Text('Male'),
                  ],
                ),
                const Gap(32),
                Row(
                  children: [
                    Radio(
                        value: 'Female',
                        groupValue: genderValue,
                        onChanged: (String? text) {
                          setState(() {
                            genderValue = text!;
                          });
                        }),
                    const Text('Female'),
                  ],
                ),
              ],
            ),
            const Gap(16),
            ElevatedButton(
                onPressed: () async {
                  // validation
                  String name = nameC.text.trim();
                  if (name.isEmpty) {
                    Fluttertoast.showToast( msg: 'Please provide name');
                    return;
                  }

                  String mobile = mobileC.text.trim();
                  if( mobile.isEmpty){
                    Fluttertoast.showToast( msg: 'Please provide mobile number');
                    return;
                  }

                  String email = emailC.text.trim();
                  if( email.isEmpty){
                    Fluttertoast.showToast( msg: 'Please provide email');
                    return;
                  }
                  String password = passC.text.trim();
                  if( password.isEmpty){
                    Fluttertoast.showToast( msg: 'Please provide password');
                    return;
                  }

                  if( password.length < 6 ){
                    Fluttertoast.showToast( msg: 'Please provide at least 6 characters in password');
                    return;
                  }

                  String confirmPass = confirmPassC.text.trim();

                  if( password != confirmPass){
                    Fluttertoast.showToast( msg: 'Passwords do not match');
                    return;
                  }

                  String finalMobileNumber = '$countryCode-$mobile';
                                                // +92-4444444444

                  FirebaseAuth auth = FirebaseAuth.instance;

                  try {
                    UserCredential userCredentials =
                        await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (userCredentials != null) {

                      // save other information into database datastore
                      String uid = userCredentials.user!.uid;

                      FirebaseFirestore firestore = FirebaseFirestore.instance;

                      await firestore.collection('users').doc(uid).set({
                        'uid': uid,
                        'name': name,
                        'mobile': finalMobileNumber,
                        'email': email,
                        'gender': genderValue,
                        'createdOn': DateTime.now().millisecondsSinceEpoch,
                        'photo': null,
                      });

                      Fluttertoast.showToast(msg: 'User Registered');

                    }
                  } on FirebaseAuthException catch (e) {
                    print(e.message);
                    Fluttertoast.showToast(msg: e.message.toString());
                  }
                },
                child: const Text('Sign Up')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already Registered? Login'))
          ],
        ),
      ),
    );
  }
}
