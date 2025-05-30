import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      await authService.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha alterada com sucesso')),
      );

      Navigator.pop(context); // Volta para o perfil
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
      appBar: AppBar(title: Text('Alterar Senha')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(labelText: 'Senha Atual'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a senha atual' : null,
              ),

              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
                validator: (v) =>
                    v != null && v.length > 8 ? null : 'Senha muito curta',
              ),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirmar Nova Senha'),
                obscureText: true,
                validator: (v) => v == _newPasswordController.text
                    ? null
                    : 'Senhas não coincidem',
              ),

              SizedBox(height: 20),

              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _changePassword,
                      child: Text('Confirmar'),
                    ),

            ],
          
          ),
        ),
      ),
    );
  }
}
