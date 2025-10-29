class Pet {
  final int id;
  final String nome;
  final String idade;
  final String raca;
  final String especie;

  Pet({
    required this.id,
    required this.nome,
    required this.idade,
    required this.raca,
    required this.especie
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nome: json['nome'], 
      idade: json['idade'], 
      raca: json['raca'],
      especie: json['especie']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'raca': raca,
      'especie': especie,
    };
  }
}

