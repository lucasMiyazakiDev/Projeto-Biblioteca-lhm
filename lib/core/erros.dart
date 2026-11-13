import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Transforma uma exceção do Firebase em uma mensagem clara em português
/// para mostrar ao usuário (SnackBar).
String traduzirErroFirebase(Object erro) {
  if (erro is FirebaseAuthException) {
    switch (erro.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Nenhuma conta encontrada com esse e-mail.';
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'E-mail ou senha incorretos.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'email-already-in-use':
        return 'Já existe uma conta com esse e-mail.';
      case 'weak-password':
        return 'Senha fraca. Use ao menos 8 caracteres, com letras e números.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'operation-not-allowed':
        return 'Login por e-mail/senha não está habilitado no Firebase.';
      case 'no-current-user':
        return 'Faça login para continuar.';
      default:
        return 'Erro de autenticação (${erro.code}).';
    }
  }

  if (erro is FirebaseException) {
    switch (erro.code) {
      case 'permission-denied':
        return 'Sem permissão para acessar esses dados.';
      case 'unavailable':
        return 'Serviço indisponível. Verifique sua conexão.';
      case 'not-found':
        return 'Registro não encontrado.';
      default:
        return 'Erro ao acessar o banco de dados (${erro.code}).';
    }
  }

  return 'Ocorreu um erro inesperado. Tente novamente.';
}
