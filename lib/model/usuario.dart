class Usuario {
  String nome;
  final String email;
  final String telefone;
  String senha;

  Usuario({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  /// Verifica se o e-mail tem um formato válido. precisei copiar da internet essa parte
  static bool emailValido(String email) {
    return RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email.trim());
  }
}
