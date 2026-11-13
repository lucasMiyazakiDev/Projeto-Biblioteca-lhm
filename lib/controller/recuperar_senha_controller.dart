import 'package:flutter/material.dart';

import '../core/erros.dart';
import '../model/sessao.dart';
import '../model/usuario.dart';

/// RF001: recuperação de senha. O Firebase Authentication envia o e-mail
/// com o link para o usuário criar uma nova senha.
class RecuperarSenhaController extends ChangeNotifier {
  final Sessao sessao;
  RecuperarSenhaController(this.sessao);

  bool carregando = false;

  /// Retorna null se o e-mail foi enviado, ou a mensagem de erro.
  Future<String?> recuperar(String email) async {
    if (email.trim().isEmpty) {
      return 'Informe o e-mail.';
    }
    if (!Usuario.emailValido(email)) {
      return 'E-mail inválido.';
    }

    carregando = true;
    notifyListeners();
    try {
      await sessao.enviarEmailRedefinicao(email);
      return null;
    } catch (e) {
      return traduzirErroFirebase(e);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
