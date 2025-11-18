import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';
import 'package:hora_do_bicho/components/gesto.dart';
import 'package:hora_do_bicho/models/agendamento.dart';
import 'package:hora_do_bicho/models/agendamento_response.dart';
import 'package:hora_do_bicho/models/funcionario.dart';
import 'package:hora_do_bicho/models/pet.dart';
import 'package:hora_do_bicho/models/servico.dart';
import 'package:hora_do_bicho/services/funcionarios_service.dart';
import 'package:hora_do_bicho/services/pets_service.dart';
import 'package:hora_do_bicho/services/servicos_service.dart';

enum AgendamentoFormMode { novo, editar }

class AgendamentoFormModal extends StatefulWidget {
  final AgendamentoFormMode mode;
  final DateTime? dia;
  final AgendamentoResponse? agendamento;
  final bool isAdmin;
  final int userId;
  final Function(Map<String, dynamic>) onSave;

  const AgendamentoFormModal({
    super.key,
    required this.mode,
    this.dia,
    this.agendamento,
    required this.isAdmin,
    required this.userId,
    required this.onSave,
  });

  @override
  State<AgendamentoFormModal> createState() => _AgendamentoFormModalState();
}

class _AgendamentoFormModalState extends State<AgendamentoFormModal> {
  late Map<String, dynamic> _formAgendamento;

  List<Pet> pets = [];
  List<Funcionario> funcionarios = [];
  List<Servico> servicos = [];
  bool hasStatus = false;

  final PetsService _petsService = PetsService();
  final ServicosService _servicosService = ServicosService();
  final FuncionariosService _funcionariosService = FuncionariosService();

  @override
  void initState() {
    super.initState();
    _initForm();
    _carregarDados();
  }

  void _initForm() {
    if (widget.mode == AgendamentoFormMode.novo) {
      _formAgendamento = {
        'observacaoAgendamento': TextEditingController(),
        'selectedPetId': null,
        'selectedFuncionarioId': null,
        'selectedServicos': <int>[],
        'selectedHora': null,
      };
      hasStatus = false;
    } else {
      final ag = widget.agendamento!;
      _formAgendamento = {
        'observacaoAgendamento': TextEditingController(
          text: ag.observacaoAgendamento ?? '',
        ),
        'selectedPetId': ag.pet.idPet,
        'selectedFuncionarioId': ag.funcionario.idFuncionario,
        'selectedServicos': ag.servicos.map((s) => s.idServico).toList(),
        'selectedHora': TimeOfDay(
          hour: ag.dataHoraAgendamento.hour,
          minute: ag.dataHoraAgendamento.minute,
        ),
        'status': ag.statusAgendamento,
        'descricaoStatus': TextEditingController(
          text: ag.descricaoStatus ?? '',
        ),
      };
      hasStatus = widget.agendamento?.statusAgendamento != Status.EM_ANALISE
          ? true
          : false;
    }
  }

  Future<void> _carregarDados() async {
    pets = await _petsService.listarPets(widget.userId);
    funcionarios = await _funcionariosService.listarFuncionarios();
    servicos = await _servicosService.listarServicos();
    setState(() {});
  }

  void _salvar() async {
    if (!widget.isAdmin) {
      if (_formAgendamento['selectedPetId'] == null ||
          _formAgendamento['selectedFuncionarioId'] == null ||
          _formAgendamento['selectedServicos'].isEmpty ||
          _formAgendamento['selectedHora'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha todos os campos obrigatórios.'),
          ),
        );
        return;
      }
    }

    final dataHora = _formAgendamento['selectedHora'] != null
        ? DateTime(
            widget.mode == AgendamentoFormMode.novo
                ? widget.dia!.year
                : widget.agendamento!.dataHoraAgendamento.year,
            widget.mode == AgendamentoFormMode.novo
                ? widget.dia!.month
                : widget.agendamento!.dataHoraAgendamento.month,
            widget.mode == AgendamentoFormMode.novo
                ? widget.dia!.day
                : widget.agendamento!.dataHoraAgendamento.day,
            _formAgendamento['selectedHora']!.hour,
            _formAgendamento['selectedHora']!.minute,
          )
        : widget.agendamento?.dataHoraAgendamento;

