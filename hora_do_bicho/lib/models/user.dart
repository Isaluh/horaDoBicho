class User {
  final int id;
  final String nome;
  final String email;
  final String? senha;
  final int telefone;
  final String? endereco; 
  final String cpf;
  final Permissao permissao; 

  User({
    required this.id,
    required this.nome,
    required this.email,
    this.senha,
    required this.cpf,
    required this.telefone,
    this.endereco,
    required this.permissao,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      permissao: PermissaoExtension.fromString(json['permissao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'cpf': cpf,
      'telefone': telefone,
      'endereco': endereco,
      'permissao': permissao.name,
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

