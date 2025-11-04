import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/layout.dart';
import 'package:hora_do_bicho/models/user.dart';
import 'package:hora_do_bicho/pages/cadastro_page.dart';
import 'package:hora_do_bicho/pages/catalogo_page.dart';
import 'package:hora_do_bicho/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, TextEditingController> _controllers = {
    'emailCliente': TextEditingController(),
    'senhaCliente': TextEditingController(),
  };
  final UserService _userService = UserService();

  void _login() async {
    final username = _controllers['emailCliente']!.text;
    final password = _controllers['senhaCliente']!.text;

    if (username.trim().isEmpty || password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome de usuário ou senha não podem ser vazios'),
        ),
      );
      return;
    }

    try {
      final user = await _userService.login(username, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('user', jsonEncode(user.toJson()));
        bool isAdmin = user.permissaoCliente == Permissao.ADMIN;
        print('$isAdmin em login');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LayoutPage(body: CatalogoPage(isAdmin ? 'Funcionários' : 'Pets'),)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao realizar login')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  void _goToCadastroPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF98E6F6), Color(0xFFFCA73B)],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
              const SizedBox(height: 20),
              _buildTextField('Usuário', 'emailCliente', Icons.person),
              const SizedBox(height: 15),
              _buildTextField('Senha', 'senhaCliente', Icons.lock, obscureText: true),
              SizedBox(height: 20),

              ElevatedButtonComponent(
                onPressed: _login,
                text: 'Entrar',
                color: const Color(0xFF98E6F6),
                textColor: Colors.black,
                minimumSize: const Size(double.infinity, 40),
              ),
              SizedBox(height: 20),
              Center(
                child: Image.asset("assets/images/separacao.png", width: 400),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: _goToCadastroPage,
                child: const Text(
                  'Criar uma conta',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String key,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: _controllers[key],
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Color(0xFF2596be)),
        prefixIcon: Icon(icon, size: 20),
        labelStyle: const TextStyle(fontSize: 14),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2596be)),
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
