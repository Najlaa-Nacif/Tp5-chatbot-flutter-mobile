import 'package:flutter/material.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _login() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez entrer votre nom')));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(userName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 80, color: Color(0xFF6750A4)),
                    const SizedBox(height: 16),
                    const Text('Connexion', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Entrez votre nom pour commencer le chat', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom utilisateur',
                        prefixIcon: const Icon(Icons.account_circle),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(onPressed: _login, icon: const Icon(Icons.login), label: const Text('Commencer')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
