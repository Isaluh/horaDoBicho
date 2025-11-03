import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hora_do_bicho/components/ficha.dart';
import 'package:hora_do_bicho/models/pet.dart';
import 'package:hora_do_bicho/services/pets_service.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  late Future<List<Pet>> futurePets = Future.value([]);
  final PetsService _petsService = PetsService();
  int? userId;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  Future<void> _initUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString == null) {
      throw Exception('Usuário não encontrado no SharedPreferences');
    }

    final userJson = jsonDecode(userString);
    setState(() {
      userId = userJson['idCliente'];
      futurePets = _carregarPets();
    });
  }

  String imagemPorEspecie(String especieOuRaca) {
    final texto = especieOuRaca.toLowerCase();

    if (texto.toLowerCase().contains('gato')) return 'assets/images/gato.jpg';
    if (texto.toLowerCase().contains('cachorro') ||
        texto.toLowerCase().contains('dog')) {
      return 'assets/images/cachorro.jpg';
    }
    if (texto.toLowerCase().contains('ave') ||
        texto.toLowerCase().contains('pássaro') ||
        texto.toLowerCase().contains('pintin')) {
      return 'assets/images/pintin.jpg';
    }
    if (texto.toLowerCase().contains('coelho') ||
        texto.toLowerCase().contains('hamster') ||
        texto.toLowerCase().contains('roedor')) {
      return 'assets/images/coelho.jpg';
    }
    return 'assets/images/exotico.jpg';
  }

  Future<List<Pet>> _carregarPets() async {
    return _petsService.listarPets(userId!);
  }

  void _abrirModalEditarPet(Pet pet) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomFormModal(
          formType: FormType.pet,
          formMode: FormMode.editar,
          initialData: {
            'nomePet': pet.nomePet,
            'idadePet': pet.idadePet,
            'especiePet': pet.especiePet,
            'racaPet': pet.racaPet,
          },
          onSave: (data) async {
            data['idPet'] = pet.idPet.toString();

            data['idCliente'] = userId.toString();
            Pet updatePet = Pet.fromJson(data);

            await _petsService.atualizarPet(updatePet);
            if (!mounted) return;
            setState(() {
              futurePets = _carregarPets();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pet atualizado com sucesso!')),
            );
            try {} catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao atualizar pet: $e')),
              );
            }
          },
        );
      },
    );
  }

  void _excluirPet(Pet pet) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Excluir Pet', style: TextStyle(fontSize: 20)),
          content: Text('Tem certeza que deseja excluir ${pet.nomePet}?'),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButtonComponent(
              onPressed: () => Navigator.pop(context, true),
              text: 'Excluir',
              color: const Color(0xFF98E6F6),
              textColor: Colors.black,
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _petsService.deletarPet(pet.idPet);
        setState(() {
          futurePets = _carregarPets();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet excluído com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao excluir pet: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
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
                "Catálogo de Pets",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C00),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomFormModal(
                        formType: FormType.pet,
                        formMode: FormMode.criar,
                        onSave: (data) async {
                          try {
                            final petData = {...data, 'idCliente': userId};
                            final petsService = PetsService();
                            final novoPet = await petsService.criarPet(petData);

                            if (novoPet != null) {
                              setState(() {
                                futurePets = _carregarPets();
                              });
                            }
                          } catch (e) {
                            print('Erro ao criar pet: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao criar pet'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  "Add pet",
                  style: TextStyle(color: Colors.black),
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
          const SizedBox(height: 10),

          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: futurePets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  _carregarPets();
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum pet catalogado ainda.'),
                  );
                }

                final pets = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Ficha(
                      tipo: FichaTipo.pet,
                      nome: pet.nomePet,
                      infoPrincipal: pet.idadePet,
                      infoSecundaria: pet.racaPet,
                      imagemAsset: imagemPorEspecie(pet.especiePet),
                      onMenuSelected: (value) {
                        if (value == 'editar') {
                          _abrirModalEditarPet(pet);
                        } else if (value == 'excluir') {
                          _excluirPet(pet);
                        } else if (value == 'agendar') {
                          // ação futura
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
