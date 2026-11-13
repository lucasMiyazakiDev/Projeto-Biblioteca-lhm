import 'package:flutter/material.dart';

import '../core/erros.dart';
import '../model/sessao.dart';
import '../model/usuario.dart';

/// RF001: login com e-mail e senha (Firebase Authentication).
class LoginController extends ChangeNotifier {
  final Sessao sessao;
  LoginController(this.sessao);

  bool ocultarSenha = true;
  bool carregando = false;

  void alternarSenha() {
    ocultarSenha = !ocultarSenha;
    notifyListeners();
  }

  /// Retorna null se deu certo, ou a mensagem de erro.
  Future<String?> entrar(String email, String senha) async {
    if (email.trim().isEmpty || senha.isEmpty) {
      return 'Preencha o e-mail e a senha.';
    }
    if (!Usuario.emailValido(email)) {
      return 'E-mail inválido.';
    }

    carregando = true;
    notifyListeners();
    try {
      await sessao.entrar(email, senha);
      return null;
    } catch (e) {
      return traduzirErroFirebase(e);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
