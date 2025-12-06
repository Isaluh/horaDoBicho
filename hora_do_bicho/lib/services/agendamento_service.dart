import 'dart:convert';
import 'package:hora_do_bicho/models/agendamento_response.dart';
import 'package:http/http.dart' as http;
import '../models/agendamento.dart';

class AgendamentosService {
  final String baseUrl = 'https://hora-do-bicho.vercel.app/agendamentos';

  Future<List<AgendamentoResponse>> listarAgendamentos({int? idCliente}) async {
    Uri url = idCliente != null
        ? Uri.parse('$baseUrl/cliente/$idCliente')
        : Uri.parse(baseUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((json) => AgendamentoResponse.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao listar agendamentos (${response.statusCode})');
    }
  }


  Future<AgendamentoResponse?> criarAgendamento(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return AgendamentoResponse.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao criar agendamento: ${response.body}');
      throw Exception('Falha ao criar agendamento (${response.statusCode})');
    }
  }

  Future<AgendamentoResponse?> atualizarAgendamento(Agendamento agendamento) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${agendamento.idAgendamento}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(agendamento.toJson()),
    );

    if (response.statusCode == 200) {
      return AgendamentoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar agendamento (${response.statusCode})');
    }
  }

  Future<AgendamentoResponse?> getAgendamento(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return AgendamentoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao obter dados do agendamento');
    }
  }

  Future<void> deletarAgendamento(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Falha ao deletar agendamento (${response.statusCode})');
    }
  }

  Future<void> atualizarStatus(int id, Status novoStatus, {String? motivo}) async {
    final body = {
      'statusAgendamento': novoStatus.name,
      if (motivo != null) 'descricaoStatus': motivo,
    };

    print(body);

    final response = await http.put(
      Uri.parse('$baseUrl/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar status do agendamento (${response.statusCode})');
    }
  }
}
