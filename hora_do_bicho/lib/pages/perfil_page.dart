import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/layout.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bem-vindo ao perfil!",
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
      ),
    );
  }
}
