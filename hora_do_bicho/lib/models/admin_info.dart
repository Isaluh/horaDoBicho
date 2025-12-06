class AdminInfo {
  final String telefone;
  final String endereco;

  AdminInfo({
    required this.telefone,
    required this.endereco,
  });

  factory AdminInfo.fromJson(Map<String, dynamic> json) {
    return AdminInfo(
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
    );
  }
}
