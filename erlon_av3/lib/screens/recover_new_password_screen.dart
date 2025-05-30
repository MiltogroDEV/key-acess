import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RecoverNewPasswordScreen extends StatefulWidget {
  final String tempToken;

  const RecoverNewPasswordScreen({super.key, required this.tempToken});

  @override
  State<RecoverNewPasswordScreen> createState() => _RecoverNewPasswordScreenState();
}

class _RecoverNewPasswordScreenState extends State<RecoverNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _recoverPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.recoverPassword(
        widget.tempToken,
        _newPasswordController.text,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha - Nova Senha')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Senha muito curta',
              ),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (v) =>
                    v == _newPasswordController.text ? null : 'Senhas não coincidem',
              ),

              SizedBox(height: 20),

              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _recoverPassword,
                      child: Text('Redefinir'),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
