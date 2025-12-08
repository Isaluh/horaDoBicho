import 'package:hora_do_bicho/models/agendamento.dart';
import 'package:hora_do_bicho/models/funcionario.dart';
import 'package:hora_do_bicho/models/pet.dart';
import 'package:hora_do_bicho/models/servico.dart';
import 'package:hora_do_bicho/models/user.dart';

class AgendamentoResponse {
  final int idAgendamento;
  final User cliente;
  final Pet pet;
  final Funcionario funcionario;
  final List<Servico> servicos;
  final DateTime dataHoraAgendamento;
  final String? descricaoStatus;
  final String? observacaoAgendamento;
  final Status statusAgendamento;
  final double? valorTotal;

  AgendamentoResponse({
    required this.idAgendamento,
    required this.cliente,
    required this.pet,
    required this.funcionario,
    required this.servicos,
    required this.dataHoraAgendamento,
    this.descricaoStatus,
    this.observacaoAgendamento,
    required this.statusAgendamento,
    this.valorTotal
  });

  factory AgendamentoResponse.fromJson(Map<String, dynamic> json) {
    return AgendamentoResponse(
      idAgendamento: json['idAgendamento'],
      cliente: User.fromJson(json['idCliente']),
      pet: Pet.fromJson(json['idPet']),
      funcionario: Funcionario.fromJson(json['idFuncionario']),
      servicos: (json['idServico'] as List)
          .map((s) => Servico.fromJson(s))
          .toList(),
      dataHoraAgendamento: DateTime.parse(json['dataHoraAgendamento']),
      descricaoStatus: json['descricaoStatus'],
      observacaoAgendamento: json['observacaoAgendamento'],
      statusAgendamento: StatusExtension.fromString(json['statusAgendamento']),
      valorTotal: (json['valorTotal'] != null)
          ? (json['valorTotal'] as num).toDouble()
          : null,
    );
  }
}
