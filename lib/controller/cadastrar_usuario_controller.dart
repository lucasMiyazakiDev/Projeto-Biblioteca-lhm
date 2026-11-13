import 'package:flutter/material.dart';

import '../core/erros.dart';
import '../model/sessao.dart';
import '../model/usuario.dart';

/// RF002: registro no Firebase Authentication + dados extras (nome,
/// telefone) na coleção "usuarios" do Firestore.
class CadastrarUsuarioController extends ChangeNotifier {
  final Sessao sessao;
  CadastrarUsuarioController(this.sessao);

  static const int senhaMinima = 8;

  bool ocultarSenha = true;
  bool carregando = false;

  void alternarSenha() {
    ocultarSenha = !ocultarSenha;
    notifyListeners();
  }

  /// Senha segura: mínimo de 8 caracteres, com letras e números.
  bool _senhaSegura(String senha) {
    final temLetra = senha.contains(RegExp(r'[A-Za-zÀ-ÿ]'));
    final temNumero = senha.contains(RegExp(r'[0-9]'));
    return senha.length >= senhaMinima && temLetra && temNumero;
  }

  /// Retorna null se cadastrou (e já logou), ou a mensagem de erro.
  Future<String?> cadastrar(String nome, String email, String telefone,
      String senha, String confirmar) async {
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
    if (!_senhaSegura(senha)) {
      return 'A senha deve ter no mínimo $senhaMinima caracteres, '
          'com letras e números.';
    }
    if (senha != confirmar) {
      return 'A senha e a confirmação não são iguais.';
    }

    carregando = true;
    notifyListeners();
    try {
      await sessao.registrar(
        Usuario(
          nome: nome.trim(),
          email: email.trim(),
          telefone: digitos,
        ),
        senha,
      );
      return null;
    } catch (e) {
      return traduzirErroFirebase(e);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
