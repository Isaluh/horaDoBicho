import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/models/user.dart';
import 'package:hora_do_bicho/pages/agendamento_page.dart';
import 'package:hora_do_bicho/pages/catalogo_page.dart';
import 'package:hora_do_bicho/pages/login_page.dart';
import 'package:hora_do_bicho/pages/perfil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutPage extends StatefulWidget {
  final Widget body;
  const LayoutPage({super.key, required this.body});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _selectedIndex = 0;
  late bool isAdmin;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUserPermissions();
  }

  _loadUserPermissions() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? userJson = prefs.getString('user');

    // if (userJson != null) {
    //   Map<String, dynamic> userMap = jsonDecode(userJson);
    //   User user = User.fromJson(userMap);

    //   print(user.nome);
    //   print(user.permissao);

    //   setState(() {
    //     isAdmin = user.permissao == Permissao.ADMIN;

    //     _pages = isAdmin
    //         ? [
    //             CatalogoPage(),
    //             CatalogoPage(),
    //             AgendamentoPage(),
    //             PerfilPage()
    //           ]
    //         : [
    //             CatalogoPage(),
    //             AgendamentoPage(),
    //             PerfilPage()
    //           ];
    //   });
    // }

    setState(() {
      isAdmin = false;

      _pages = isAdmin
          ? [CatalogoPage(), CatalogoPage(), AgendamentoPage(), PerfilPage()]
          : [CatalogoPage(), AgendamentoPage(), PerfilPage()];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconList = isAdmin
        ? [Icons.business, Icons.settings, Icons.schedule, Icons.account_circle]
        : [Icons.pets, Icons.schedule, Icons.account_circle];

    final items = List.generate(
      iconList.length,
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: Icon(
          iconList[index],
          size: 30,
          color: _selectedIndex == index ? Color(0xFF6B3E26) : Color.fromARGB(255, 226, 124, 0),
        ),
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF98E6F6), Color(0xFFFCA73B)],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: Image.asset('assets/images/logo.png', width: 70),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.logout_outlined, color: Color(0xFF6B3E26)),
                onPressed: _logout,
              ),
            ],
            toolbarHeight: 70,
            elevation: 0,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fundo.png"),
                    fit: BoxFit.cover,
                    opacity: 0.7
                  ),
                ),
              ),
            ),
          ),

          widget.body,
        ],
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: Color(0xFFFCA73B),
        buttonBackgroundColor: Color(0xFFFCA73B),
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        onTap: _onItemTapped,
      ),
    );
  }
}
