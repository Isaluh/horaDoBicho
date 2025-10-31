
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/clientes';

  Future<User?> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailCliente': email, 'senhaCliente': senha}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login falhou');
    }
  }

  Future<User?> cadastrar(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Erro no cadastro: ${response.body}');
      throw Exception('Falha ao cadastrar usuário (${response.statusCode})');
    }
  }

  Future<User?> atualizarUsuario(User user) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar o usuário');
    }
  }

  Future<User?> getUsuario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/usuario/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao obter dados do usuário');
    }
  }
}
