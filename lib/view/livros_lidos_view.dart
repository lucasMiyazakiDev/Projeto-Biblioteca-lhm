import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'menu_lateral.dart';

/// Funcionalidade 5: livros lidos (GridView).
class LivrosLidosView extends StatelessWidget {
  const LivrosLidosView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Livros lidos')),
      drawer: const MenuLateral(),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final lidos = controller.lidos;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '${lidos.length} de ${controller.livros.length} livros lidos',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: lidos.isEmpty
                    ? const Center(child: Text('Nenhum livro lido ainda.'))
                    : GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(10),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          for (final livro in lidos)
                            Card(
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.detalhesLivro,
                                  arguments: livro.id,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.book, size: 40),
                                      const SizedBox(height: 8),
                                      Text(
                                        livro.titulo,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(livro.autor,
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
