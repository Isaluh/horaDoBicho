import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  bool isAdmin = false;
  int? userId;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _secao = 'Calendário';

  // Aqui futuramente virão seus agendamentos do service
  Map<DateTime, List<Map<String, dynamic>>> _agendamentos = {};

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
  }

  /// Exemplo: verificar se há agendamento nesse dia
  List<Map<String, dynamic>> _getAgendamentosPorDia(DateTime day) {
    return _agendamentos[DateTime(day.year, day.month, day.day)] ?? [];
  }

  /// Clicou em um dia
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // setState(() {
    //   _selectedDay = selectedDay;
    //   _focusedDay = focusedDay;
    // });

    final agendamentosDoDia = _getAgendamentosPorDia(selectedDay);
    if (agendamentosDoDia.isEmpty) {
      _abrirFormAgendamento(selectedDay);
    } else {
      _mostrarDetalhesAgendamento(agendamentosDoDia.first);
    }
  }

  void _abrirFormAgendamento(DateTime dia) async {
    final descricaoController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Novo agendamento'),
          content: TextField(
            controller: descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novo = {
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'idCliente': userId,
                  'descricao': descricaoController.text,
                  'status': 'Em análise',
                  'data': dia.toIso8601String(),
                };
                setState(() {
                  final key = DateTime(dia.year, dia.month, dia.day);
                  _agendamentos.putIfAbsent(key, () => []).add(novo);
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  /// Mostra detalhes do agendamento
  void _mostrarDetalhesAgendamento(Map<String, dynamic> agendamento) {
    final status = agendamento['status'];
    final descricao = agendamento['descricao'];
    final dia = DateTime.parse(agendamento['data']);

    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: descricao);
        return AlertDialog(
          title: Text('Agendamento ${isAdmin ? "(${status})" : ""}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Data: ${dia.day}/${dia.month}/${dia.year}'),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                enabled: !isAdmin && status == 'Em análise',
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              if (isAdmin) ...[
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          agendamento['status'] = 'Aprovado';
                        });
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text('Aprovar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final motivoController = TextEditingController();
                        final motivo = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Motivo da reprovação'),
                              content: TextField(
                                controller: motivoController,
                                decoration: const InputDecoration(
                                  hintText: 'Descreva o motivo...',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(
                                    context,
                                    motivoController.text,
                                  ),
                                  child: const Text('Enviar'),
                                ),
                              ],
                            );
                          },
                        );
                        if (motivo != null && motivo.isNotEmpty) {
                          setState(() {
                            agendamento['status'] = 'Reprovado';
                            agendamento['motivo'] = motivo;
                          });
                        }
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text('Reprovar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            if (!isAdmin && status == 'Em análise')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    agendamento['descricao'] = controller.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final agendamentosLista = _agendamentos.values.expand((e) => e).toList();
    final agendamentosFiltrados = isAdmin
        ? agendamentosLista
        : agendamentosLista.where((a) => a['idCliente'] == userId).toList();

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
                backgroundColor:
                    Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                  side: BorderSide.none, 
                ),
              ),
              SizedBox(width: 2,),
              Container(
                height: 38,
                width: 1,
                color: Colors.black,
              ),
              SizedBox(width: 2,),
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
                : _buildLista(agendamentosFiltrados),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendario() {
    return TableCalendar(
      firstDay: _focusedDay.toUtc(),
      lastDay: DateTime(
        _focusedDay.toUtc().year,
        _focusedDay.toUtc().month + 2,
        _focusedDay.toUtc().day,
      ),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      availableCalendarFormats: const { CalendarFormat.month: 'Month' },
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
        // selectedDecoration: BoxDecoration(
        //   color: Color(0xFFFCA73B),
        //   shape: BoxShape.circle,
        // ),
        // markerDecoration: BoxDecoration(
        //   color: Colors.red,
        //   shape: BoxShape.circle,
        // ),
      ),
    );
  }

  Widget _buildLista(List<Map<String, dynamic>> agendamentos) {
    if (agendamentos.isEmpty) {
      return const Center(child: Text('Nenhum agendamento encontrado.'));
    }

    return ListView.builder(
      itemCount: agendamentos.length,
      itemBuilder: (context, index) {
        final ag = agendamentos[index];
        final data = DateTime.parse(ag['data']);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(ag['descricao'] ?? 'Sem descrição'),
            subtitle: Text(
              'Data: ${data.day}/${data.month}/${data.year} - Status: ${ag['status']}',
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
