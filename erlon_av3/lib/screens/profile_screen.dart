import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  void _loadUserData() async {
    try {
      final authService = AuthService();
      final data = await authService.getUser();
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Nome: ${_userData?['name'] ?? ''}'),
                  Text('Username: ${_userData?['username'] ?? ''}'),
                  Text('Email: ${_userData?['email'] ?? ''}'),
                  Text('Telefone: ${_userData?['phone'] ?? ''}'),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                      );
                    },
                    child: Text('Alterar Senha'),
                  ),

                ],
              ),
            ),
    );
  }
}
