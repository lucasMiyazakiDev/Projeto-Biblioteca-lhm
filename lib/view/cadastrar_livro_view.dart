import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/dependencias.dart';
import 'livro_formulario.dart';

/// RF003: inserção de um livro no Firestore (coleção "livros").
class CadastrarLivroView extends StatelessWidget {
  const CadastrarLivroView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar livro')),
      body: LivroFormulario(
        textoBotao: 'Cadastrar',
        onSalvar: (livro) async {
          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);

          final erro = await controller.adicionar(livro);
          if (erro == null) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Livro cadastrado com sucesso!')),
            );
            navigator.pop();
          }
          return erro; // o formulário exibe o erro, se houver
        },
      ),
    );
  }
}
