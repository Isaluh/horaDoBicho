class User {
  final int idCliente;
  final String nomeCliente;
  final String emailCliente;
  final String? senhaCliente;
  final String cpfCliente;
  final String telefoneCliente; 
  final String? enderecoCliente;
  final Permissao permissaoCliente; 

  User({
    required this.idCliente,
    required this.nomeCliente,
    required this.emailCliente,
    this.senhaCliente,
    required this.cpfCliente,
    required this.telefoneCliente,
    this.enderecoCliente,
    required this.permissaoCliente,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idCliente: json['idCliente'],
      nomeCliente: json['nomeCliente'],
      emailCliente: json['emailCliente'],
      senhaCliente: json['senhaCliente'],
      cpfCliente: json['cpfCliente'],
      telefoneCliente: json['telefoneCliente'],
      enderecoCliente: json['enderecoCliente'],
      permissaoCliente: PermissaoExtension.fromString(json['permissaoCliente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'nomeCliente': nomeCliente,
      'emailCliente': emailCliente,
      'senhaCliente': senhaCliente,
      'cpfCliente': cpfCliente,
      'telefoneCliente': telefoneCliente,
      'enderecoCliente': enderecoCliente,
      'permissaoCliente': permissaoCliente.name,
    };
  }
}

enum Permissao {
  ADMIN,
  COMUM,
}

extension PermissaoExtension on Permissao {
  String get name => this.toString().split('.').last;
  
  static Permissao fromString(String value) {
    return Permissao.values.firstWhere((e) => e.name == value, orElse: () => Permissao.COMUM);
  }
}

