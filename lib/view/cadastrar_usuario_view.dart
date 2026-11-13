import 'package:flutter/material.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';

/// RF002: registro no Firebase Authentication + dados extras na coleção
/// "usuarios" do Firestore (o controller faz a gravação).
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

  Future<void> cadastrar() async {
    if (controller.carregando) return;

    final erro = await controller.cadastrar(nomeCtrl.text, emailCtrl.text,
        telefoneCtrl.text, senhaCtrl.text, confirmarCtrl.text);
    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
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
            final ocupado = controller.carregando;
            return Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  enabled: !ocupado,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  enabled: !ocupado,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefoneCtrl,
                  enabled: !ocupado,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration:
                      const InputDecoration(labelText: 'Telefone (com DDD)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: senhaCtrl,
                  enabled: !ocupado,
                  obscureText: controller.ocultarSenha,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    helperText: 'Mínimo de 8 caracteres, com letras e números',
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
                  enabled: !ocupado,
                  obscureText: controller.ocultarSenha,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => cadastrar(),
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ocupado ? null : cadastrar,
                    child: ocupado
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Cadastrar'),
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
