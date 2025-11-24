class Funcionario {
  final int idFuncionario;
  final String nomeFuncionario;
  final String cpfFuncionario;
  final String telefoneFuncionario;
  final String cargoFuncionario;

  Funcionario({
    required this.idFuncionario,
    required this.nomeFuncionario,
    required this.cpfFuncionario,
    required this.telefoneFuncionario,
    required this.cargoFuncionario,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      idFuncionario: json['idFuncionario'] is String
          ? int.tryParse(json['idFuncionario']) ?? 0
          : json['idFuncionario'],
      nomeFuncionario: json['nomeFuncionario'],
      cpfFuncionario: json['cpfFuncionario'],
      telefoneFuncionario: json['telefoneFuncionario'],
      cargoFuncionario: json['cargoFuncionario']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFuncionario': idFuncionario,
      'nomeFuncionario': nomeFuncionario,
      'cpfFuncionario': cpfFuncionario,
      'telefoneFuncionario': telefoneFuncionario,
      'cargoFuncionario' : cargoFuncionario
    };
  }
}
