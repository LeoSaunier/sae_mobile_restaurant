import 'package:flutter/material.dart';
import 'package:tp2/modele/detailTache.dart';
import 'package:tp2/modele/task.dart';
import 'package:tp2/api/api.dart';

class Ecran3 extends StatelessWidget {
  Ecran3({super.key});

  final Future<List<Task>> _tasks = MyAPI().getTasksAPI();


  Widget _taskToWidget(Task task, BuildContext context){
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text("${task.nbhours} hours - ${task.tags.join('  ')}"),
        trailing: Text("Difficulte ${task.difficulty}"),
        onTap: () {
          Navigator.push(
            context,
              MaterialPageRoute(
              builder: (context) => Detailstache(task: task,),),);},));}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _tasks,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length??0,
              itemBuilder: (context, index){
                return _taskToWidget(snapshot.data![index], context);
              }
          );
        }
    );
  }
}




