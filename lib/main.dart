import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2/mytheme.dart';
import 'package:tp2/services/supabase_config.dart';
import 'package:tp2/viewModel/settingViewModel.dart';
import 'package:tp2/viewModel/taskViewModel.dart';
import 'auth_page.dart';
import 'vue1.dart';
import 'vue2.dart';
import 'vue3.dart';
import 'ecran_settings.dart';
import 'AddTask.dart';
import 'addTaskForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            TaskViewModel taskViewModel = TaskViewModel();
            taskViewModel.generateTasks();
            return taskViewModel;
          },
        ),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, settingvm, child) {
          return MaterialApp(
            title: 'TP2',
            theme: settingvm.isDark ? MyTheme.dark() : MyTheme.light(),
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthPage(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _vues = <Widget>[Ecran1(), Ecran2(), Ecran3(), EcranSettings()];
  int _index = 0;

  void _onItemTapped(int currentIndex) {
    setState(() {
      _index = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: _vues[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Liste 1'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Liste 2'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Liste 3'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddTaskForm(),
          ));
        },
        child: const Icon(Icons.add),
      )
          : const SizedBox.shrink(),
    );
  }
}
