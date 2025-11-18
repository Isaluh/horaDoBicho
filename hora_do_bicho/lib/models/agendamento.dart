class Agendamento {
  final int idAgendamento;
  final int idCliente;
  final int idPet;
  final int idFuncionario;
  final List<int> idServico;
  final DateTime dataHoraAgendamento;
  final String? descricaoStatus;
  final String? observacaoAgendamento;
  final Status statusAgendamento;
  final int? valorTotal;

  Agendamento({
    required this.idAgendamento,
    required this.idCliente,
    required this.idPet,
    required this.idFuncionario,
    required this.idServico,
    required this.dataHoraAgendamento,
    this.descricaoStatus,
    this.observacaoAgendamento,
    required this.statusAgendamento,
    this.valorTotal
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      idAgendamento: json['idAgendamento'],
      idCliente: json['idCliente'],
      idPet: json['idPet'],
      idFuncionario: json['idFuncionario'],
      idServico: List<int>.from(json['idServico'] ?? []),
      dataHoraAgendamento: DateTime.parse(json['dataHoraAgendamento']),
      descricaoStatus: json['descricaoStatus'] ?? '',
      observacaoAgendamento: json['observacaoAgendamento'] ?? '',
      statusAgendamento: StatusExtension.fromString(json['statusAgendamento']),
      valorTotal: json['valorTotal']
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
      'descricaoStatus' : descricaoStatus,
      'observacaoAgendamento': observacaoAgendamento,
      'statusAgendamento': statusAgendamento.name,
      'valorTotal' : valorTotal
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