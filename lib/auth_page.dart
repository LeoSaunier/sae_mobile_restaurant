import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_service.dart';
import 'providers/user_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isLogin) {
        final user = await _dbService.getUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          context.read<UserProvider>().setCurrentUser(user);
        }
      } else {
        final user = await _dbService.registerUser(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          _toggleMode();
          _showMessage('Inscription réussie !');
        }
      }
    } catch (e) {
      _showMessage('Erreur: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Connexion' : 'Inscription',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              if (!_isLogin) ...[
                _buildTextField(_firstNameController, 'Prénom', Icons.person),
                _buildTextField(_lastNameController, 'Nom', Icons.person),
              ],
              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(_passwordController, 'Mot de passe', Icons.lock, isPassword: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleAuth,
                child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(_isLogin 
                  ? 'Pas de compte ? Créer un compte'
                  : 'Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Ce champ est obligatoire';
          if (label == 'Email' && !value.contains('@')) return 'Email invalide';
          if (isPassword && value.length < 6) return '6 caractères minimum';
          return null;
        },
      ),
    );
  }
}