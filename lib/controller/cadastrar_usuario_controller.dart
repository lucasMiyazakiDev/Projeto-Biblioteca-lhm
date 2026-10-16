import 'package:flutter/material.dart';

import '../model/sessao.dart';
import '../model/usuario.dart';

class CadastrarUsuarioController extends ChangeNotifier {
  final Sessao sessao;
  CadastrarUsuarioController(this.sessao);

  bool ocultarSenha = true;

  void alternarSenha() {
    ocultarSenha = !ocultarSenha;
    notifyListeners();
  }

  /// Retorna null se cadastrou (e já logou), ou a mensagem de erro.
  String? cadastrar(String nome, String email, String telefone, String senha,
      String confirmar) {
    if (nome.trim().isEmpty ||
        email.trim().isEmpty ||
        telefone.trim().isEmpty ||
        senha.isEmpty ||
        confirmar.isEmpty) {
      return 'Preencha todos os campos.';
    }
    if (!Usuario.emailValido(email)) {
      return 'E-mail inválido.';
    }
    final digitos = telefone.replaceAll(RegExp(r'\D'), '');
    if (digitos.length < 10 || digitos.length > 11) {
      return 'Telefone inválido (use DDD + número).';
    }
    if (senha.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    if (senha != confirmar) {
      return 'A senha e a confirmação não são iguais.';
    }
    if (sessao.emailExiste(email)) {
      return 'Já existe uma conta com esse e-mail.';
    }

    sessao.cadastrar(Usuario(
      nome: nome.trim(),
      email: email.trim(),
      telefone: digitos,
      senha: senha,
    ));
    return null;
  }
}
