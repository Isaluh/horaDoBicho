class Pet {
  final int idPet;
  final String nomePet;
  final String idadePet;
  final String especiePet;
  final String racaPet;
  final int idCliente;

  Pet({
    required this.idPet,
    required this.nomePet,
    required this.idadePet,
    required this.especiePet,
    required this.racaPet,
    required this.idCliente
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      idPet: json['idPet'] is String ? int.tryParse(json['idPet']) ?? 0 : (json['idPet'] ?? 0),
      nomePet: json['nomePet'],
      idadePet: json['idadePet'],
      especiePet: json['especiePet'],
      racaPet: json['racaPet'],
      idCliente: json['idCliente'] is String ? int.tryParse(json['idCliente']) ?? 0 : (json['idCliente'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPet': idPet,
      'nomePet': nomePet,
      'idadePet': idadePet,
      'especiePet': especiePet,
      'racaPet': racaPet,
      'idCliente' : idCliente
    };
  }
}

