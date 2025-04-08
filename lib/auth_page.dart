import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_service.dart';
import 'database/database_service.dart';
import 'providers/user_provider.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthPage({super.key, required this.onLoginSuccess});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final DatabaseService _dbService = DatabaseService();

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
      // Réinitialiser les champs quand on change de mode
      _formKey.currentState?.reset();
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = await _dbService.getUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // 🔥 Ajout de l'utilisateur au UserProvider
        Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);

        // 🔓 Puis déclencher la navigation vers l'app principale
        widget.onLoginSuccess();
      } else {
        _showMessage('Email ou mot de passe incorrect');
      }
    } catch (e) {
      _showMessage('Erreur de connexion: $e');
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final user = await _dbService.registerUser(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Fermer l'indicateur
      Navigator.of(context).pop();

      if (user != null) {
        _showMessage('Inscription réussie!');
        toggleMode();
      } else {
        _showMessage('Échec de l\'inscription - vérifiez vos informations');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Fermer l'indicateur en cas d'erreur
      _showMessage('Erreur technique: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  isLogin ? 'Connexion' : 'Inscription',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (!isLogin) ...[
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre prénom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLogin ? _login : _register,
                  child: Text(
                    isLogin ? 'Se connecter' : 'S\'inscrire',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: toggleMode,
                  child: Text(
                    isLogin
                        ? 'Pas encore de compte ? S\'inscrire'
                        : 'Déjà un compte ? Se connecter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}