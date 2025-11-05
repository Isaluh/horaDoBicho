// components/ficha.dart
import 'package:flutter/material.dart';

enum FichaTipo { pet, funcionario, servico }

class Ficha extends StatelessWidget {
  final FichaTipo tipo;
  final String nome;
  final String infoPrincipal;
  final String infoSecundaria;
  final String imagemAsset;
  final Function(String)? onMenuSelected;

  const Ficha({
    super.key,
    required this.tipo,
    required this.nome,
    required this.infoPrincipal,
    required this.infoSecundaria,
    required this.imagemAsset,
    this.onMenuSelected,
  });

  String get _rotuloPrincipal {
    switch (tipo) {
      case FichaTipo.pet:
        return 'Idade:';
      case FichaTipo.funcionario:
        return 'Cargo:';
      case FichaTipo.servico:
        return 'Descrição:';
    }
  }

  String get _rotuloSecundario {
    switch (tipo) {
      case FichaTipo.pet:
        return 'Raça:';
      case FichaTipo.funcionario:
        return 'Telefone ';
      case FichaTipo.servico:
        return 'Preço';
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems() {
    switch (tipo) {
      case FichaTipo.pet:
        return const [
          PopupMenuItem(value: 'editar', child: Text('Editar')),
          PopupMenuItem(value: 'agendar', child: Text('Agendar')),
          PopupMenuItem(value: 'excluir', child: Text('Excluir')),
        ];
      case FichaTipo.funcionario:
        return const [
          PopupMenuItem(value: 'editar', child: Text('Editar')),
          PopupMenuItem(value: 'excluir', child: Text('Excluir')),
        ];
      case FichaTipo.servico:
        return const [
          PopupMenuItem(value: 'editar', child: Text('Editar')),
          PopupMenuItem(value: 'excluir', child: Text('Excluir')),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color corPrimaria = Color(0xFF4A2C00);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: corPrimaria),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (tipo != FichaTipo.servico)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagemAsset,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          if (tipo != FichaTipo.servico)
          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: corPrimaria,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$_rotuloPrincipal $infoPrincipal',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 3),
                Text(
                  '$_rotuloSecundario $infoSecundaria',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: corPrimaria),
            onSelected: (value) => onMenuSelected?.call(value),
            itemBuilder: (_) => _buildMenuItems(),
          ),
        ],
      ),
    );
  }
}
