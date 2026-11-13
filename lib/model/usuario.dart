/// Dados do usuário guardados na coleção "usuarios" do Firestore.
/// O id do documento é o uid do Firebase Authentication.
/// A senha NÃO é guardada aqui: quem cuida dela é o Firebase Authentication.
class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String telefone;

  const Usuario({
    this.uid = '',
    required this.nome,
    required this.email,
    required this.telefone,
  });

  /// Cria um Usuario a partir do documento do Firestore.
  factory Usuario.fromMap(String uid, Map<String, dynamic> dados) {
    return Usuario(
      uid: uid,
      nome: dados['nome'] as String? ?? '',
      email: dados['email'] as String? ?? '',
      telefone: dados['telefone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }

  /// Validação simples de e-mail: texto@dominio.ext (sem espaços).
  static bool emailValido(String email) {
    final texto = email.trim();
    if (texto.isEmpty || texto.contains(' ')) return false;

    final partes = texto.split('@');
    if (partes.length != 2) return false;

    final usuario = partes[0];
    final dominio = partes[1];
    if (usuario.isEmpty || dominio.isEmpty) return false;

    final pontos = dominio.split('.');
    // precisa ter ao menos um ponto e nenhuma parte vazia (ex.: "a@b..com")
    return pontos.length >= 2 && pontos.every((p) => p.isNotEmpty);
  }
}
