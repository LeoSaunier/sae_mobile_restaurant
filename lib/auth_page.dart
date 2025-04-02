import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_config.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> login() async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showMessage('Connexion échouée.');
      }
    } on AuthException catch (e) {
      showMessage('Erreur de connexion : ${e.message}');
    } catch (e) {
      showMessage('Une erreur inattendue est survenue : $e');
    }
  }


  Future<void> register() async {
    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
        data: {'prenom': 'Prénom', 'nom': 'Nom'},
      );

      if (response.user != null) {
        showMessage('Inscription réussie');
        toggleMode();
      } else {
        showMessage('Inscription échouée.');
      }
    } on AuthException catch (e) {
      showMessage('Erreur d\'inscription : ${e.message}');
    } catch (e) {
      showMessage('Une erreur inattendue est survenue : $e');
    }
  }

  // void visitAsGuest() {
  //   Navigator.pushReplacementNamed(context, '/home');
  // }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Connexion' : 'Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLogin ? login : register,
              child: Text(isLogin ? 'Se connecter' : 'S\'inscrire'),
            ),
            TextButton(
              onPressed: toggleMode,
              child: Text(isLogin
                  ? 'Pas de compte ? S\'inscrire'
                  : 'Déjà inscrit ? Se connecter'),
            ),
            // TextButton(
            //   onPressed: visitAsGuest,
            //   child: const Text('Continuer en tant que visiteur'),
            // ),
          ],
        ),
      ),
    );
  }
}
