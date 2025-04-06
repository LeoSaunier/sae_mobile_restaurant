import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp2/modele/task.dart';

class Detailstache extends StatelessWidget{
  final Task task;
  const Detailstache({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(task.description),
      ),
    );
  }
}