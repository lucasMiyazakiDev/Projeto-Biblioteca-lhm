import 'package:flutter/material.dart';

import 'usuario.dart';

/// Guarda os usuários cadastrados e quem está logado (dados na memória).
class Sessao extends ChangeNotifier {
  final List<Usuario> usuarios = [
    Usuario(
      nome: 'Usuário Teste',
      email: 'teste@email.com',
      telefone: '16999999999',
      senha: '123456',
    ),
  ];

  Usuario? usuarioLogado;

  bool emailExiste(String email) {
    return usuarios.any((u) => u.email.toLowerCase() == email.trim().toLowerCase());
  }

  Usuario? buscarPorEmail(String email) {
    for (final u in usuarios) {
      if (u.email.toLowerCase() == email.trim().toLowerCase()) return u;
    }
    return null;
  }

  void definirSenha(Usuario usuario, String novaSenha) {
    usuario.senha = novaSenha;
  }

  bool login(String email, String senha) {
    for (final u in usuarios) {
      if (u.email.toLowerCase() == email.trim().toLowerCase() && u.senha == senha) {
        usuarioLogado = u;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void cadastrar(Usuario usuario) {
    usuarios.add(usuario);
    usuarioLogado = usuario;
    notifyListeners();
  }

  void atualizarNome(String nome) {
    usuarioLogado?.nome = nome;
    notifyListeners();
  }

  void sair() {
    usuarioLogado = null;
    notifyListeners();
  }
}
