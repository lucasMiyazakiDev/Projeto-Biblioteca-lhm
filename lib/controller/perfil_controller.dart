import 'package:flutter/material.dart';

import '../model/sessao.dart';

class PerfilController extends ChangeNotifier {
  final Sessao sessao;
  PerfilController(this.sessao);

  static const int nomeMinimo = 3;

  String get nome => sessao.usuarioLogado?.nome ?? '';
  String get email => sessao.usuarioLogado?.email ?? '';

  /// Retorna null se salvou, ou a mensagem de erro.
  String? salvar(String novoNome) {
    if (novoNome.trim().isEmpty) {
      return 'Preencha o nome.';
    }
    if (novoNome.trim().length < nomeMinimo) {
      return 'O nome deve ter pelo menos $nomeMinimo letras.';
    }
    sessao.atualizarNome(novoNome.trim());
    notifyListeners();
    return null;
  }
}
