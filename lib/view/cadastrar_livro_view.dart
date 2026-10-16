import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/dependencias.dart';
import 'livro_formulario.dart';

/// Funcionalidade 2: cadastrar livro.
class CadastrarLivroView extends StatelessWidget {
  const CadastrarLivroView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar livro')),
      body: LivroFormulario(
        textoBotao: 'Cadastrar',
        onSalvar: (livro) {
          controller.adicionar(livro);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Livro cadastrado!')),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
