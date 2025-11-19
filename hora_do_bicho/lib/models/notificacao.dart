class Notificacao {
  final int idNotificacao;
  final int idCliente;
  final String titulo;    
  final String descricao;  
  final bool lida; 
  final int idAgendamento;        

  Notificacao({
    required this.idNotificacao,
    required this.idCliente,
    required this.titulo,
    required this.descricao,
    required this.lida,
    required this.idAgendamento
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      idNotificacao: json['idNotificacao'],
      idCliente: json['idCliente'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      lida: json['lida'] ?? false,
      idAgendamento: json['idAgendamento']
    );
  }
}
