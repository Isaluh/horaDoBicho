import 'package:flutter/material.dart';
import 'package:hora_do_bicho/models/notificacao.dart';
import 'package:hora_do_bicho/components/layout.dart';
import 'package:hora_do_bicho/services/notificacoes_service.dart';

class NotificacoesPage extends StatefulWidget {
  final int userId;

  const NotificacoesPage({super.key, required this.userId});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final NotificacaoService _notificacaoService = NotificacaoService();
  late Future<List<Notificacao>> _futureNotificacoes;

  @override
  void initState() {
    super.initState();
    _futureNotificacoes = _notificacaoService.listarPorCliente(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notificações",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B3E26),
              ),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder<List<Notificacao>>(
                future: _futureNotificacoes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // esperar retornar os valores certos de notificação
                  if (snapshot.hasError) {
                    // return const Center(
                    //   child: Text("Erro ao carregar notificações"),
                    // );
                    return Center(
                      child: Text(
                        "Erro ao carregar notificações:\n${snapshot.error}",
                      ),
                    );
                  }

                  final notificacoes = snapshot.data ?? [];

                  if (notificacoes.isEmpty) {
                    return const Center(
                      child: Text("Você não tem nenhuma notificação"),
                    );
                  }

                  return ListView.separated(
                    itemCount: notificacoes.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey[400]),
                    itemBuilder: (context, index) {
                      final n = notificacoes[index];

                      return ListTile(
                        leading: Icon(
                          n.lida
                              ? Icons.mark_email_read
                              : Icons.mark_email_unread,
                          color: n.lida ? Colors.green : Colors.orange,
                        ),
                        title: Text(
                          n.titulo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(n.descricao),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
