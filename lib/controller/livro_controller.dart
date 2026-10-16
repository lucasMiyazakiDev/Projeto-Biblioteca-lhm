import 'package:flutter/material.dart';

import '../model/livro.dart';

/// Controla a lista de livros (dados de exemplo na memória).
class LivroController extends ChangeNotifier {
  final List<Livro> livros = [
  Livro(
    id: 1,
    titulo: 'Damn Reincarnation',
    autor: 'Kiki e Mogma',
    genero: 'Fantasia',
    paginas: 500,
    sinopse: 'Hamel, um guerreiro que morreu antes de derrotar os demônios, reencarna como Eugene Lionhart, descendente de seu antigo companheiro, e parte em uma nova jornada para cumprir seu destino.',
    lido: true,
  ),
  Livro(
    id: 2,
    titulo: 'Omniscient Reader\'s Viewpoint',
    autor: 'Sing Shong',
    genero: 'Fantasia e Ação',
    paginas: 551,
    sinopse: 'Kim Dokja é o único leitor que conhece o final de uma novel que se torna realidade. Usando seu conhecimento da história, ele tenta sobreviver a um mundo repleto de desafios mortais.',
  ),
  Livro(
    id: 3,
    titulo: 'Lord of Mysteries',
    autor: 'Cuttlefish That Loves Diving',
    genero: 'Fantasia Sombria e Mistério',
    paginas: 1432,
    sinopse: 'Zhou Mingrui desperta em um mundo de inspiração vitoriana, repleto de sociedades secretas, poderes sobrenaturais e entidades misteriosas, enquanto investiga os segredos de sua nova identidade.',
    lido: true,
  ),
  Livro(
    id: 4,
    titulo: 'The Beginning After the End',
    autor: 'TurtleMe',
    genero: 'Fantasia e Aventura',
    paginas: 500,
    sinopse: 'King Grey renasce como Arthur Leywin em um mundo de magia. Com as memórias de sua vida anterior, ele busca construir uma nova vida enquanto enfrenta perigos e descobre os segredos desse mundo.',
  ),
];

  int _proximoId = 5;

  List<Livro> get lidos => livros.where((l) => l.lido).toList();

  Livro? buscarPorId(int id) {
    for (final l in livros) {
      if (l.id == id) return l;
    }
    return null;
  }

  void adicionar(Livro livro) {
    livro.id = _proximoId++;
    livros.add(livro);
    notifyListeners();
  }

  void editar(Livro editado) {
    final i = livros.indexWhere((l) => l.id == editado.id);
    if (i != -1) {
      livros[i] = editado;
      notifyListeners();
    }
  }

  void alternarLido(Livro livro) {
    livro.lido = !livro.lido;
    notifyListeners();
  }

  void excluir(Livro livro) {
    livros.remove(livro);
    notifyListeners();
  }
}
