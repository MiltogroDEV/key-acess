import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'recover_code_screen.dart';

class RecoverEmailScreen extends StatefulWidget {
  const RecoverEmailScreen({super.key});

  @override
  State<RecoverEmailScreen> createState() => _RecoverEmailScreenState();
}

class _RecoverEmailScreenState extends State<RecoverEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  void _sendRecoveryCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.sendRecoveryCode(_emailController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecoverCodeScreen(email: _emailController.text),
        ),
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
      appBar: AppBar(title: Text('Recuperar Senha - Email')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Email inválido' : null,
              ),

              SizedBox(height: 20),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _sendRecoveryCode,
                      child: Text('Enviar Código'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
