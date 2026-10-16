import 'package:flutter/material.dart';

import '../model/livro.dart';

/// Formulário usado nas telas de cadastrar e editar livro.
class LivroFormulario extends StatefulWidget {
  final Livro? livro; // null = cadastro; preenchido = edição
  final String textoBotao;
  final void Function(Livro livro) onSalvar;

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

  @override
  void initState() {
    super.initState();
    final l = widget.livro;
    if (l != null) {
      tituloCtrl.text = l.titulo;
      autorCtrl.text = l.autor;
      paginasCtrl.text = l.paginas.toString();
      sinopseCtrl.text = l.sinopse;
      genero = l.genero;
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

  void salvar() {
    final paginas = int.tryParse(paginasCtrl.text.trim());

    if (tituloCtrl.text.trim().isEmpty || autorCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Preencha o título e o autor.')),
      );
      return;
    }
    if (paginas == null || paginas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Informe um número de páginas válido.')),
      );
      return;
    }

    widget.onSalvar(Livro(
      id: widget.livro?.id ?? 0,
      titulo: tituloCtrl.text.trim(),
      autor: autorCtrl.text.trim(),
      genero: genero,
      paginas: paginas,
      sinopse: sinopseCtrl.text.trim(),
      lido: lido,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: tituloCtrl,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: autorCtrl,
            decoration: const InputDecoration(labelText: 'Autor'),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: genero,
            isExpanded: true,
            items: generos
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (valor) => setState(() => genero = valor ?? genero),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: paginasCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Páginas'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: sinopseCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Sinopse (opcional)'),
          ),
          CheckboxListTile(
            title: const Text('Já li este livro'),
            value: lido,
            onChanged: (v) => setState(() => lido = v ?? false),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: salvar,
              child: Text(widget.textoBotao),
            ),
          ),
        ],
      ),
    );
  }
}
