import 'package:flutter/material.dart';
import 'package:tp2/modele/task.dart';
import 'package:tp2/api/api.dart';

class Ecran2 extends StatelessWidget {
  Ecran2({super.key});

  final Future<List<Task>> _tasks = MyAPI().getTasks();

  Widget _taskToWidget(Task task){
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
    return FutureBuilder(
      future: _tasks,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.data?.length??0,
            itemBuilder: (context, index){
              return _taskToWidget(snapshot.data![index]);
            }
        );
      }
    );
  }
}
