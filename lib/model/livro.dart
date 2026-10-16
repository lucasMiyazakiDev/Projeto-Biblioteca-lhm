class Livro {
  int id;
  String titulo;
  String autor;
  String genero;
  int paginas;
  String sinopse;
  bool lido;

  Livro({
    this.id = 0,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.paginas,
    this.sinopse = '',
    this.lido = false,
  });
}

const List<String> generos = [
  'Romance',
  'Ficção',
  'Fantasia',
  'Suspense',
  'Técnico',
  'Fantasia e Aventura',
  'Fantasia e Ação',
  'Fantasia Sombria e Mistério',
  'Outro',


];
