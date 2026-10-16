import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/sessao.dart';
import '../model/usuario.dart';

const String emailjsServiceId = 'service_mnck42y';
const String emailjsTemplateId = 'template_6of3hip';
const String emailjsPublicKey = 'U37y3N-yqz6Lywieb';

class RecuperarSenhaController extends ChangeNotifier {
  final Sessao sessao;
  RecuperarSenhaController(this.sessao);

  bool carregando = false;

  /// Gera uma senha temporária de 8 caracteres.
  String _gerarSenhaTemporaria() {
    const letras = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789';
    final random = Random.secure();
    return List.generate(8, (_) => letras[random.nextInt(letras.length)]).join();
  }

  /// Valida o e-mail e envia a senha temporária para ele.
  /// Retorna null se o e-mail foi enviado, ou a mensagem de erro.
  Future<String?> recuperar(String email) async {
    if (email.trim().isEmpty) {
      return 'Informe o e-mail.';
    }
    if (!Usuario.emailValido(email)) {
      return 'E-mail inválido.';
    }
    final usuario = sessao.buscarPorEmail(email);
    if (usuario == null) {
      return 'Nenhuma conta encontrada com esse e-mail.';
    }
    if (emailjsServiceId == 'SEU_SERVICE_ID') {
      return 'Envio de e-mail não configurado (veja recuperar_senha_controller.dart).';
    }

    carregando = true;
    notifyListeners();

    final novaSenha = _gerarSenhaTemporaria();
    try {
      final resposta = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': emailjsServiceId,
          'template_id': emailjsTemplateId,
          'user_id': emailjsPublicKey,
          'template_params': {
            'to_email': usuario.email,
            'to_name': usuario.nome,
            'nova_senha': novaSenha,
          },
        }),
      );

      if (resposta.statusCode != 200) {
        return 'Não foi possível enviar o e-mail (erro ${resposta.statusCode}).';
      }

      // só troca a senha depois que o e-mail foi enviado
      sessao.definirSenha(usuario, novaSenha);
      return null;
    } catch (e) {
      return 'Falha de conexão ao enviar o e-mail.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
