import 'package:flutter/material.dart';
import 'package:hora_do_bicho/models/user.dart';
import 'package:hora_do_bicho/pages/splash_page.dart';
import 'package:hora_do_bicho/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _criarAdminPadrao();
  runApp(const MyApp());
}

Future<void> _criarAdminPadrao() async {
  final userService = UserService();

  final adminData = {
    'emailCliente': 'admin',
    'telefoneCliente': '00000000000',
    'enderecoCliente': 'Rua dos Pets, 123',
    'senhaCliente': '123',
    'permissaoCliente': Permissao.ADMIN.name,
  };

  try {
    final response = await userService.cadastrar(adminData);
    if (response != null) {
      print('Admin criado com sucesso: ${response.emailCliente}');
    }
  } catch (e) {
    print('Admin já existe ou erro ao criar: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hora do Bicho',
      home: SplashPage(),
    );
  }
}
