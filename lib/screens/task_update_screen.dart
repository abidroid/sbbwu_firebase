import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TaskUpdateScreen extends StatefulWidget {
  const TaskUpdateScreen({super.key});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  TextEditingController taskNameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task Screen'),
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
          ElevatedButton(onPressed: (){

            }, child: const Text('Update')),
        ],),
      ),
    );
  }
}
