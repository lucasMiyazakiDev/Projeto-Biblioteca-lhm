import 'package:flutter/material.dart';

import '../controller/livro_controller.dart';
import '../core/dependencias.dart';
import '../model/livro.dart';
import 'livro_formulario.dart';

/// Edição de livro (recebe o id, String do Firestore, como argumento da rota).
class EditarLivroView extends StatefulWidget {
  const EditarLivroView({super.key});

  @override
  State<EditarLivroView> createState() => _EditarLivroViewState();
}

class _EditarLivroViewState extends State<EditarLivroView> {
  final controller = getIt<LivroController>();
  late Future<Livro?> _futuro;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // busca o livro uma única vez (o ModalRoute só está disponível aqui)
    if (!_iniciado) {
      final id = ModalRoute.of(context)!.settings.arguments as String;
      _futuro = controller.buscarPorId(id);
      _iniciado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar livro')),
      body: FutureBuilder<Livro?>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final livro = snapshot.data;
          if (snapshot.hasError || livro == null) {
            return const Center(child: Text('Livro não encontrado.'));
          }

          return LivroFormulario(
            livro: livro,
            textoBotao: 'Salvar alterações',
            onSalvar: (editado) async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              final erro = await controller.editar(editado);
              if (erro == null) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Livro atualizado com sucesso!')),
                );
                navigator.pop();
              }
              return erro;
            },
          );
        },
      ),
    );
  }
}
