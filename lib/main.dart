import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'package:tp2/mytheme.dart';
import 'package:tp2/viewModel/settingViewModel.dart';
import 'package:tp2/viewModel/taskViewModel.dart';
import 'package:tp2/vue1.dart';
import 'package:tp2/vue2.dart';
import 'package:tp2/vue3.dart';
import 'package:tp2/modele/task.dart';
import 'package:provider/provider.dart';
import 'AddTask.dart';
import 'addTaskForm.dart';
import 'ecran_settings.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dhhugougxeqqjglegovv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoaHVnb3VneGVxcWpnbGVnb3Z2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwMTM2NTgsImV4cCI6MjA1NjU4OTY1OH0.-D6yUvdMPVSIbQQaWvs1WrTBBk7YG1OGE81VptxiYIs',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _vues = <Widget>[Ecran1(), Ecran2(), Ecran3(), EcranSettings()];

  int _index = 0;

  void _onItemTapped(int currentIndex){
    setState(() {
      _index = currentIndex;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create : (_)=>SettingViewModel()),
        ChangeNotifierProvider(
            create:(_){
              TaskViewModel taskViewModel = TaskViewModel();
              taskViewModel.generateTasks();
              return taskViewModel;
            } )
      ],
        child: Consumer<SettingViewModel>(
          builder: (context, settingvm, child) {
            return MaterialApp(
            title: "TD2",
            theme: settingvm.isDark ? MyTheme.dark() : MyTheme.light(),
            home: Builder(
              builder: (context) {
                return Scaffold(appBar: AppBar(),
                body: _vues[_index],
                bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _index,
                onTap: _onItemTapped,
                items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon : Icon(Icons.article), label: "Liste 1"),
                BottomNavigationBarItem(icon : Icon(Icons.article), label: "Liste 2"),
                BottomNavigationBarItem(icon : Icon(Icons.article), label: "Liste 3"),
                BottomNavigationBarItem(icon : Icon(Icons.article), label: "Liste 4")
                ]
                ),
                  floatingActionButton: _index==0?FloatingActionButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AddTaskForm(),
                      )
                      );
                    },
                    child: const Icon(Icons.add),):const SizedBox.shrink(),
                );
              }
            ),
            );
          }
          ),
    );
  }
}




