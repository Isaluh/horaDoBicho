import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/gesto.dart';
import 'package:hora_do_bicho/models/agendamento.dart';
import 'package:hora_do_bicho/models/agendamento_response.dart';
import 'package:hora_do_bicho/models/pet.dart';
import 'package:hora_do_bicho/services/agendamento_service.dart';
import 'package:hora_do_bicho/services/funcionarios_service.dart';
import 'package:hora_do_bicho/services/pets_service.dart';
import 'package:hora_do_bicho/services/servicos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final PetsService _petsService = PetsService();
  final ServicosService _servicosService = ServicosService();
  final FuncionariosService _funcionariosService = FuncionariosService();
  final AgendamentosService _agendamentosService = AgendamentosService();

  bool isAdmin = false;
  int? userId;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _secao = 'Calendário';

  Map<DateTime, List<AgendamentoResponse>> _agendamentosPorDia = {};
  List<AgendamentoResponse> _agendamentosDoUsuario = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString == null) return;

    final userJson = jsonDecode(userString);
    setState(() {
      userId = userJson['idCliente'];
      isAdmin = userJson['permissaoCliente'] == 'ADMIN';
    });

    _carregarConteudo();
  }

  Future<void> _carregarConteudo() async {
    final agendamentos = isAdmin
        ? await _agendamentosService.listarAgendamentos()
        : await _agendamentosService.listarAgendamentos(idCliente: userId);

    setState(() {
      _agendamentosDoUsuario = agendamentos;
    });

    _organizarPorDia();
  }

  void _organizarPorDia() {
    _agendamentosPorDia.clear();

    for (final ag in _agendamentosDoUsuario) {
      final key = DateTime(
        ag.dataHoraAgendamento.year,
        ag.dataHoraAgendamento.month,
        ag.dataHoraAgendamento.day,
      );

      _agendamentosPorDia.putIfAbsent(key, () => []).add(ag);
    }
  }

  List<AgendamentoResponse> _getAgendamentosPorDia(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _agendamentosPorDia[key] ?? [];
  }

  void _onDaySelected(DateTime selectedDay) {
    final agendamentosDoDia = _getAgendamentosPorDia(selectedDay);
    if (agendamentosDoDia.isEmpty) {
      _abrirFormAgendamento(selectedDay);
    } else {
      // mostrar listagem adicionar um editar ou um adicionar (se for admin um visualizar e um mudar status [aprovar ou cancelar])
      // _mostrarDetalhesAgendamento(agendamentosDoDia.first);
    }
  }

  void _abrirFormAgendamento(DateTime dia) async {
    final Map<String, dynamic> _formAgendamento = {
      'descricao': TextEditingController(),
      'selectedPetId': null,
      'selectedFuncionarioId': null,
      'selectedServicos': <int>[],
      'selectedHora': null,
    };

    final pets = await _petsService.listarPets(userId!);
    final funcionarios = await _funcionariosService.listarFuncionarios();
    final servicos = await _servicosService.listarServicos();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text(
                'Novo agendamento',
                style: TextStyle(fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Selecione o pet',
                        border: OutlineInputBorder(),
                      ),
                      value: _formAgendamento['selectedPetId'],
                      items: pets
                          .map<DropdownMenuItem<int>>(
                            (pet) => DropdownMenuItem<int>(
                              value: pet.idPet,
                              child: Text(pet.nomePet),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _formAgendamento['selectedPetId'] = value;
                      }),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Selecione o funcionário',
                        border: OutlineInputBorder(),
                      ),
                      value: _formAgendamento['selectedFuncionarioId'],
                      items: funcionarios
                          .map<DropdownMenuItem<int>>(
                            (func) => DropdownMenuItem<int>(
                              value: func.idFuncionario,
                              child: Text(func.nomeFuncionario),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _formAgendamento['selectedFuncionarioId'] = value;
                      }),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Serviços:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 150, // Altura fixa para permitir scroll
                      child: ListView(
                        shrinkWrap: true,
                        children: servicos.map((serv) {
                          return CheckboxListTile(
                            title: Text(serv.nomeServico),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            value: _formAgendamento['selectedServicos']
                                .contains(serv.idServico),
                            onChanged: (checked) => setState(() {
                              if (checked == true) {
                                _formAgendamento['selectedServicos'].add(
                                  serv.idServico,
                                );
                              } else {
                                _formAgendamento['selectedServicos'].remove(
                                  serv.idServico,
                                );
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // menos arredondado
                              ),
                              side: const BorderSide(
                                color: Color(0xFF6B3E26),
                              ), // opcional: borda
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              iconColor: Color(0xFF6B3E26),
                              foregroundColor: Color(0xFF6B3E26),
                            ),
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              _formAgendamento['selectedHora'] == null
                                  ? 'Selecionar hora'
                                  : _formAgendamento['selectedHora']!.format(
                                      context,
                                    ),
                            ),
                            onPressed: () async {
                              final hora = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (hora != null) {
                                setState(
                                  () => _formAgendamento['selectedHora'] = hora,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                GestureDetectorComponent(
                  onTap: () => Navigator.pop(context),
                  label: 'Cancelar',
                  color: Colors.black,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                ElevatedButtonComponent(
                  onPressed: () async {
                    if (_formAgendamento['selectedPetId'] == null ||
                        _formAgendamento['selectedFuncionarioId'] == null ||
                        _formAgendamento['selectedServicos'].isEmpty ||
                        _formAgendamento['selectedHora'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos obrigatórios.',
                          ),
                        ),
                      );
                      return;
                    }

                    final agora = DateTime.now();
                    final dataHora = DateTime(
                      dia.year,
                      dia.month,
                      dia.day,
                      _formAgendamento['selectedHora']!.hour,
                      _formAgendamento['selectedHora']!.minute,
                    );

                    final Map<String, dynamic> agendamentoData = {
                      'idCliente': userId!,
                      'idPet': _formAgendamento['selectedPetId'],
                      'idFuncionario':
                          _formAgendamento['selectedFuncionarioId'],
                      'idServico': List<int>.from(
                        _formAgendamento['selectedServicos'],
                      ),
                      'dataHoraAgendamento': dataHora.toIso8601String(),
                      'observacaoAgendamento': null,
                      'statusAgendamento': Status.EM_ANALISE.name,
                    };

                    try {
                      final novo = await _agendamentosService.criarAgendamento(
                        agendamentoData,
                      );

                      if (novo != null) {
                        await _carregarConteudo();

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Agendamento criado com sucesso!'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao criar agendamento: $e'),
                        ),
                      );
                    }
                  },
                  text: 'Salvar',
                  color: const Color(0xFF98E6F6),
                  textColor: Colors.black,
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Mostra detalhes do agendamento
  // void _mostrarDetalhesAgendamento(Map<String, dynamic> agendamento) {
  //   final status = agendamento['status'];
  //   final descricao = agendamento['descricao'];
  //   final dia = DateTime.parse(agendamento['data']);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final controller = TextEditingController(text: descricao);
  //       return AlertDialog(
  //         title: Text('Agendamento ${isAdmin ? "(${status})" : ""}'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Data: ${dia.day}/${dia.month}/${dia.year}'),
  //             const SizedBox(height: 10),
  //             TextField(
  //               controller: controller,
  //               enabled: !isAdmin && status == 'Em análise',
  //               decoration: const InputDecoration(
  //                 labelText: 'Descrição',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             if (isAdmin) ...[
  //               const Divider(),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   ElevatedButton.icon(
  //                     onPressed: () {
  //                       setState(() {
  //                         agendamento['status'] = 'Aprovado';
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     icon: const Icon(Icons.check_circle, color: Colors.white),
  //                     label: const Text('Aprovar'),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.green,
  //                     ),
  //                   ),
  //                   ElevatedButton.icon(
  //                     onPressed: () async {
  //                       final motivoController = TextEditingController();
  //                       final motivo = await showDialog<String>(
  //                         context: context,
  //                         builder: (context) {
  //                           return AlertDialog(
  //                             title: const Text('Motivo da reprovação'),
  //                             content: TextField(
  //                               controller: motivoController,
  //                               decoration: const InputDecoration(
  //                                 hintText: 'Descreva o motivo...',
  //                               ),
  //                             ),
  //                             actions: [
  //                               TextButton(
  //                                 onPressed: () => Navigator.pop(context),
  //                                 child: const Text('Cancelar'),
  //                               ),
  //                               ElevatedButton(
  //                                 onPressed: () => Navigator.pop(
  //                                   context,
  //                                   motivoController.text,
  //                                 ),
  //                                 child: const Text('Enviar'),
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       );
  //                       if (motivo != null && motivo.isNotEmpty) {
  //                         setState(() {
  //                           agendamento['status'] = 'Reprovado';
  //                           agendamento['motivo'] = motivo;
  //                         });
  //                       }
  //                       Navigator.pop(context);
  //                     },
  //                     icon: const Icon(Icons.cancel, color: Colors.white),
  //                     label: const Text('Reprovar'),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.red,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ],
  //         ),
  //         actions: [
  //           if (!isAdmin && status == 'Em análise')
  //             ElevatedButton(
  //               onPressed: () {
  //                 setState(() {
  //                   agendamento['descricao'] = controller.text;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Salvar'),
  //             ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Fechar'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _mostrarDetalhesAgendamento(AgendamentoResponse ag) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agendamento #${ag.idAgendamento}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cliente: ${ag.cliente.nomeCliente}'),
              Text('Pet: ${ag.pet.nomePet}'),
              Text('Funcionário: ${ag.funcionario.nomeFuncionario}'),
              const SizedBox(height: 10),
              Text('Serviços:'),
              ...ag.servicos.map(
                (s) => Text('- ${s.nomeServico} (R\$ ${s.precoServico})'),
              ),
              const SizedBox(height: 10),
              Text('Status: ${ag.statusAgendamento.name}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
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
              Text(
                'Agendamento',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Calendário'),
                selected: _secao == 'Calendário',
                onSelected: (_) => setState(() => _secao = 'Calendário'),
                selectedColor: const Color(0xFF98E6F6),
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
              ),
              SizedBox(width: 1),
              Container(height: 38, width: 1, color: Colors.black),
              SizedBox(width: 1),
              ChoiceChip(
                label: const Text('Listagem'),
                selected: _secao == 'Listagem',
                onSelected: (_) => setState(() => _secao = 'Listagem'),
                selectedColor: const Color(0xFF98E6F6),
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: _secao == 'Calendário'
                ? _buildCalendario()
                : _buildLista(_agendamentosDoUsuario.toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendario() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 420,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TableCalendar(
            firstDay: _focusedDay.toUtc(),
            lastDay: DateTime(
              _focusedDay.toUtc().year,
              _focusedDay.toUtc().month + 2,
              _focusedDay.toUtc().day,
            ),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, _) {
              _onDaySelected(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            eventLoader: _getAgendamentosPorDia,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFF98E6F6),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;

                final hasEmAnalise = events.any(
                  (event) =>
                      (event as AgendamentoResponse).statusAgendamento!.name ==
                      'EM_ANALISE',
                );
                final allAprovado = events.every(
                  (event) =>
                      (event as AgendamentoResponse).statusAgendamento!.name ==
                      'APROVADO',
                );

                String assetPath;

                if (hasEmAnalise) {
                  assetPath = 'assets/images/pata.png';
                } else if (allAprovado) {
                  assetPath = 'assets/images/pataAzul.png';
                } else {
                  // Caso tenha algum status diferente, pode colocar uma pata cinza, ou nada
                  return null;
                }

                return Stack(
                  // colocar a primeira no laranja
                  alignment: Alignment.center,
                  children: [
                    if (hasEmAnalise)
                      Positioned(
                        top: 10,
                        child: Image.asset(
                          'assets/images/pata.png',
                          width: 30,
                          height: 30,
                        ),
                      )
                    else if (allAprovado)
                      Positioned(
                        top: 10,
                        child: Image.asset(
                          'assets/images/pataAzul.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLista(List<AgendamentoResponse> agendamentos) {
    if (agendamentos.isEmpty) {
      return const Center(child: Text('Nenhum agendamento encontrado.'));
    }

    return ListView.builder(
      itemCount: agendamentos.length,
      itemBuilder: (context, index) {
        final ag = agendamentos[index];

        final data = ag.dataHoraAgendamento;
        final dataFormatada =
            '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} '
            '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: ListTile(
            title: Text('Agendamento #${ag.idAgendamento}'),
            subtitle: Text(
              'Cliente: ${ag.cliente.nomeCliente}\n'
              'Pet: ${ag.pet.nomePet}\n'
              'Funcionário: ${ag.funcionario.nomeFuncionario}\n'
              'Data: $dataFormatada\n'
              'Status: ${ag.statusAgendamento.name}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _mostrarDetalhesAgendamento(ag),
            ),
          ),
        );
      },
    );
  }
}
