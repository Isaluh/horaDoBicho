import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/funcionario.dart';

class FuncionariosService {
  final String baseUrl = 'http://localhost:8080/funcionarios';

  Future<List<Funcionario>> listarFuncionarios() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((json) => Funcionario.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao listar funcionários');
    }
  }

  Future<Funcionario?> criarFuncionario(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Funcionario.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao criar funcionário: ${response.body}');
      throw Exception('Falha ao criar funcionário (${response.statusCode})');
    }
  }

  Future<Funcionario?> atualizarFuncionario(Funcionario funcionario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${funcionario.idFuncionario}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(funcionario.toJson()),
    );

    if (response.statusCode == 200) {
      return Funcionario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar funcionário');
    }
  }

  Future<Funcionario?> getFuncionario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Funcionario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao obter dados do funcionário');
    }
  }

  Future<void> deletarFuncionario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Falha ao deletar funcionário');
    }
  }
}
