import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/livro.dart';

/// Funcionalidade 4: detalhes do livro, com marcar como lido e excluir.
class DetalhesLivroView extends StatelessWidget {
  const DetalhesLivroView({super.key});

  Future<void> excluir(BuildContext context, LivroController c, Livro livro) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir livro'),
        content: Text('Deseja excluir "${livro.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Livro excluído.')),
      );
      Navigator.pop(context);
      c.excluir(livro);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();
    final id = ModalRoute.of(context)!.settings.arguments as int;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final livro = controller.buscarPorId(id);

        // o livro acabou de ser excluído
        if (livro == null) return Scaffold(appBar: AppBar());

        return Scaffold(
          appBar: AppBar(title: const Text('Detalhes')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(livro.titulo,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('Autor: ${livro.autor}'),
              Text('Gênero: ${livro.genero}'),
              Text('Páginas: ${livro.paginas}'),
              Text('Status: ${livro.lido ? 'Lido' : 'Não lido'}'),
              const SizedBox(height: 15),
              const Text('Sinopse:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(livro.sinopse.isEmpty ? 'Sem sinopse.' : livro.sinopse),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => controller.alternarLido(livro),
                child: Text(
                    livro.lido ? 'Marcar como não lido' : 'Marcar como lido'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.editarLivro,
                  arguments: livro.id,
                ),
                child: const Text('Editar'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => excluir(context, controller, livro),
                child: const Text('Excluir'),
              ),
            ],
          ),
        );
      },
    );
  }
}
