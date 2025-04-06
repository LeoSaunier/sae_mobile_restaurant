import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:sae_restaurant/modele/task.dart';

class MyAPI {


  Future<List<Task>> getTasks() async {
    await Future.delayed(Duration(seconds: 1));
    final dataString = await _loadAsset('json/tasks.json');
    final Map<String, dynamic> json = jsonDecode(dataString);
    if (json['tasks'] != null) {
      final tasks = <Task>[];
      json['tasks'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    } else {
      return [];
    }
  }

  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }

  Future<List<Task>> getTasksAPI() async {
    await Future.delayed(Duration(seconds: 1));
    final http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),);
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      if (json.isNotEmpty) {
        final tasks = <Task>[];
        json.forEach((element) {
          tasks.add(Task.fromApi(element));
        });
        return tasks;
      } else {
        return [];
      }
    }
    else {
      return [];
    }
  }
}