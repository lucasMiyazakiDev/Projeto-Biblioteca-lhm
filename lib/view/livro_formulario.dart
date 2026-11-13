import 'package:flutter/material.dart';

import '../model/livro.dart';

/// Formulário usado nas telas de cadastrar e editar livro (RF003).
///
/// [onSalvar] grava o livro e devolve null se deu certo, ou a mensagem de
/// erro. O formulário mostra o progresso e exibe o erro, se houver.
class LivroFormulario extends StatefulWidget {
  final Livro? livro; // null = cadastro; preenchido = edição
  final String textoBotao;
  final Future<String?> Function(Livro livro) onSalvar;

  const LivroFormulario({
    super.key,
    this.livro,
    required this.textoBotao,
    required this.onSalvar,
  });

  @override
  State<LivroFormulario> createState() => _LivroFormularioState();
}

class _LivroFormularioState extends State<LivroFormulario> {
  final tituloCtrl = TextEditingController();
  final autorCtrl = TextEditingController();
  final paginasCtrl = TextEditingController();
  final sinopseCtrl = TextEditingController();
  String genero = generos.first;
  bool lido = false;
  bool salvando = false;

  @override
  void initState() {
    super.initState();
    final l = widget.livro;
    if (l != null) {
      tituloCtrl.text = l.titulo;
      autorCtrl.text = l.autor;
      paginasCtrl.text = l.paginas.toString();
      sinopseCtrl.text = l.sinopse;
      // evita erro do Dropdown se o gênero salvo não estiver na lista
      genero = generos.contains(l.genero) ? l.genero : generos.last;
      lido = l.lido;
    }
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    autorCtrl.dispose();
    paginasCtrl.dispose();
    sinopseCtrl.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> salvar() async {
    if (salvando) return;
    final paginas = int.tryParse(paginasCtrl.text.trim());

    if (tituloCtrl.text.trim().isEmpty || autorCtrl.text.trim().isEmpty) {
      _mensagem('Preencha o título e o autor.');
      return;
    }
    if (paginas == null || paginas <= 0) {
      _mensagem('Informe um número de páginas válido.');
      return;
    }

    setState(() => salvando = true);
    final erro = await widget.onSalvar(Livro(
      id: widget.livro?.id ?? '',
      titulo: tituloCtrl.text.trim(),
      autor: autorCtrl.text.trim(),
      genero: genero,
      paginas: paginas,
      sinopse: sinopseCtrl.text.trim(),
      lido: lido,
    ));

    // em caso de sucesso a tela pai já pode ter fechado este formulário
    if (!mounted) return;
    setState(() => salvando = false);
    if (erro != null) _mensagem(erro);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: tituloCtrl,
            enabled: !salvando,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: autorCtrl,
            enabled: !salvando,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Autor'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: genero,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Gênero'),
            items: generos
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: salvando
                ? null
                : (valor) => setState(() => genero = valor ?? genero),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: paginasCtrl,
            enabled: !salvando,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Páginas'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: sinopseCtrl,
            enabled: !salvando,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Sinopse (opcional)'),
          ),
          CheckboxListTile(
            title: const Text('Já li este livro'),
            value: lido,
            onChanged: salvando ? null : (v) => setState(() => lido = v ?? false),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: salvando ? null : salvar,
              child: salvando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.textoBotao),
            ),
          ),
        ],
      ),
    );
  }
}
