import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/agendamento_list_item.dart';
import 'package:hora_do_bicho/components/agendamento_modal.dart';
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
      _mostrarListaAgendamentos(agendamentosDoDia);
    }
  }

  void _abrirFormAgendamento(DateTime dia) async {
    await showDialog(
      context: context,
      builder: (_) => AgendamentoFormModal(
        mode: AgendamentoFormMode.novo,
        dia: dia,
        userId: userId!,
        isAdmin: isAdmin,
        onSave: (formData) async {
          final dataHoraIso = formData['dataHoraAgendamento'] as String?;
          final dataHora = DateTime.parse(dataHoraIso!);

          final Map<String, dynamic> agendamentoData = {
            'idCliente': userId!,
            'idPet': formData['idPet'],
            'idFuncionario': formData['idFuncionario'],
            'idServico': List<int>.from(formData['selectedServicos'] ?? []),
            'dataHoraAgendamento': dataHora.toIso8601String(),
            'observacaoAgendamento':
                formData['descricao']?.text?.isEmpty ?? true
                ? null
                : formData['descricao']!.text,
            'statusAgendamento': Status.EM_ANALISE.name,
          };

          try {
            final novo = await _agendamentosService.criarAgendamento(
              agendamentoData,
            );
            if (novo != null) {
              await _carregarConteudo();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento criado com sucesso!'),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao criar agendamento: $e')),
            );
          }
        },
      ),
    );
  }

  void _mostrarListaAgendamentos(List<AgendamentoResponse> agendamentos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Agendados do dia', style: TextStyle(fontSize: 20)),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                  _abrirFormAgendamento(agendamentos.first.dataHoraAgendamento);
                },
              ),
            ],
          ),

          content: SizedBox(
            width: double.maxFinite,
            height: 320, // scroll limitado
            child: ListView.separated(
              itemCount: agendamentos.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 14, thickness: 1),
              itemBuilder: (context, index) {
                final ag = agendamentos[index];

                return AgendamentoListItem(
                  agendamento: ag,
                  onTap: () {
                    Navigator.pop(context);
                    _mostrarDetalhesAgendamento(ag);
                  },
                );
              },
            ),
          ),

          actions: [
            GestureDetectorComponent(
              onTap: () => Navigator.pop(context),
              label: 'Fechar',
              color: Colors.black,
              fontSize: 16,
            ),
          ],
        );
      },
    );
  }

  // void _mostrarDetalhesAgendamento(AgendamentoResponse agendamento) async {
  //   final Map<String, dynamic> _formAgendamento = {
  //     'descricao': TextEditingController(
  //       text: agendamento.observacaoAgendamento ?? '',
  //     ),
  //     'selectedPetId': agendamento.pet.idPet,
  //     'selectedFuncionarioId': agendamento.funcionario.idFuncionario,
  //     'selectedServicos': agendamento.servicos.map((s) => s.idServico).toList(),
  //     'selectedHora': TimeOfDay(
  //       hour: agendamento.dataHoraAgendamento.hour,
  //       minute: agendamento.dataHoraAgendamento.minute,
  //     ),
  //     'status': agendamento.statusAgendamento,
  //   };
  //   final pets = await _petsService.listarPets(userId!);
  //   final funcionarios = await _funcionariosService.listarFuncionarios();
  //   final servicos = await _servicosService.listarServicos();
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             title: const Text(
  //               'Detalhes do agendamento',
  //               style: TextStyle(fontSize: 20),
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Pet
  //                   DropdownButtonFormField<int>(
  //                     decoration: const InputDecoration(
  //                       labelText: 'Selecione o pet',
  //                       border: OutlineInputBorder(),
  //                     ),
  //                     value: _formAgendamento['selectedPetId'],
  //                     items: pets.map((pet) {
  //                       return DropdownMenuItem(
  //                         value: pet.idPet,
  //                         child: Text(pet.nomePet),
  //                       );
  //                     }).toList(),
  //                     onChanged: isAdmin
  //                         ? null
  //                         : (value) => setState(
  //                             () => _formAgendamento['selectedPetId'] = value,
  //                           ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Funcionário
  //                   DropdownButtonFormField<int>(
  //                     decoration: const InputDecoration(
  //                       labelText: 'Selecione o funcionário',
  //                       border: OutlineInputBorder(),
  //                     ),
  //                     value: _formAgendamento['selectedFuncionarioId'],
  //                     items: funcionarios.map((func) {
  //                       return DropdownMenuItem(
  //                         value: func.idFuncionario,
  //                         child: Text(func.nomeFuncionario),
  //                       );
  //                     }).toList(),
  //                     onChanged: isAdmin
  //                         ? null
  //                         : (value) => setState(
  //                             () => _formAgendamento['selectedFuncionarioId'] =
  //                                 value,
  //                           ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Serviços
  //                   const Text(
  //                     'Serviços:',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(
  //                     height: 150,
  //                     child: ListView(
  //                       shrinkWrap: true,
  //                       children: servicos.map((serv) {
  //                         return CheckboxListTile(
  //                           title: Text(serv.nomeServico),
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           value: _formAgendamento['selectedServicos']
  //                               .contains(serv.idServico),
  //                           onChanged: isAdmin
  //                               ? null
  //                               : (checked) => setState(() {
  //                                   if (checked == true) {
  //                                     _formAgendamento['selectedServicos'].add(
  //                                       serv.idServico,
  //                                     );
  //                                   } else {
  //                                     _formAgendamento['selectedServicos']
  //                                         .remove(serv.idServico);
  //                                   }
  //                                 }),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Hora
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: OutlinedButton.icon(
  //                           style: OutlinedButton.styleFrom(
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             side: const BorderSide(color: Color(0xFF6B3E26)),
  //                             padding: const EdgeInsets.symmetric(
  //                               vertical: 12,
  //                               horizontal: 16,
  //                             ),
  //                             iconColor: Color(0xFF6B3E26),
  //                             foregroundColor: Color(0xFF6B3E26),
  //                           ),
  //                           icon: const Icon(Icons.access_time),
  //                           label: Text(
  //                             _formAgendamento['selectedHora'] == null
  //                                 ? 'Selecionar hora'
  //                                 : _formAgendamento['selectedHora'].format(
  //                                     context,
  //                                   ),
  //                           ),
  //                           onPressed: isAdmin
  //                               ? null
  //                               : () async {
  //                                   final hora = await showTimePicker(
  //                                     context: context,
  //                                     initialTime: TimeOfDay.now(),
  //                                   );
  //                                   if (hora != null) {
  //                                     setState(
  //                                       () => _formAgendamento['selectedHora'] =
  //                                           hora,
  //                                     );
  //                                   }
  //                                 },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Observação (sempre editável)
  //                   TextFormField(
  //                     controller: _formAgendamento['observacao'],
  //                     decoration: const InputDecoration(
  //                       labelText: 'Observação',
  //                       border: OutlineInputBorder(),
  //                     ),
  //                     maxLines: 3,
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // Status (apenas para admin, botões)
  //                   if (isAdmin)
  //                     Row(
  //                       children: [
  //                         Text(
  //                           'Status: ',
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                         const SizedBox(width: 10),
  //                         ChoiceChip(
  //                           label: const Text('APROVADO'),
  //                           selected:
  //                               _formAgendamento['status'] ==
  //                               Status.APROVADO.name,
  //                           onSelected: (_) => setState(
  //                             () => _formAgendamento['status'] =
  //                                 Status.APROVADO.name,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 10),
  //                         ChoiceChip(
  //                           label: const Text('CANCELADO'),
  //                           selected:
  //                               _formAgendamento['status'] ==
  //                               Status.CANCELADO.name,
  //                           onSelected: (_) => setState(
  //                             () => _formAgendamento['status'] =
  //                                 Status.CANCELADO.name,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               GestureDetectorComponent(
  //                 onTap: () => Navigator.pop(context),
  //                 label: 'Cancelar',
  //                 color: Colors.black,
  //                 fontSize: 16,
  //               ),
  //               SizedBox(width: 10),
  //               ElevatedButtonComponent(
  //                 onPressed: () async {
  //                   // Validação para cliente
  //                   if (!isAdmin) {
  //                     if (_formAgendamento['selectedPetId'] == null ||
  //                         _formAgendamento['selectedFuncionarioId'] == null ||
  //                         _formAgendamento['selectedServicos'].isEmpty ||
  //                         _formAgendamento['selectedHora'] == null) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                           content: Text(
  //                             'Preencha todos os campos obrigatórios.',
  //                           ),
  //                         ),
  //                       );
  //                       return;
  //                     }
  //                   }
  //                   final dataHora = _formAgendamento['selectedHora'] != null
  //                       ? DateTime(
  //                           agendamento.dataHoraAgendamento.year,
  //                           agendamento.dataHoraAgendamento.month,
  //                           agendamento.dataHoraAgendamento.day,
  //                           _formAgendamento['selectedHora']!.hour,
  //                           _formAgendamento['selectedHora']!.minute,
  //                         )
  //                       : agendamento.dataHoraAgendamento;
  //                   final Map<String, dynamic> agendamentoData = {
  //                     'idAgendamento': agendamento.idAgendamento,
  //                     'idCliente': userId,
  //                     'idPet': _formAgendamento['selectedPetId'],
  //                     'idFuncionario':
  //                         _formAgendamento['selectedFuncionarioId'],
  //                     'idServico': _formAgendamento['selectedServicos'],
  //                     'dataHoraAgendamento': dataHora.toIso8601String(),
  //                     'observacaoAgendamento':
  //                         _formAgendamento['observacao'].text,
  //                     'statusAgendamento':
  //                         _formAgendamento['status'] ?? Status.EM_ANALISE.name,
  //                   };
  //                   try {
  //                     // ta mudando so o status tem q colocar tbm o obs do status
  //                     if (isAdmin) {
  //                       await _agendamentosService.atualizarStatus(
  //                         agendamento.idAgendamento,
  //                         StatusExtension.fromString(
  //                           _formAgendamento['status'],
  //                         ),
  //                       );
  //                     } else {
  //                       final agendamentoObj = Agendamento.fromJson(
  //                         agendamentoData,
  //                       );
  //                       await _agendamentosService.atualizarAgendamento(
  //                         agendamentoObj,
  //                       );
  //                     }
  //                     await _carregarConteudo();
  //                     Navigator.pop(context);
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text('Agendamento atualizado com sucesso!'),
  //                       ),
  //                     );
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text('Erro ao atualizar: $e')),
  //                     );
  //                   }
  //                 },
  //                 text: 'Salvar',
  //                 color: const Color(0xFF98E6F6),
  //                 textColor: Colors.black,
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

// TESTAR EDIÇÃO E VERIFICAR SE SERVIÇOS ESTA SENDO ENVIADO
  void _mostrarDetalhesAgendamento(AgendamentoResponse agendamento) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AgendamentoFormModal(
          mode: AgendamentoFormMode.editar,
          dia: agendamento.dataHoraAgendamento,
          agendamento: agendamento,
          isAdmin: isAdmin,
          userId: userId!,
          onSave: (agendamentoData) async {
            try {
              if (isAdmin) {
                // Apenas atualiza o status
                await _agendamentosService.atualizarStatus(
                  agendamento.idAgendamento,
                  StatusExtension.fromString(
                    agendamentoData['statusAgendamento'],
                  ),
                );
              } else {
                // Atualiza todo o agendamento
                final agendamentoObj = Agendamento.fromJson(agendamentoData);
                await _agendamentosService.atualizarAgendamento(agendamentoObj);
              }

              await _carregarConteudo(); // Recarrega a lista/visualização
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento atualizado com sucesso!'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
            }
          },
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
                  assetPath = 'assets/images/pataLaranja.png';
                } else if (allAprovado) {
                  assetPath = 'assets/images/pata.png';
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
                        child: Image.asset(assetPath, width: 30, height: 30),
                      )
                    else if (allAprovado)
                      Positioned(
                        top: 10,
                        child: Image.asset(assetPath, width: 30, height: 30),
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

    List<AgendamentoResponse> agendamentosOrdenados = List.from(agendamentos);
    agendamentosOrdenados.sort(
      (a, b) => b.dataHoraAgendamento.compareTo(a.dataHoraAgendamento),
    );

    return ListView.builder(
      itemCount: agendamentosOrdenados.length,
      itemBuilder: (context, index) {
        final ag = agendamentosOrdenados[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: AgendamentoListItem(
            agendamento: ag,
            onTap: () => _mostrarDetalhesAgendamento(ag),
          ),
        );
      },
    );
  }
}
