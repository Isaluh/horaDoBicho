import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hora_do_bicho/models/user.dart';
import 'package:hora_do_bicho/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool isAdmin = false;
  bool isEditing = false;

  final Map<String, TextEditingController> _controllers = {
    'nomeCliente': TextEditingController(),
    'emailCliente': TextEditingController(),
    'telefoneCliente': TextEditingController(),
    'enderecoCliente': TextEditingController(),
    'senhaCliente': TextEditingController(),
    'confirmarSenhaCliente': TextEditingController(),
  };

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserPermissions();
  }

  Future<void> _loadUserPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      User user = User.fromJson(userMap);

      setState(() {
        isAdmin = user.permissaoCliente == Permissao.ADMIN;

        userData = {
          'idCliente': user.idCliente,
          'nomeCliente': user.nomeCliente,
          'emailCliente': user.emailCliente,
          'cpfCliente': user.cpfCliente,
          'telefoneCliente': user.telefoneCliente,
          'enderecoCliente': user.enderecoCliente ?? '',
          'senhaCliente': '',
          'confirmarSenhaCliente': '',
          'permissaoCliente': user.permissaoCliente.name,
        };

        _preencherControllers();
      });
    }
  }

  void _preencherControllers() {
    _controllers.forEach((key, controller) {
      if (key == 'senhaCliente' || key == 'confirmarSenhaCliente') {
        controller.clear();
      } else {
        controller.text = userData[key]?.toString() ?? '';
      }
    });
  }

  List<Map<String, dynamic>> get fields {
    if (isAdmin) {
      return [
        {'key': 'telefoneCliente', 'label': 'Telefone', 'editable': true},
        {'key': 'enderecoCliente', 'label': 'Endereço', 'editable': true},
      ];
    } else {
      return [
        {'key': 'cpfCliente', 'label': 'CPF', 'editable': false},
        {'key': 'nomeCliente', 'label': 'Nome', 'editable': true},
        {'key': 'emailCliente', 'label': 'Email', 'editable': true},
        {'key': 'telefoneCliente', 'label': 'Telefone', 'editable': true},
      ];
    }
  }

  Widget buildField(Map<String, dynamic> field) {
    final String key = field['key'];
    final String label = field['label'];
    final bool editable = field['editable'];

    final controller = _controllers[key];

    if (isEditing && editable && controller != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelStyle: const TextStyle(color: Color(0xFF2596be)),
            labelStyle: const TextStyle(fontSize: 14),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2596be)),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2C00),
                fontSize: 12,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                userData[key]?.toString() == '' || userData[key] == null
                    ? "-"
                    : userData[key].toString(),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildSenhaSection() {
    if (isAdmin) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controllers['senhaCliente'],
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Nova Senha',
            floatingLabelStyle: const TextStyle(color: Color(0xFF2596be)),
            labelStyle: const TextStyle(fontSize: 14),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2596be)),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _controllers['confirmarSenhaCliente'],
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmar Senha',
            floatingLabelStyle: const TextStyle(color: Color(0xFF2596be)),
            labelStyle: const TextStyle(fontSize: 14),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2596be)),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void toggleEditing() {
    if (isEditing) {
      salvarAlteracoes();
    } else {
      setState(() {
        isEditing = true;
      });
    }
  }

  Future<void> salvarAlteracoes() async {
    userData.forEach((key, value) {
      if (_controllers.containsKey(key)) {
        if (key == 'senhaCliente' || key == 'confirmarSenhaCliente') return;
        userData[key] = _controllers[key]!.text;
      }
    });

    String senha = _controllers['senhaCliente']!.text;
    String confirmarSenha = _controllers['confirmarSenhaCliente']!.text;

    if (senha.isNotEmpty && senha != confirmarSenha) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não conferem')));
      return;
    }

    userData['senhaCliente'] = senha.isNotEmpty ? senha : null;

    final userService = UserService();
    User user = User.fromJson(userData);
    User? atualizado = await userService.atualizarUsuario(user);

    if (atualizado != null) {
      setState(() {
        userData = {
          'idCliente': atualizado.idCliente,
          'nomeCliente': atualizado.nomeCliente,
          'emailCliente': atualizado.emailCliente,
          'cpfCliente': atualizado.cpfCliente,
          'telefoneCliente': atualizado.telefoneCliente,
          'enderecoCliente': atualizado.enderecoCliente ?? '',
          'senhaCliente': '',
          'confirmarSenhaCliente': '',
          'permissaoCliente': atualizado.permissaoCliente,
        };

        _preencherControllers();
        isEditing = false;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(atualizado?.toJson()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  void cancelarEdicao() {
    setState(() {
      _preencherControllers();
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Meu Perfil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C00),
                ),
              ),
              ElevatedButton.icon(
                onPressed: toggleEditing,
                icon: Icon(
                  isEditing ? Icons.save : Icons.edit,
                  color: Colors.black,
                ),
                label: Text(
                  isEditing ? "Salvar" : "Editar",
                  style: const TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF98E6F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 20),

                      ...fields.map(buildField).toList(),

                      const SizedBox(height: 10),

                      if (isEditing) buildSenhaSection(),

                      if (isEditing) const SizedBox(height: 20),

                      if (isEditing)
                        ElevatedButton.icon(
                          onPressed: cancelarEdicao,
                          label: Text(
                            'Cancelar',
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
