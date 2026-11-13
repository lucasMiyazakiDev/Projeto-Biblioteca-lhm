import 'package:flutter/material.dart';

import '../core/erros.dart';
import '../model/sessao.dart';

/// Edição do perfil (nome e telefone) na coleção "usuarios".
class PerfilController extends ChangeNotifier {
  final Sessao sessao;
  PerfilController(this.sessao);

  static const int nomeMinimo = 3;

  bool carregando = false;

  /// Retorna null se salvou, ou a mensagem de erro.
  Future<String?> salvar(String nome, String telefone) async {
    if (nome.trim().isEmpty || telefone.trim().isEmpty) {
      return 'Preencha o nome e o telefone.';
    }
    if (nome.trim().length < nomeMinimo) {
      return 'O nome deve ter pelo menos $nomeMinimo letras.';
    }
    final digitos = telefone.replaceAll(RegExp(r'\D'), '');
    if (digitos.length < 10 || digitos.length > 11) {
      return 'Telefone inválido (use DDD + número).';
    }

    carregando = true;
    notifyListeners();
    try {
      await sessao.atualizarPerfil(nome.trim(), digitos);
      return null;
    } catch (e) {
      return traduzirErroFirebase(e);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
