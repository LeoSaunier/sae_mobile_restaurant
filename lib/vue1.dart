import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp2/modele/task.dart';
import 'package:tp2/viewModel/taskViewModel.dart';
import 'package:provider/provider.dart';

class Ecran1 extends StatelessWidget {
  Ecran1({super.key});

  late List<Task>
      _tasks; // = context.read<TaskViewModel>.liste;//Task.generateTask(20);

  Widget _taskToWidget(Task task) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text("${task.nbhours} hours - ${task.tags.join('  ')}"),
        trailing: Text("Difficulte ${task.difficulty}"),
      ),
    );
  }
/* List<Widget> _tasksToWidget(List<Task> tasks){
   List<Widget> widgets = <Widget>[];
   for(Task task in tasks){
     widgets.add(_taskToWidget(task));
   }
   return widgets;
 }*/

  @override
  Widget build(BuildContext context) {
    _tasks = context.watch<TaskViewModel>().liste;
    return ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return _taskToWidget(_tasks[index]);
        });
  }
}
