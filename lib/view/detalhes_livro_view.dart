import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/livro.dart';
import 'erro_com_retry.dart';

/// Detalhes do livro em tempo real, com marcar como lido, editar e excluir.
class DetalhesLivroView extends StatefulWidget {
  const DetalhesLivroView({super.key});

  @override
  State<DetalhesLivroView> createState() => _DetalhesLivroViewState();
}

class _DetalhesLivroViewState extends State<DetalhesLivroView> {
  final controller = getIt<LivroController>();
  late String _id;
  late Stream<Livro?> _stream;
  bool _iniciado = false;
  bool _excluindo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _id = ModalRoute.of(context)!.settings.arguments as String;
      _stream = controller.livroStream(_id);
      _iniciado = true;
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _alternarLido(Livro livro) async {
    final erro = await controller.alternarLido(livro);
    if (!mounted || erro == null) return;
    _mensagem(erro);
  }

  Future<void> _excluir(Livro livro) async {
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
    if (confirmou != true || !mounted) return;

    setState(() => _excluindo = true);
    final erro = await controller.excluir(livro);
    if (!mounted) return;

    if (erro != null) {
      setState(() => _excluindo = false);
      _mensagem(erro);
      return;
    }
    _mensagem('Livro excluído.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Livro?>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes')),
            body: ErroComRetry(
              mensagem: 'Não foi possível carregar o livro.',
              onTentarNovamente: () =>
                  setState(() => _stream = controller.livroStream(_id)),
            ),
          );
        }

        final livro = snapshot.data;
        final carregando = snapshot.connectionState == ConnectionState.waiting;

        // carregando, ou o livro acabou de ser excluído
        if (livro == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes')),
            body: Center(
              child: (carregando || _excluindo)
                  ? const CircularProgressIndicator()
                  : const Text('Livro não encontrado.'),
            ),
          );
        }

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
                onPressed: _excluindo ? null : () => _alternarLido(livro),
                child: Text(
                    livro.lido ? 'Marcar como não lido' : 'Marcar como lido'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _excluindo
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          AppRoutes.editarLivro,
                          arguments: livro.id,
                        ),
                child: const Text('Editar'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _excluindo ? null : () => _excluir(livro),
                child: _excluindo
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Excluir'),
              ),
            ],
          ),
        );
      },
    );
  }
}
