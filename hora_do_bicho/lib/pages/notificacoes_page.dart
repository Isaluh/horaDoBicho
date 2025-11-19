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

            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FutureBuilder<List<Notificacao>>(
                  future: _futureNotificacoes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erro ao carregar notificações:\n${snapshot.error}",
                        ),
                      );
                    }

                    final notificacoes = snapshot.data ?? [];
                    notificacoes.sort((a, b) {
                      if (a.lida == b.lida) return 0;
                      return a.lida ? 1 : -1;
                    });

                    if (notificacoes.isEmpty) {
                      return const Center(
                        child: Text("Você não tem nenhuma notificação"),
                      );
                    }

                    return ListView.separated(
                      itemCount: notificacoes.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 14, thickness: 1),
                      itemBuilder: (context, index) {
                        final n = notificacoes[index];

                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: const Color(0xFFFDFDFD),
                          leading: Icon(
                            n.lida
                                ? Icons.mark_email_read
                                : Icons.mark_email_unread,
                            color: n.lida ? Colors.grey : Colors.orange,
                          ),
                          title: Text(
                            n.titulo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(n.descricao),
                          onTap: () async {
                            try {
                              await _notificacaoService.marcarComoLida(
                                n.idNotificacao,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LayoutPage(
                                    body: Container(),
                                    abrirAgendamentoId: n.idAgendamento,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print("Erro ao marcar como lida: $e");
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
