import 'package:flutter/material.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';

class CadastrarUsuarioView extends StatefulWidget {
  const CadastrarUsuarioView({super.key});

  @override
  State<CadastrarUsuarioView> createState() => _CadastrarUsuarioViewState();
}

class _CadastrarUsuarioViewState extends State<CadastrarUsuarioView> {
  final controller = getIt<CadastrarUsuarioController>();
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmarCtrl = TextEditingController();

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    telefoneCtrl.dispose();
    senhaCtrl.dispose();
    confirmarCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  void cadastrar() {
    final erro = controller.cadastrar(nomeCtrl.text, emailCtrl.text,
        telefoneCtrl.text, senhaCtrl.text, confirmarCtrl.text);
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Cadastro realizado com sucesso!')),
    );
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.livros, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar usuário')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(labelText: 'Telefone (com DDD)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: senhaCtrl,
                  obscureText: controller.ocultarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(controller.ocultarSenha
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: controller.alternarSenha,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmarCtrl,
                  obscureText: controller.ocultarSenha,
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cadastrar,
                    child: const Text('Cadastrar'),
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
