import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hora_do_bicho/models/notificacao.dart';

class NotificacaoService {
  final String baseUrl = 'https://hora-do-bicho.vercel.app/notificacoes';

  Future<List<Notificacao>> listarPorCliente(int idCliente) async {
    final response = await http.get(Uri.parse("$baseUrl/cliente/$idCliente"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Notificacao.fromJson(json)).toList();
    } else {
      throw Exception(
        "Erro ao buscar notificações (status: ${response.statusCode})",
      );
    }
  }

  Future<Notificacao?> criarNotificacao(int idCliente, String descricao) async {
    final response = await http.post(
      Uri.parse("$baseUrl/criar"),
      body: {"idCliente": idCliente.toString(), "descricao": descricao},
    );

    if (response.statusCode == 200) {
      return Notificacao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Erro ao criar notificação (status: ${response.statusCode})",
      );
    }
  }

  Future<void> marcarComoLida(int idNotificacao) async {
    final url = Uri.parse("$baseUrl/$idNotificacao/lida?lida=true");

    final response = await http.put(url);

    if (response.statusCode != 200) {
      throw Exception(
        "Erro ao marcar notificação como lida (status: ${response.statusCode})",
      );
    }
  }
}
