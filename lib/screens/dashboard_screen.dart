import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sbbwu_firebase/screens/add_task_screen.dart';
import 'package:sbbwu_firebase/screens/login_screen.dart';
import 'package:sbbwu_firebase/screens/profile_screen.dart';
import 'package:sbbwu_firebase/screens/task_update_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CollectionReference? taskRef;

  @override
  void initState() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    taskRef = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('tasks');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const AddTaskScreen();
            }));
          },
          label: const Text('Add Task'),
          icon: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ProfileScreen();
                  }));
                },
                icon: const Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content: const Text('Are you sure to Sign Out ?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  FirebaseAuth.instance.signOut();

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  }));
                                },
                                child: const Text('Yes')),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: taskRef?.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List tasksList = snapshot.data!.docs;

              if (tasksList.isEmpty) {
                return const Center(child: Text('No Tasks Found'));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: tasksList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tasksList[index]['title']),
                                    Text(tasksList[index]['description']),
                                    Text(getHumanReadableDate(
                                        tasksList[index]['createdOn'])),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                          return TaskUpdateScreen(snapshot: tasksList[index]);
                                        }));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Confirmation'),
                                                content:const Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    Gap(10),
                                                    Text(
                                                        'Are you sure to delete ?'),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text('No')),
                                                  TextButton(onPressed: () async{

                                                    Navigator.pop(context);

                                                    // delete ki logic

                                                    await taskRef!.doc(tasksList[index]['taskId'] ).delete();

                                                    Fluttertoast.showToast(msg: 'Task Deleted');

                                                    }, child: const Text('Yes')),

                                                ],
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              return const Center(
                child: SpinKitWave(
                  color: Colors.blue,
                ),
              );
            }
          },
        ));
  }

  String getHumanReadableDate(int milliseconds) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}
