class Notificacao {
  final int idNotificacao;
  final int idCliente;
  final String titulo;    
  final String descricao;  
  final bool lida;         

  Notificacao({
    required this.idNotificacao,
    required this.idCliente,
    required this.titulo,
    required this.descricao,
    required this.lida,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      idNotificacao: json['idNotificacao'],
      idCliente: json['idCliente'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      lida: json['lida'] ?? false,
    );
  }
}
