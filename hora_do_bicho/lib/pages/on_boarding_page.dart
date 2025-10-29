import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/pages/cadastro_page.dart';
import 'package:hora_do_bicho/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Catalogue seus pets",
      "description":
          "Crie fichas personalizadas com nome, raça, idade e outras informações do seu pet — tudo em um só lugar!",
      "image": "assets/images/caozinho.png",
      "sizeW": "180",
    },
    {
      "title": "Agende serviços e consultas",
      "description":
          "Marque banhos, tosas e consultas no petshop de forma fácil e rápida. Nunca mais perca um horário!",
      "image": "assets/images/agenda.png",
      "sizeW": "200",
    },
    {
      "title": "Vamos Começar?",
      "description":
          "Entre na sua conta ou cadastre-se para cuidar ainda melhor dos seus pequenos amigos.",
      "image": "assets/images/logo.png",
      "sizeW": "150",
    },
  ];

  void _finishOnboarding() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF98E6F6), Color(0xFFFCA73B)],
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _onboardingData[index]["image"]!,
                        width:
                            double.tryParse(_onboardingData[index]["sizeW"]!) ??
                            200,
                      ),
                      SizedBox(height: 20),
                      if (_onboardingData[index]["title"]!.isNotEmpty)
                        Text(
                          _onboardingData[index]["title"]!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(
                        _onboardingData[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),

            if (_currentPage != _onboardingData.length - 1)
              Positioned(
                top: 80,
                left: 20,
                child: GestureDetector(
                  onTap: _finishOnboarding,
                  child: Text(
                    "Pular",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0 &&
                      _currentPage < _onboardingData.length - 1)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButtonComponent(
                          onPressed: _previousPage,
                          text: 'Voltar',
                          color: Colors.white,
                          textColor: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  if (_currentPage < _onboardingData.length - 1)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButtonComponent(
                          onPressed: _nextPage,
                          text: 'Avançar',
                          color: Colors.white,
                          textColor: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  if (_currentPage == _onboardingData.length - 1)
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButtonComponent(
                            text: 'Cadastrar',
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroPage(),
                              ),
                            ),
                            color: Colors.white,
                            textColor: Colors.black,
                            minimumSize: Size(double.infinity, 40),
                          ),
                          SizedBox(height: 4),
                          ElevatedButtonComponent(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            ),
                            text: 'Login',
                            color: Color(0xFF98E6F6),
                            textColor: Colors.black,
                            minimumSize: Size(double.infinity, 40),
                          ),
                        ],
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
}
