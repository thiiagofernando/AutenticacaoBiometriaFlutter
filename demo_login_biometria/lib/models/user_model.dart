class UserModel {
  final String nome;
  final String cpf;
  final String telefone;
  final int id;

  UserModel({
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      telefone: json['telefone'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}
