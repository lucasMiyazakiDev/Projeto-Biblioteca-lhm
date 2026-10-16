import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/dependencias.dart';
import 'livro_formulario.dart';

/// Funcionalidade 3: editar livro (recebe o id como argumento da rota).
class EditarLivroView extends StatelessWidget {
  const EditarLivroView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final livro = controller.buscarPorId(id);

    if (livro == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar livro')),
        body: const Center(child: Text('Livro não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar livro')),
      body: LivroFormulario(
        livro: livro,
        textoBotao: 'Salvar alterações',
        onSalvar: (editado) {
          controller.editar(editado);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Livro atualizado!')),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
