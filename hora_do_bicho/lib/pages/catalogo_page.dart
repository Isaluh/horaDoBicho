import 'dart:convert';
import 'package:flutter/material.dart';
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
  late Future<List<Pet>> futurePets;
  final PetsService _petsService = PetsService();

  @override
  void initState() {
    super.initState();
    futurePets = _carregarPets();
  }

  String imagemPorEspecie(String especieOuRaca) {
    final texto = especieOuRaca.toLowerCase();

    if (texto.contains('gato')) return 'assets/images/gato.jpg';
    if (texto.contains('cachorro') || texto.contains('dog')) {
      return 'assets/images/cachorro.jpg';
    }
    if (texto.contains('ave') ||
        texto.contains('pássaro') ||
        texto.contains('pintin')) {
      return 'assets/images/pintin.jpg';
    }
    if (texto.contains('coelho') ||
        texto.contains('hamster') ||
        texto.contains('roedor')) {
      return 'assets/images/coelho.jpg';
    }
    return 'assets/images/exotico.jpg';
  }

  Future<List<Pet>> _carregarPets() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString == null) {
      throw Exception('Usuário não encontrado no SharedPreferences');
    }

    final userJson = jsonDecode(userString);
    final userId = userJson['idCliente'];

    return _petsService.listarPets(userId);
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
            print(data);
            Pet updatePet = Pet.fromJson(data);
            print(updatePet);
            await _petsService.atualizarPet(updatePet);
            setState(() {
              futurePets = _carregarPets();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pet atualizado com sucesso!')),
            );
            // try {
            // } catch (e) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('Erro ao atualizar pet: $e')),
            //   );
            // }
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
          title: const Text('Excluir Pet'),
          content: Text('Tem certeza que deseja excluir ${pet.nomePet}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
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
                            final prefs = await SharedPreferences.getInstance();
                            final userString = prefs.getString('user');
                            if (userString == null)
                              throw Exception('Usuário não logado');

                            final userJson = jsonDecode(userString);
                            final userId = userJson['idCliente'];

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
