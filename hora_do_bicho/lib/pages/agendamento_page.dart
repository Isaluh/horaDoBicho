import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/agendamento_list_item.dart';
import 'package:hora_do_bicho/components/agendamento_modal.dart';
import 'package:hora_do_bicho/components/gesto.dart';
import 'package:hora_do_bicho/models/agendamento.dart';
import 'package:hora_do_bicho/models/agendamento_response.dart';
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
    if (agendamentosDoDia.isEmpty && !isAdmin) {
      _abrirFormAgendamento(selectedDay);
    } else if ((agendamentosDoDia.isNotEmpty)) {
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
            'idServico': formData['idServico'],
            'dataHoraAgendamento': dataHora.toIso8601String(),
            'observacaoAgendamento': formData['observacaoAgendamento'],
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
              if (!isAdmin)
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                    _abrirFormAgendamento(
                      agendamentos.first.dataHoraAgendamento,
                    );
                  },
                ),
            ],
          ),

          content: SizedBox(
            width: double.maxFinite,
            height: 320,
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
          onSave: (formData) async {
            try {
              print(formData);
              final dataHoraIso = formData['dataHoraAgendamento'] as String?;
              final dataHora = DateTime.parse(dataHoraIso!);

              final Map<String, dynamic> agendamentoData = {
                'idAgendamento': agendamento.idAgendamento,
                'idCliente': userId!,
                'idPet': formData['idPet'],
                'idFuncionario': formData['idFuncionario'],
                'idServico': formData['idServico'],
                'dataHoraAgendamento': dataHora.toIso8601String(),
                'observacaoAgendamento': formData['observacaoAgendamento'],
                'statusAgendamento': formData['statusAgendamento'],
              };

              if (!isAdmin) {
                final agendamentoObj = Agendamento.fromJson(agendamentoData);
                await _agendamentosService.atualizarAgendamento(agendamentoObj);
              }
              // verificar se esta atualizando o status + descrição
              await _agendamentosService.atualizarStatus(
                agendamento.idAgendamento,
                StatusExtension.fromString(
                  agendamentoData['statusAgendamento'],
                ),
                motivo: agendamento.descricaoStatus,
              );

              await _carregarConteudo();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento atualizado com sucesso!'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
              print(e);
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
                  assetPath = 'assets/images/pata_cinza.png';
                }

                return Stack(
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
