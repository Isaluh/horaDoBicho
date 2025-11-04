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
      idServico: json['idServico'],
      nomeServico: json['nomeServico'], 
      descricaoServico: json['descricaoServico'], 
      precoServico: json['precoServico'],
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

