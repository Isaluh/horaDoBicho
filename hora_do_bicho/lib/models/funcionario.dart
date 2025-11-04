class Funcionario {
  final int idFuncionario;
  final String nomeFuncionario;
  final String cpfFuncionario;
  final String telefoneFuncionario;

  Funcionario({
    required this.idFuncionario, 
    required this.nomeFuncionario, 
    required this.cpfFuncionario, 
    required this.telefoneFuncionario
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      idFuncionario: json['idFuncionario'], 
      nomeFuncionario: json['nomeFuncionario'], 
      cpfFuncionario: json['cpfFuncionario'], 
      telefoneFuncionario: json['telefoneFuncionario']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFuncionario': idFuncionario,
      'nomeFuncionario': nomeFuncionario,
      'cpfFuncionario': cpfFuncionario,
      'telefoneFuncionario': telefoneFuncionario,
    };
  }
}

