import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_page.dart';
import 'ecran_favoris.dart';
import 'ecran_settings.dart';
import 'providers/user_provider.dart';
import 'restaurant_liste.dart';
import 'services/local_storage_service.dart';
import 'theme/mytheme.dart';
import 'viewModel/favorites_viewmodel.dart';
import 'viewModel/settingViewModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dhhugougxeqqjglegovv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoaHVnb3VneGVxcWpnbGVnb3Z2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwMTM2NTgsImV4cCI6MjA1NjU4OTY1OH0.-D6yUvdMPVSIbQQaWvs1WrTBBk7YG1OGE81VptxiYIs',
  );

  final localStorage = LocalStorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingViewModel()),
        ChangeNotifierProvider(
          create: (context) => FavoritesViewModel(localStorage)..loadFavorites(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantListe(),
    const FavoritesScreen(),
    const EcranSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<SettingViewModel>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Mon Restaurant App',
          debugShowCheckedModeBanner: false,
          theme: settings.isDark ? MyTheme.dark() : MyTheme.light(),
          home: userProvider.isLoggedIn ? _buildMainApp() : const AuthPage(),
        );
      },
    );
  }

  Widget _buildMainApp() {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}