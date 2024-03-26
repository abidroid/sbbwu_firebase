
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class TaskUpdateScreen extends StatefulWidget {

  final DocumentSnapshot snapshot;
  const TaskUpdateScreen({super.key, required this.snapshot});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  TextEditingController taskNameC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  @override
  void initState() {
    taskNameC.text = widget.snapshot['title'];
    descriptionC.text = widget.snapshot['description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            controller: taskNameC,
            decoration: const InputDecoration(
                hintText: 'Task Name',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder()
            ),
          ),
          const Gap(16),

          Stack(
            children: [
              TextField(

                controller: descriptionC,
                maxLines: 5,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 36, top: 24),
                    hintText: 'Description',
                    //prefixIcon: Icon(Icons.list),
                    border: OutlineInputBorder()
                ),
              ),

              const Positioned(
                  left: 8, top: 16,
                  child: Icon(Icons.list)),
            ],
          ),
          const Gap(16),
          ElevatedButton(onPressed: () async {
            String taskTitle = taskNameC.text.trim();

            if( taskTitle.isEmpty){
              Fluttertoast.showToast(msg: 'Please provide a task');
              return;
            }

            String description = descriptionC.text.trim();

            if( description.isEmpty){
              Fluttertoast.showToast(msg: 'Please provide a description');
              return;
            }

            String uid = FirebaseAuth.instance.currentUser!.uid;

            var taskRef = FirebaseFirestore.instance.collection('tasks').doc(uid).collection('tasks').doc(
                widget.snapshot['taskId']
            );

            await taskRef.update({

              'title': taskTitle,
              'description': description,

            });

            Fluttertoast.showToast(msg: 'Updated');

            Navigator.of(context).pop();

            }, child: const Text('Update')),
        ],),
      ),
    );
  }
}
