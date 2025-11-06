
class Agendamento {
  final int? idAgendamento;
  final int idCliente;
  final int idPet;
  final int idFuncionario;
  final List<int> idServico;
  final DateTime dataHoraAgendamento;
  final String? observacaoAgendamento;
  final Status statusAgendamento;

  Agendamento({
    this.idAgendamento,
    required this.idCliente,
    required this.idPet,
    required this.idFuncionario,
    required this.idServico,
    required this.dataHoraAgendamento,
    this.observacaoAgendamento,
    required this.statusAgendamento,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      idAgendamento: json['idAgendamento'],
      idCliente: json['idCliente'] is int ? json['idCliente'] : (json['idCliente']?['idCliente'] ?? 0),
      idPet: json['idPet'] is int ? json['idPet'] : (json['idPet']?['idPet'] ?? 0),
      idFuncionario: json['idFuncionario'] is int ? json['idFuncionario'] : (json['idFuncionario']?['idFuncionario'] ?? 0),
      idServico: ((json['idServico'] as List?)?.map((e) => e is int ? e : (e['idServico'] ?? 0)).toList() ?? []).cast<int>(),
      dataHoraAgendamento: DateTime.parse(json['dataHoraAgendamento']),
      observacaoAgendamento: json['observacaoAgendamento'],
      statusAgendamento: StatusExtension.fromString(json['statusAgendamento'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAgendamento': idAgendamento,
      'idCliente': idCliente,
      'idPet': idPet,
      'idFuncionario': idFuncionario,
      'idServico': idServico,
      'dataHoraAgendamento': dataHoraAgendamento.toIso8601String(),
      'observacaoAgendamento': observacaoAgendamento,
      'statusAgendamento': statusAgendamento.name,
    };
  }
}

enum Status { EM_ANALISE, CANCELADO, APROVADO }

extension StatusExtension on Status {
  String get name => toString().split('.').last;

  static Status fromString(dynamic value) {
    if (value is String) {
      return Status.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toString().toUpperCase(),
        orElse: () => Status.EM_ANALISE,
      );
    }
    return Status.EM_ANALISE;
  }
}