import 'package:flutter/foundation.dart';

class Task {
  int id;
  String title;
  List<String> tags;
  int nbhours;
  int difficulty;
  String description;
  static int nb = 0;

  Task({required this.id,required this.title,required this.tags,required
  this.nbhours,required this.difficulty,required this.description});


  factory Task.newTask(){
    nb++; //attribut static de la classe.
    return Task(id: nb, title: 'title $nb', tags: ['tags $nb'], nbhours:
    nb, difficulty: nb%5, description: 'description $nb');
  }

  factory Task.createTask(String title, List<String> tags, int nbHours, int diffculty, String description){
    nb++; //attribut static de la classe.
    return Task(id: nb, title: title, tags: tags, nbhours:
    nbHours, difficulty: diffculty, description: description);
  }

  factory Task.fromApi(Map <String, dynamic> json){
    return Task(
        id: json['id'],
        title: json['title'],
        nbhours: 0,
        difficulty: 0,
        description: "e",
        tags: []
    );
  }

  factory Task.fromJson(Map<String, dynamic> json){
    final tags = <String>[];
    if (json['tags']!=null){
      json['tags'].forEach((element){
        tags.add(element);
    });
  }
    return Task(
      id: json['id'],
      title: json['title'],
      nbhours: json['nbhours'],
      difficulty: json['difficulty'],
      description: json['description'],
      tags: tags
    );
  }
  static List<Task> generateTask(int i){
    List<Task> tasks=[];
    for(int n=0;n<i;n++){
      tasks.add(Task(id: n, title: "title $n", tags: ['tag $n','tag${n+1}'], nbhours: n, difficulty: n, description: '$n'));
      }
      return tasks;
  }
}

