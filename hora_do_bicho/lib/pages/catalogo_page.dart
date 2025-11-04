import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/modal.dart';
import 'package:hora_do_bicho/models/funcionario.dart';
import 'package:hora_do_bicho/models/servico.dart';
import 'package:hora_do_bicho/services/funcionarios_service.dart';
import 'package:hora_do_bicho/services/servicos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hora_do_bicho/components/ficha.dart';
import 'package:hora_do_bicho/models/pet.dart';
import 'package:hora_do_bicho/services/pets_service.dart';

class CatalogoPage extends StatefulWidget {
  final String conteudo;
  const CatalogoPage(this.conteudo, {super.key});

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  late Future<List<dynamic>> futureItens = Future.value([]);
  final PetsService _petsService = PetsService();
  final ServicosService _servicosService = ServicosService();
  final FuncionariosService _funcionariosService = FuncionariosService();
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
      switch (widget.conteudo) {
        case 'Pets':
          futureItens = _carregarPets();
          break;
        case 'Serviços':
          futureItens = _carregarServicos();
          break;
        case 'Funcionários':
          futureItens = _carregarFuncionarios();
          break;
      }
    });
  }

  String imagemPorEspecie(String especieOuRaca) {
    final texto = especieOuRaca.toLowerCase();
    if (texto.contains('gato')) return 'assets/images/gato.jpg';
    if (texto.contains('cachorro') || texto.contains('dog')) return 'assets/images/cachorro.jpg';
    if (texto.contains('ave') || texto.contains('pássaro') || texto.contains('pintin')) return 'assets/images/pintin.jpg';
    if (texto.contains('coelho') || texto.contains('hamster') || texto.contains('roedor')) return 'assets/images/coelho.jpg';
    return 'assets/images/exotico.jpg';
  }

  FormType _getFormType() {
    switch (widget.conteudo) {
      case 'Serviços':
        return FormType.servico;
      case 'Funcionários':
        return FormType.funcionario;
      default:
        return FormType.pet;
    }
  }

  Future<List<Pet>> _carregarPets() async {
    return _petsService.listarPets(userId!);
  }

  Future<List<Servico>> _carregarServicos() async {
    return _servicosService.listarServicos();
  }

  Future<List<Funcionario>> _carregarFuncionarios() async {
    return _funcionariosService.listarFuncionarios();
  }

  void _abrirModalNovoItem() {
    final tipo = _getFormType();

    showDialog(
      context: context,
      builder: (context) {
        return CustomFormModal(
          formType: tipo,
          formMode: FormMode.criar,
          onSave: (data) async {
            try {
              if (tipo == FormType.pet) {
                final petData = {...data, 'idCliente': userId};
                final novoPet = await _petsService.criarPet(petData);

                if (novoPet != null) {
                  setState(() {
                    futureItens = _carregarPets();
                  });
                }
              } else if (tipo == FormType.servico) {
                print('Criar serviço: $data');
                final novoServ = await _servicosService.criarServico(data);

                if (novoServ != null) {
                  setState(() {
                    futureItens = _carregarServicos();
                  });
                }
              } else if (tipo == FormType.funcionario) {
                print('Criar funcionário: $data');
                final novoFunc = await _funcionariosService.criarFuncionario(data);

                if (novoFunc != null) {
                  setState(() {
                    futureItens = _carregarFuncionarios();
                  });
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao criar ${widget.conteudo.toLowerCase()}: $e')),
              );
            }
          },
        );
      },
    );
  }

  void _abrirModalEditarPet(dynamic item) {
    final tipo = _getFormType();

    showDialog(
      context: context,
      builder: (context) {
        switch (tipo) {
          case FormType.pet:
          final pet = item as Pet;
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
                futureItens = _carregarPets();
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
          case FormType.servico:
            // TODO: editar serviço
            return CustomFormModal(
              formType: FormType.servico,
              formMode: FormMode.editar,
              initialData: {'titulo': 'Banho', 'descricao': '...', 'preco': '50'},
              onSave: (data) async {
                print('Editar serviço: $data');
              },
            );

          case FormType.funcionario:
            // TODO: editar funcionário
            return CustomFormModal(
              formType: FormType.funcionario,
              formMode: FormMode.editar,
              initialData: {'nome': 'Carlos', 'telefone': '99999-9999'},
              onSave: (data) async {
                print('Editar funcionário: $data');
              },
            );
        }
      },
    );
  }

  void _excluirPet(dynamic item) async {
    final tipo = _getFormType();
    String nomeItem;
    int? idItem;

    switch (tipo) {
      case FormType.pet:
        nomeItem = (item as Pet).nomePet;
        idItem = item.idPet;
        break;
      case FormType.servico:
        nomeItem = item['titulo'] ?? 'Serviço';
        break;
      case FormType.funcionario:
        nomeItem = item['nome'] ?? 'Funcionário';
        break;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Excluir $nomeItem', style: const TextStyle(fontSize: 20)),
          content: Text('Tem certeza que deseja excluir $nomeItem?'),
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
        if (tipo == FormType.pet && idItem != null) {
          await _petsService.deletarPet(idItem);
          setState(() {
            futureItens = _carregarPets();
          }
        );}else {
          print('Excluir $nomeItem');
        }
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
              Text(
                  "Catálogo de ${widget.conteudo}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C00),
                  ),
                ),
              IconButton(
                onPressed: _abrirModalNovoItem,
                icon: const Icon(Icons.add, color: Colors.black, size: 20,),
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
            child: FutureBuilder<List<dynamic>>(
              future: futureItens,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Nenhum ${widget.conteudo.toLowerCase()} encontrado.'),
                  );
                }
              

                if (widget.conteudo == 'Pets') {
                  final pets = snapshot.data as List<Pet>;
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
                }
                return const Center(child: Text('Conteúdo em desenvolvimento.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
