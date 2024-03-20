import 'package:flutter/material.dart';

class TaskUpdateScreen extends StatefulWidget {
  const TaskUpdateScreen({super.key});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task Screen'),
      ),
      body: const Placeholder(),
    );
  }
}
