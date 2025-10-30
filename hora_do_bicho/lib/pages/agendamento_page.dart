import 'package:flutter/material.dart';

class AgendamentoPage extends StatelessWidget {
  const AgendamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bem-vindo ao agendamento de servicos!",
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              // Você pode navegar para outras páginas daqui
              // Exemplo: Navigator.pushNamed(context, '/detalhes');
            },
            child: Text("Agendar um pet"),
          ),
        ],
      ),
    );
  }
}
