import 'package:dio/dio.dart';
import 'package:erlon_av3/services/api_service.dart';
import 'package:erlon_av3/utils/local_storage.dart';

class AuthService {
  final _api = ApiService().client;

  Future<bool> login(String username, String password) async {
    try {
      final response = await _api.post(
        '/auth/login/',
        data: {'username': username, 'password': password},
      );
      final token = response.data['token'];
      await LocalStorage.saveToken(token);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciais inválidas');
      }
      throw Exception('Erro ao fazer login');
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/auth/register/', data: data);
      final token = response.data['token'];
      await LocalStorage.saveToken(token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Email/Username já existe');
      }
      throw Exception('Erro ao registrar');
    }
  }

  Future<void> logout() async {
    await LocalStorage.clearToken();
  }

  Future<void> sendRecoveryCode(String email) async {
    try {
      await _api.post(
        '/auth/send-email-recovery-password/',
        data: {'email': email},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Email não cadastrado');
      }
      throw Exception('Erro ao enviar código de recuperação');
    }
  }

  Future<String> validateRecoveryCode(String email, String code) async {
    try {
      final response = await _api.post(
        '/auth/validate-recovery-code/',
        data: {'email': email, 'code': code},
      );
      return response.data['temp_token'];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Código inválido');
      }
      throw Exception('Erro ao validar código');
    }
  }

  Future<void> recoverPassword(String tempToken, String newPassword) async {
    try {
      await _api.post(
        '/auth/recovery-password/',
        data: {'password': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $tempToken'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token/código inválido');
      }
      throw Exception('Erro ao redefinir senha');
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _api.patch(
        '/auth/change-password/',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Senha atual incorreta');
      }
      throw Exception('Erro ao alterar senha');
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      final response = await _api.get('/auth/user/');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sessão expirada. Faça login novamente.');
      }
      throw Exception('Erro ao carregar dados do usuário');
    }
  }
}
