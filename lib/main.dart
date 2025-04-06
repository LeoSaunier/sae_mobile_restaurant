import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../mytheme.dart';
import '../viewModel/settingViewModel.dart';
import '../viewModel/taskViewModel.dart';
import '../ecran_settings.dart';
import 'auth_page.dart'; // Importez votre page d'authentification

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
  int _index = 0;
  bool _isLoggedIn = false; // Ajout d'un état pour suivre la connexion

  final List<Widget> _vues = <Widget>[
    Column(
      children: [
        Expanded(child: RestaurantListe()),
      ],
    ),
    EcranSettings(),
  ];

  void _onItemTapped(int currentIndex) {
    setState(() {
      _index = currentIndex;
    });
  }

  // Méthode pour gérer la connexion réussie
  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

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
            title: "TD2",
            theme: settingvm.isDark ? MyTheme.dark() : MyTheme.light(),
            home: _isLoggedIn
                ? _buildMainApp(context)
                : AuthPage(onLoginSuccess: _handleLoginSuccess),
          );
        },
      ),
    );
  }
  Widget _buildMainApp(BuildContext context) {
    return Scaffold(
       appBar: AppBar(),
      body: _vues[_index],
      child: Consumer<SettingViewModel>(
        builder: (context, settingvm, child) {
          return MaterialApp(
            title: "TD2",
            debugShowCheckedModeBanner: false,
            theme: settingvm.isDark ? MyTheme.dark() : MyTheme.light(),
            home: Scaffold(
              body: _vues[_index],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _index,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Restaurants"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

