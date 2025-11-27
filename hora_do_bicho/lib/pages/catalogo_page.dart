import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/gesto.dart';
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
  late Future<List<Pet>> listPets = Future.value([]);
  late Future<List<Servico>> listServ = Future.value([]);
  late Future<List<Funcionario>> listFunc = Future.value([]);

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
    if (!mounted) return;

    final userString = prefs.getString('user');

    if (userString == null) {
      throw Exception('Usuário não encontrado');
    }

    final userJson = jsonDecode(userString);

    if (!mounted) return;
    
    setState(() {
      userId = userJson['idCliente'];
      switch (widget.conteudo) {
        case 'Pets':
          listPets = _carregarPets();
          break;
        case 'Serviços':
          listServ = _carregarServicos();
          break;
        case 'Funcionários':
          listFunc = _carregarFuncionarios();
          break;
      }
    });
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
    return await _petsService.listarPets(userId!);
  }

  Future<List<Servico>> _carregarServicos() async {
    return await _servicosService.listarServicos();
  }

  Future<List<Funcionario>> _carregarFuncionarios() async {
    return await _funcionariosService.listarFuncionarios();
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
                    listPets = _carregarPets();
                  });
                }
              } else if (tipo == FormType.servico) {
                final novoServ = await _servicosService.criarServico(data);

                if (novoServ != null) {
                  setState(() {
                    listServ = _carregarServicos();
                  });
                }
              } else if (tipo == FormType.funcionario) {
                final novoFunc = await _funcionariosService.criarFuncionario(
                  data,
                );

                if (novoFunc != null) {
                  setState(() {
                    listFunc = _carregarFuncionarios();
                  });
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erro ao criar ${widget.conteudo.toLowerCase()}: $e',
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _abrirModalEditarItem(dynamic item) {
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
                  listPets = _carregarPets();
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
            final serv = item as Servico;
            return CustomFormModal(
              formType: FormType.servico,
              formMode: FormMode.editar,
              initialData: {
                'nomeServico': serv.nomeServico,
                'descricaoServico': serv.descricaoServico,
                'precoServico': serv.precoServico,
              },
              onSave: (data) async {
                try {
                  data['idServico'] = serv.idServico.toString();
                  final servicoAtualizado = Servico.fromJson(data);

                  await _servicosService.atualizarServico(servicoAtualizado);

                  if (!mounted) return;

                  setState(() {
                    listServ = _carregarServicos();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Serviço atualizado com sucesso!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar serviço: $e')),
                  );
                }
              },
            );
          case FormType.funcionario:
            final func = item as Funcionario;
            return CustomFormModal(
              formType: FormType.funcionario,
              formMode: FormMode.editar,
              initialData: {
                'nomeFuncionario': func.nomeFuncionario,
                'cpfFuncionario': func.cpfFuncionario,
                'telefoneFuncionario': func.telefoneFuncionario,
                'cargoFuncionario' : func.cargoFuncionario
              },
              onSave: (data) async {
                try {
                  data['idFuncionario'] = func.idFuncionario.toString();
                  final funcionarioAtualizado = Funcionario.fromJson(data);

                  await _funcionariosService.atualizarFuncionario(
                    funcionarioAtualizado,
                  );

                  if (!mounted) return;

                  setState(() {
                    listFunc = _carregarFuncionarios();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionário atualizado com sucesso!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao atualizar funcionário: $e'),
                    ),
                  );
                }
              },
            );
        }
      },
    );
  }

  void _excluirItem(dynamic item) async {
    final tipo = _getFormType();

    String nomeItem = '';
    int? idItem;

    switch (tipo) {
      case FormType.pet:
        final pet = item as Pet;
        nomeItem = pet.nomePet;
        idItem = pet.idPet;
        break;

      case FormType.servico:
        final serv = item as Servico;
        nomeItem = serv.nomeServico;
        idItem = serv.idServico;
        break;

      case FormType.funcionario:
        final func = item as Funcionario;
        nomeItem = func.nomeFuncionario;
        idItem = func.idFuncionario;
        break;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Excluir $nomeItem', style: TextStyle(fontSize: 20)),
          content: Text('Tem certeza que deseja excluir $nomeItem?'),
          actions: [
            GestureDetectorComponent(
              label: 'Cancelar',
              onTap: () => Navigator.pop(context, false),
              color: Colors.black,
              fontSize: 16,
            ),
            SizedBox(width: 10),
            ElevatedButtonComponent(
              onPressed: () => Navigator.pop(context, true),
              text: 'Excluir',
              color: Color(0xFF98E6F6),
              textColor: Colors.black,
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        switch (tipo) {
          case FormType.pet:
            await _petsService.deletarPet(idItem!);
            setState(() {
              listPets = _carregarPets();
            });
            break;

          case FormType.servico:
            await _servicosService.deletarServico(idItem!);
            setState(() {
              listServ = _carregarServicos();
            });
            break;

          case FormType.funcionario:
            await _funcionariosService.deletarFuncionario(idItem!);
            setState(() {
              listFunc = _carregarFuncionarios();
            });
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nomeItem excluído com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir $nomeItem: $e')),
        );
        print(e);
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
                icon: const Icon(Icons.add, color: Colors.black, size: 20),
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
            child: widget.conteudo == 'Pets'
                ? FutureBuilder<List<Pet>>(
                    future: listPets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Nenhum pet encontrado.'));
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
                              if (value == 'editar') _abrirModalEditarItem(pet);
                              if (value == 'excluir') _excluirItem(pet);
                            },
                          );
                        },
                      );
                    },
                  )
                : widget.conteudo == 'Serviços'
                ? FutureBuilder<List<Servico>>(
                    future: listServ,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Nenhum serviço encontrado.'),
                        );
                      }
                      final servicos = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 60),
                        itemCount: servicos.length,
                        itemBuilder: (context, index) {
                          final serv = servicos[index];
                          return Ficha(
                            tipo: FichaTipo.servico,
                            nome: serv.nomeServico,
                            infoPrincipal: serv.descricaoServico,
                            infoSecundaria: 'R\$ ${serv.precoServico}',
                            imagemAsset: '',
                            onMenuSelected: (value) {
                              if (value == 'editar')
                                _abrirModalEditarItem(serv);
                              if (value == 'excluir') _excluirItem(serv);
                            },
                          );
                        },
                      );
                    },
                  )
                : FutureBuilder<List<Funcionario>>(
                    future: listFunc,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Nenhum funcionário encontrado.'),
                        );
                      }
                      final funcionarios = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 60),
                        itemCount: funcionarios.length,
                        itemBuilder: (context, index) {
                          final func = funcionarios[index];
                          return Ficha(
                            tipo: FichaTipo.funcionario,
                            nome: func.nomeFuncionario,
                            infoPrincipal: func.telefoneFuncionario,
                            infoSecundaria: func.cargoFuncionario,
                            imagemAsset: 'assets/images/vet.png',
                            onMenuSelected: (value) {
                              if (value == 'editar')
                                _abrirModalEditarItem(func);
                              if (value == 'excluir') _excluirItem(func);
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
