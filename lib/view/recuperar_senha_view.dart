import 'package:flutter/material.dart';

import '../controller/recuperar_senha_controller.dart';
import '../core/dependencias.dart';

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
      SnackBar(content: Text('Enviamos uma senha temporária para $email.')),
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
                const Text('Informe o e-mail cadastrado para recuperar a senha.'),
                const SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.carregando ? null : recuperar,
                    child: Text(
                        controller.carregando ? 'Enviando...' : 'Recuperar senha'),
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
