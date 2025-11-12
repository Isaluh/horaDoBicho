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
    final cliente = json['idCliente'];
    final pet = json['idPet'];
    final funcionario = json['idFuncionario'];
    final servicos = json['idServico'];

    return Agendamento(
      idAgendamento: json['idAgendamento'] ?? 0,

      idCliente: (cliente is Map<String, dynamic>)
          ? cliente['idCliente'] ?? 0
          : cliente ?? 0,

      idPet: (pet is Map<String, dynamic>)
          ? pet['idPet'] ?? 0
          : pet ?? 0,

      idFuncionario: (funcionario is Map<String, dynamic>)
          ? funcionario['idFuncionario'] ?? 0
          : funcionario ?? 0,

      idServico: (servicos is List)
          ? servicos
              .map((s) =>
                  s is Map<String, dynamic> ? s['idServico'] as int : s as int)
              .toList()
          : [],

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
        (e) => e.name == value,
        orElse: () => Status.EM_ANALISE,
      );
    }
    return Status.EM_ANALISE;
  }
}
