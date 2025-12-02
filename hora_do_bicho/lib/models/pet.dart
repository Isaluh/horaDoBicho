class Pet {
  final int idPet;
  final String nomePet;
  final String idadePet;
  final String especiePet;
  final String racaPet;
  final Sexo sexoPet;
  final int idCliente;

  Pet({
    required this.idPet,
    required this.nomePet,
    required this.idadePet,
    required this.especiePet,
    required this.racaPet,
    required this.sexoPet,
    required this.idCliente,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      idPet: json['idPet'] is String
          ? int.tryParse(json['idPet']) ?? 0
          : json['idPet'],
      nomePet: json['nomePet'],
      idadePet: json['idadePet'],
      especiePet: json['especiePet'],
      racaPet: json['racaPet'],
      sexoPet: SexoExtension.fromString(json['sexoPet']),
      idCliente: json['idCliente'] is String
          ? int.tryParse(json['idCliente']) ?? 0
          : json['idCliente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPet': idPet,
      'nomePet': nomePet,
      'idadePet': idadePet,
      'especiePet': especiePet,
      'racaPet': racaPet,
      'sexoPet' : sexoPet.name,
      'idCliente': idCliente,
    };
  }
}

enum Sexo { FEMEA, MACHO }

extension SexoExtension on Sexo {
  String get name => this.toString().split('.').last;

  static Sexo fromString(dynamic value) {
    if (value is String) {
      return Sexo.values.firstWhere(
        (e) => e.name == value,
        orElse: () => Sexo.FEMEA,
      );
    }
    return Sexo.FEMEA;
  }
}
