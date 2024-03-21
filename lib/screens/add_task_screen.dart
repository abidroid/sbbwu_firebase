
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskNameC = TextEditingController();

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
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder()
            ),
          ),

          const Gap(16),
          ElevatedButton(onPressed: (){



          }, child: const Text('Save')),
        ],),
      ),
    );
  }
}
