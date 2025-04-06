import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_restaurant/viewModel/taskViewModel.dart';

import 'modele/task.dart';

class AddTask extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            backgroundColor: Colors.lightBlue,
          ),
            onPressed: () {
              context.read<TaskViewModel>().addTask(Task.newTask());
              Navigator.pop(context);
            },
          child: const Text("Add Task"),
        ),
      ),
    ) ;
  }
}