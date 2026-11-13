import 'package:cloud_firestore/cloud_firestore.dart';

/// Livro guardado na coleção "livros" do Firestore (RF003).
/// Campos: titulo, autor, genero, paginas, sinopse, lido, uid, criadoEm.
/// O campo [uid] guarda o dono do livro: cada usuário só enxerga os seus.
class Livro {
  String id; // id do documento no Firestore ('' enquanto não foi salvo)
  String titulo;
  String autor;
  String genero;
  int paginas;
  String sinopse;
  bool lido;
  String uid; // dono do livro
  DateTime? criadoEm;

  Livro({
    this.id = '',
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.paginas,
    this.sinopse = '',
    this.lido = false,
    this.uid = '',
    this.criadoEm,
  });

  /// Cria um Livro a partir de um documento do Firestore.
  factory Livro.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final dados = doc.data() ?? {};
    return Livro(
      id: doc.id,
      titulo: dados['titulo'] as String? ?? '',
      autor: dados['autor'] as String? ?? '',
      genero: dados['genero'] as String? ?? generos.last,
      paginas: (dados['paginas'] as num?)?.toInt() ?? 0,
      sinopse: dados['sinopse'] as String? ?? '',
      lido: dados['lido'] as bool? ?? false,
      uid: dados['uid'] as String? ?? '',
      // fica null por um instante até o servidor preencher o timestamp
      criadoEm: (dados['criadoEm'] as Timestamp?)?.toDate(),
    );
  }

  /// Campos editáveis (usado ao atualizar). Não mexe em uid nem criadoEm.
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'paginas': paginas,
      'sinopse': sinopse,
      'lido': lido,
    };
  }

  /// Campos de um livro novo: os editáveis + dono e data de criação.
  Map<String, dynamic> toMapNovo(String uidDono) {
    return {
      ...toMap(),
      'uid': uidDono,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }
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
