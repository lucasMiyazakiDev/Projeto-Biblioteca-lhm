import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/erros.dart';
import '../model/livro.dart';
import '../model/sessao.dart';

/// RF003 e RF004: livros na coleção "livros" do Firestore.
/// Cada livro guarda o uid do dono; o usuário só lê e altera os seus.
class LivroController {
  final Sessao sessao;
  final FirebaseFirestore _db;

  LivroController(this.sessao, {FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// Tempo máximo esperando o servidor confirmar uma gravação.
  static const Duration _limite = Duration(seconds: 15);

  CollectionReference<Map<String, dynamic>> get _livros =>
      _db.collection('livros');

  /// Livros do usuário logado, em tempo real, do mais novo para o mais antigo.
  /// Um getter: cada chamada cria um novo stream (usado pelo "Tentar de novo").
  Stream<List<Livro>> get livrosStream {
    final uid = sessao.uid;
    if (uid == null) return Stream.value(<Livro>[]);

    return _livros.where('uid', isEqualTo: uid).snapshots().map((consulta) {
      final lista = consulta.docs.map(Livro.fromDoc).toList();
      // ordena aqui para não exigir índice composto no Firestore;
      // criadoEm nulo = acabou de ser criado (o servidor ainda não confirmou)
      lista.sort((a, b) {
        final da = a.criadoEm ?? DateTime.now();
        final db = b.criadoEm ?? DateTime.now();
        return db.compareTo(da);
      });
      return lista;
    });
  }

  /// Um livro em tempo real. Emite null se não existe (ou foi excluído).
  Stream<Livro?> livroStream(String id) {
    return _livros.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      final livro = Livro.fromDoc(doc);
      return livro.uid == sessao.uid ? livro : null;
    });
  }

  /// Busca um livro uma única vez (usado na edição).
  Future<Livro?> buscarPorId(String id) async {
    final doc = await _livros.doc(id).get();
    if (!doc.exists) return null;
    final livro = Livro.fromDoc(doc);
    return livro.uid == sessao.uid ? livro : null;
  }

  // ------------------------------------------------------ escrita (RF003)

  /// Cadastra um livro. Retorna null se deu certo, ou a mensagem de erro.
  Future<String?> adicionar(Livro livro) {
    return _executar(() {
      final uid = sessao.uid;
      if (uid == null) {
        throw FirebaseAuthException(code: 'no-current-user');
      }
      return _livros.add(livro.toMapNovo(uid));
    });
  }

  /// Salva as alterações de um livro (o id vem dentro do livro).
  Future<String?> editar(Livro editado) {
    return _executar(() => _livros.doc(editado.id).update(editado.toMap()));
  }

  Future<String?> alternarLido(Livro livro) {
    return _executar(
        () => _livros.doc(livro.id).update({'lido': !livro.lido}));
  }

  Future<String?> excluir(Livro livro) {
    return _executar(() => _livros.doc(livro.id).delete());
  }

  /// Roda uma gravação e devolve null (sucesso) ou a mensagem de erro.
  Future<String?> _executar(Future<void> Function() acao) async {
    try {
      await acao().timeout(_limite);
      return null;
    } on TimeoutException {
      return 'O servidor não respondeu. Verifique sua conexão.';
    } catch (e) {
      return traduzirErroFirebase(e);
    }
  }
}
