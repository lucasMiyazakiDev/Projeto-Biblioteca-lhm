import 'package:flutter/material.dart';

import '../controller/recuperar_senha_controller.dart';
import '../core/dependencias.dart';

/// RF001: recuperação de senha por e-mail (Firebase Authentication).
class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final controller = getIt<RecuperarSenhaController>();
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> recuperar() async {
    if (controller.carregando) return;

    final email = emailCtrl.text.trim();
    final erro = await controller.recuperar(email);
    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Enviamos um link para redefinir a senha em $email. '
            'Confira também a caixa de spam.'),
        duration: const Duration(seconds: 6),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esqueceu a senha')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Column(
              children: [
                const Text(
                    'Informe o e-mail cadastrado. Enviaremos um link para você '
                    'criar uma nova senha.'),
                const SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  enabled: !controller.carregando,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => recuperar(),
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.carregando ? null : recuperar,
                    child: controller.carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Enviar link de redefinição'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
