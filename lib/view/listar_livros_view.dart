import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'menu_lateral.dart';

/// Funcionalidade 1: listar livros (ListView). Tela principal após o login.
class ListarLivrosView extends StatelessWidget {
  const ListarLivrosView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LivroController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus livros')),
      drawer: const MenuLateral(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cadastrarLivro),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.livros.isEmpty) {
            return const Center(child: Text('Nenhum livro cadastrado.'));
          }

          return ListView.builder(
            itemCount: controller.livros.length,
            itemBuilder: (context, index) {
              final livro = controller.livros[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: livro.lido,
                    onChanged: (_) => controller.alternarLido(livro),
                  ),
                  title: Text(livro.titulo),
                  subtitle: Text('${livro.autor} - ${livro.genero}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.detalhesLivro,
                    arguments: livro.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
