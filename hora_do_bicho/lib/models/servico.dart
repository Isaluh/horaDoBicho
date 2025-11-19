class Servico {
  final int idServico;
  final String nomeServico;
  final String descricaoServico;
  final double precoServico;

  Servico({
    required this.idServico, 
    required this.nomeServico, 
    required this.descricaoServico, 
    required this.precoServico
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      idServico: json['idServico'] is String ? int.tryParse(json['idServico']) ?? 0 : json['idServico'],
      nomeServico: json['nomeServico'], 
      descricaoServico: json['descricaoServico'], 
      precoServico: json['precoServico'] is String
        ? double.tryParse(json['precoServico']) ?? 0.0
        : (json['precoServico'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idServico': idServico,
      'nomeServico': nomeServico,
      'descricaoServico': descricaoServico,
      'precoServico': precoServico,
    };
  }
}

