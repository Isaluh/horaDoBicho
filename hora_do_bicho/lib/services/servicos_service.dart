import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servico.dart';

class ServicosService {
  final String baseUrl = 'https://hora-do-bicho-8p4e7ly0q-isaluhs-projects.vercel.app/servicos';

  Future<List<Servico>> listarServicos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((json) => Servico.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao listar serviços');
    }
  }

  Future<Servico?> criarServico(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Servico.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao criar serviço: ${response.body}');
      throw Exception('Falha ao criar serviço (${response.statusCode})');
    }
  }

  Future<Servico?> atualizarServico(Servico servico) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${servico.idServico}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(servico.toJson()),
    );

    if (response.statusCode == 200) {
      return Servico.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar serviço');
    }
  }

  Future<Servico?> getServico(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Servico.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao obter dados do serviço');
    }
  }

  Future<void> deletarServico(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Falha ao deletar serviço');
    }
  }
}
