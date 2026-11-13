import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'usuario.dart';

/// Acesso ao Firebase Authentication (quem está logado) e à coleção
/// "usuarios" do Firestore (dados do perfil).
///
/// Os métodos que podem falhar lançam exceção do Firebase
/// (FirebaseAuthException / FirebaseException). Os controllers capturam e
/// traduzem para texto com traduzirErroFirebase() (core/erros.dart).
class Sessao {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Sessao({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usuarios =>
      _db.collection('usuarios');

  // ---------------------------------------------------------------- estado

  User? get _usuarioAuth => _auth.currentUser;

  bool get estaLogado => _usuarioAuth != null;

  /// uid do usuário logado (null se ninguém estiver logado).
  String? get uid => _usuarioAuth?.uid;

  /// E-mail do usuário logado, direto do Authentication.
  String? get email => _usuarioAuth?.email;

  /// Perfil do usuário logado, em tempo real (coleção "usuarios").
  /// Emite null se não há login ou se o documento ainda não existe.
  Stream<Usuario?> get usuarioStream {
    final id = uid;
    if (id == null) return Stream.value(null);

    return _usuarios.doc(id).snapshots().map((doc) {
      final dados = doc.data();
      if (dados == null) return null;
      return Usuario.fromMap(doc.id, dados);
    });
  }

  // ------------------------------------------------------------------ ações

  /// Login com e-mail e senha (RF001).
  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  /// Cria a conta no Authentication e grava nome, e-mail e telefone
  /// em "usuarios/{uid}" (RF002).
  Future<void> registrar(Usuario dados, String senha) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: dados.email.trim(),
      password: senha,
    );
    final novo = credencial.user!;

    try {
      await _usuarios.doc(novo.uid).set(dados.toMap());
    } catch (_) {
      // não deixa uma conta "pela metade" (sem perfil no Firestore)
      await novo.delete();
      rethrow;
    }
  }

  /// Envia o e-mail de redefinição de senha (RF001).
  Future<void> enviarEmailRedefinicao(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Atualiza nome e telefone do usuário logado.
  Future<void> atualizarPerfil(String nome, String telefone) {
    final id = uid;
    if (id == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }
    return _usuarios.doc(id).update({'nome': nome, 'telefone': telefone});
  }

  Future<void> sair() => _auth.signOut();
}
