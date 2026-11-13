import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/livro.dart';
import 'erro_com_retry.dart';
import 'menu_lateral.dart';

/// RF004: lista dos livros do usuário em tempo real
/// (StreamBuilder + ListView). Tela principal após o login.
class ListarLivrosView extends StatefulWidget {
  const ListarLivrosView({super.key});

  @override
  State<ListarLivrosView> createState() => _ListarLivrosViewState();
}

class _ListarLivrosViewState extends State<ListarLivrosView> {
  final controller = getIt<LivroController>();
  late Stream<List<Livro>> _stream = controller.livrosStream;

  Future<void> _alternarLido(Livro livro) async {
    final erro = await controller.alternarLido(livro);
    if (!mounted || erro == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus livros')),
      drawer: const MenuLateral(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Cadastrar livro',
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cadastrarLivro),
        child: const Icon(Icons.add),
      ),
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

          final livros = snapshot.data ?? [];
          if (livros.isEmpty) {
            return const Center(child: Text('Nenhum livro cadastrado.'));
          }

          return ListView.builder(
            itemCount: livros.length,
            itemBuilder: (context, index) {
              final livro = livros[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: livro.lido,
                    onChanged: (_) => _alternarLido(livro),
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
