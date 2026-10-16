import 'package:flutter/material.dart';

import '../model/sessao.dart';
import '../model/usuario.dart';

class LoginController extends ChangeNotifier {
  final Sessao sessao;
  LoginController(this.sessao);

  bool ocultarSenha = true;

  void alternarSenha() {
    ocultarSenha = !ocultarSenha;
    notifyListeners();
  }

  /// Retorna null se deu certo, ou a mensagem de erro.
  String? entrar(String email, String senha) {
    if (email.trim().isEmpty || senha.isEmpty) {
      return 'Preencha o e-mail e a senha.';
    }
    if (!Usuario.emailValido(email)) {
      return 'E-mail inválido.';
    }
    if (!sessao.login(email, senha)) {
      return 'E-mail ou senha incorretos.';
    }
    return null;
  }
}
