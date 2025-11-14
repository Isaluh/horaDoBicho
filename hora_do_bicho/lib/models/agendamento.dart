class Agendamento {
  final int idAgendamento;
  final int idCliente;
  final int idPet;
  final int idFuncionario;
  final List<int> idServico;
  final DateTime dataHoraAgendamento;
  final String? observacaoAgendamento;
  final Status statusAgendamento;

  Agendamento({
    required this.idAgendamento,
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
      idCliente: json['idCliente'],
      idPet: json['idPet'],
      idFuncionario: json['idFuncionario'],
      idServico: List<int>.from(json['idServico'] ?? []),
      dataHoraAgendamento: DateTime.parse(json['dataHoraAgendamento']),
      observacaoAgendamento: json['observacaoAgendamento'] ?? '',
      statusAgendamento: StatusExtension.fromString(json['statusAgendamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAgendamento': idAgendamento,
      'idCliente': idCliente,
      'idPet': idPet,
      'idFuncionario': idFuncionario,
      'idServico': idServico,
      'dataHoraAgendamento': dataHoraAgendamento,
      'observacaoAgendamento': observacaoAgendamento,
      'statusAgendamento': statusAgendamento
    };
  }
}

enum Status { EM_ANALISE, CANCELADO, APROVADO }

extension StatusExtension on Status {
  String get name => this.toString().split('.').last;

  static Status fromString(dynamic value) {
    if (value is String) {
      return Status.values.firstWhere(
        (e) => e.name == value,
        orElse: () => Status.EM_ANALISE,
      );
    }
    return Status.EM_ANALISE;
  }
}