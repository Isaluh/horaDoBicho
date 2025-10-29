import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hora_do_bicho/services/user_service.dart';
import 'package:hora_do_bicho/models/user.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final Map<String, TextEditingController> _controllers = {
    'nome': TextEditingController(),
    'cpf': TextEditingController(),
    'email': TextEditingController(),
    'telefone': TextEditingController(),
    'senha': TextEditingController(),
    'confirmarSenha': TextEditingController(),
    'endereco': TextEditingController(),
  };

  Permissao _permissaoUser = Permissao.COMUM;

  void _cadastrar() async {
    final Map<String, String> _variaveis = {
      for (var entry in _controllers.entries) entry.key: entry.value.text,
    };


    if (_variaveis.values.any((valor) => valor.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Há campos em branco.')),
      );
      return;
    }

    if (_variaveis['senha'] != _variaveis['confirmarSenha']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    _variaveis['permissao'] = _permissaoUser.name; 
    _variaveis.remove('confirmarSenha');

    final userService = UserService();

    final result = await userService.cadastrar(_variaveis);

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('user', result.toJson().toString());

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao cadastrar usuário')),
      );
    }
  }

  void _goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF98E6F6), Color(0xFFFCA73B)],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Center(
                    child: Image.asset("assets/images/logo.png", width: 60),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cadastre-se',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Usuário', 'nome', Icons.person),
                  SizedBox(height: 15),
                  _buildTextField('CPF', 'cpf', Icons.insert_emoticon_rounded),
                  SizedBox(height: 15),
                  _buildTextField('E-mail', 'email', Icons.email),
                  SizedBox(height: 15),
                  _buildTextField('Telefone', 'telefone', Icons.phone),
                  SizedBox(height: 15),
                  _buildTextField('Senha', 'senha', Icons.lock, obscureText: true),
                  SizedBox(height: 15),
                  _buildTextField('Confirmar Senha', 'confirmarSenha', Icons.lock_reset_rounded, obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButtonComponent(
                    onPressed: _cadastrar,
                    text: 'Cadastrar',
                    color: Color(0xFF98E6F6),
                    textColor: Colors.black,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset("assets/images/separacao.png", width: 400,),
                  ),
                  SizedBox(height: 15),

                  GestureDetector(
                    onTap: _goToLoginPage,
                    child: Text(
                      'Já tem conta?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildTextField(String label, String key, IconData icon, {bool obscureText = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: _controllers[key],
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: Color(0xFF2596be)),
          prefixIcon: Icon(icon, size: 20),
          labelStyle: TextStyle(fontSize: 14),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2596be)),
          ),
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

