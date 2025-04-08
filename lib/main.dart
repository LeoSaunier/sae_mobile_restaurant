import 'package:flutter/material.dart';
import 'package:sae_restaurant/restaurant_liste.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../mytheme.dart';
import '../viewModel/settingViewModel.dart';
import '../ecran_settings.dart';
import 'auth_page.dart'; // Page d'authentification
import '/providers/user_provider.dart'; // Import du nouveau provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dhhugougxeqqjglegovv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoaHVnb3VneGVxcWpnbGVnb3Z2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwMTM2NTgsImV4cCI6MjA1NjU4OTY1OH0.-D6yUvdMPVSIbQQaWvs1WrTBBk7YG1OGE81VptxiYIs',
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;
  bool _isLoggedIn = false;

  final List<Widget> _vues = <Widget>[
    RestaurantListe(),
    EcranSettings(),
  ];

  void _onItemTapped(int currentIndex) {
    setState(() {
      _index = currentIndex;
    });
  }

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
        ChangeNotifierProvider(create: (_) => UserProvider()), // Ajout de UserProvider
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, settingvm, _) {
          return MaterialApp(
            title: "TD2",
            debugShowCheckedModeBanner: false,
            theme: settingvm.isDark ? MyTheme.dark() : MyTheme.light(),
            home: _isLoggedIn
                ? _buildMainApp()
                : AuthPage(onLoginSuccess: _handleLoginSuccess),
          );
        },
      ),
    );
  }

  Widget _buildMainApp() {
    return Scaffold(
      appBar: AppBar(),
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
    );
  }
}