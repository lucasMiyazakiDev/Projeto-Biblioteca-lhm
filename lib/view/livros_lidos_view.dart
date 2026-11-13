import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/livro.dart';
import 'erro_com_retry.dart';
import 'menu_lateral.dart';

/// RF004: livros lidos em tempo real (StreamBuilder + GridView).
class LivrosLidosView extends StatefulWidget {
  const LivrosLidosView({super.key});

  @override
  State<LivrosLidosView> createState() => _LivrosLidosViewState();
}

class _LivrosLidosViewState extends State<LivrosLidosView> {
  final controller = getIt<LivroController>();
  late Stream<List<Livro>> _stream = controller.livrosStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livros lidos')),
      drawer: const MenuLateral(),
      body: StreamBuilder<List<Livro>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErroComRetry(
              mensagem: 'Não foi possível carregar seus livros.',
              onTentarNovamente: () =>
                  setState(() => _stream = controller.livrosStream),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];
          final lidos = todos.where((l) => l.lido).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '${lidos.length} de ${todos.length} livros lidos',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: lidos.isEmpty
                    ? const Center(child: Text('Nenhum livro lido ainda.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: lidos.length,
                        itemBuilder: (context, index) {
                          final livro = lidos[index];
                          return Card(
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
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      livro.autor,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