    final agendamentoData = {
      'idAgendamento': widget.agendamento?.idAgendamento,
      'idCliente': widget.userId,
      'idPet': _formAgendamento['selectedPetId'],
      'idFuncionario': _formAgendamento['selectedFuncionarioId'],
      'idServico': _formAgendamento['selectedServicos'],
      'dataHoraAgendamento': dataHora?.toIso8601String(),
      'observacaoAgendamento': _formAgendamento['observacaoAgendamento'].text,
      'statusAgendamento': Status.EM_ANALISE.name,
    };

    widget.onSave(agendamentoData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        widget.mode == AgendamentoFormMode.novo
            ? 'Novo agendamento'
            : 'Detalhes',
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
                  .map(
                    (pet) => DropdownMenuItem(
                      value: pet.idPet,
                      child: Text(pet.nomePet),
                    ),
                  )
                  .toList(),
              onChanged: widget.isAdmin
                  ? null
                  : (v) =>
                        setState(() => _formAgendamento['selectedPetId'] = v),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Selecione o funcionário',
                border: OutlineInputBorder(),
              ),
              value: _formAgendamento['selectedFuncionarioId'],
              items: funcionarios
                  .map(
                    (f) => DropdownMenuItem(
                      value: f.idFuncionario,
                      child: Text(f.nomeFuncionario),
                    ),
                  )
                  .toList(),
              onChanged: widget.isAdmin
                  ? null
                  : (v) => setState(
                      () => _formAgendamento['selectedFuncionarioId'] = v,
                    ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Serviços:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                shrinkWrap: true,
                children: servicos.map((s) {
                  return CheckboxListTile(
                    title: Text(s.nomeServico),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: _formAgendamento['selectedServicos'].contains(
                      s.idServico,
                    ),
                    onChanged: widget.isAdmin
                        ? null
                        : (checked) {
                            setState(() {
                              if (checked == true) {
                                _formAgendamento['selectedServicos'].add(
                                  s.idServico,
                                );
                              } else {
                                _formAgendamento['selectedServicos'].remove(
                                  s.idServico,
                                );
                              }
                            });
                          },
                  );
                }).toList(),
              ),
            ),

            TextFormField(
              controller: _formAgendamento['observacaoAgendamento'],
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: const BorderSide(color: Color(0xFF6B3E26)),
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
                          : _formAgendamento['selectedHora'].format(context),
                    ),
                    onPressed: widget.isAdmin
                        ? null
                        : () async {
                            final hora = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (hora != null) {
                              setState(() {
                                _formAgendamento['selectedHora'] = hora;
                              });
                            }
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: widget.isAdmin
          ? [
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Aprovar'),
                    selected:
                        _formAgendamento['status'] == Status.APROVADO.name,
                    onSelected: (_) {
                      setState(() {
                        hasStatus = true;
                        _formAgendamento['status'] = Status.APROVADO.name;
                        print(hasStatus);
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Recusar'),
                    selected:
                        _formAgendamento['status'] == Status.CANCELADO.name,
                    onSelected: (_) {
                      setState(() {
                        hasStatus = true;
                        _formAgendamento['status'] = Status.CANCELADO.name;
                        print(hasStatus);
                      });
                    },
                  ),
                ],
              ),

              if (hasStatus)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    controller: _formAgendamento['descricaoStatus'],
                    decoration: const InputDecoration(
                      labelText: 'Motivo/Obs',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ),

              const SizedBox(width: 15),
              Row(
                // arrumar onde fica e mandar n so o status como tbm a descricao
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetectorComponent(
                    onTap: () => Navigator.pop(context),
                    label: 'Cancelar',
                    color: Colors.black,
                    fontSize: 16,
                  ),

                  const SizedBox(width: 10),

                  ElevatedButtonComponent(
                    onPressed: _salvar,
                    text: 'Confirmar',
                    color: const Color(0xFF98E6F6),
                    textColor: Colors.black,
                  ),
                ],
              ),
            ]
          : [
              GestureDetectorComponent(
                onTap: () => Navigator.pop(context),
                label: 'Cancelar',
                color: Colors.black,
                fontSize: 16,
              ),
              const SizedBox(width: 10),
              ElevatedButtonComponent(
                onPressed: _salvar,
                text: 'Salvar',
                color: const Color(0xFF98E6F6),
                textColor: Colors.black,
              ),
            ],
    );
  }
}
