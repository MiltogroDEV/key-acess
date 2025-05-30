import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'recover_new_password_screen.dart';

class RecoverCodeScreen extends StatefulWidget {
  final String email;

  const RecoverCodeScreen({super.key, required this.email});

  @override
  State<RecoverCodeScreen> createState() => _RecoverCodeScreenState();
}

class _RecoverCodeScreenState extends State<RecoverCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;

  void _validateCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final tempToken = await authService.validateRecoveryCode(widget.email, _codeController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecoverNewPasswordScreen(tempToken: tempToken),
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
      appBar: AppBar(title: Text('Recuperar Senha - Código')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Código (6 dígitos)'),
                keyboardType: TextInputType.number,
                validator: (v) => v != null && v.length == 6 ? null : 'Código inválido',
              ),

              SizedBox(height: 20),

              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _validateCode,
                      child: Text('Validar'),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
