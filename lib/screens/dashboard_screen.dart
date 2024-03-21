
import 'package:flutter/material.dart';
import 'package:sbbwu_firebase/screens/add_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return const AddTaskScreen();
        }));
      },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.person)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout)),

        ],
      ),
      body: const Placeholder(),
    );
  }
}
