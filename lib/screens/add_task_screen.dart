
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskNameC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            controller: taskNameC,
            decoration: const InputDecoration(
                hintText: 'Task Name',
                prefixIcon: Icon(Icons.add_card_rounded),
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

            FirebaseFirestore firestore = FirebaseFirestore.instance;

            var taskRef = firestore.collection('tasks').doc(uid).collection('tasks').doc();


           try{
             await taskRef.set({
               'taskId': taskRef.id,
               'title': taskTitle,
               'description': description,
               'createdOn': DateTime.now().millisecondsSinceEpoch,
             });

             Fluttertoast.showToast(msg: 'Task Created');

             Navigator.pop(context);


           } on Exception catch(e){
             Fluttertoast.showToast(msg: e.toString());
            }


          }, child: const Text('Save')),
        ],),
      ),
    );
  }
}
