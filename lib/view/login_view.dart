import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';

/// RF001: login com e-mail e senha (Firebase Authentication).
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = getIt<LoginController>();
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    senhaCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    if (controller.carregando) return;

    final erro = await controller.entrar(emailCtrl.text, senhaCtrl.text);
    if (!mounted) return; // a tela pode ter sido fechada durante o await

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.livros);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.menu_book, size: 100),
                ),
                const SizedBox(height: 10),
                const Text('Biblioteca lhm', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  enabled: !controller.carregando,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: senhaCtrl,
                  enabled: !controller.carregando,
                  obscureText: controller.ocultarSenha,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => entrar(),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.carregando ? null : entrar,
                    child: controller.carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  ),
                ),
                TextButton(
                  onPressed: controller.carregando
                      ? null
                      : () => Navigator.pushNamed(
                          context, AppRoutes.cadastrarUsuario),
                  child: const Text('Cadastrar usuário'),
                ),
                TextButton(
                  onPressed: controller.carregando
                      ? null
                      : () => Navigator.pushNamed(
                          context, AppRoutes.recuperarSenha),
                  child: const Text('Esqueceu a senha?'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.sobre),
                  child: const Text('Sobre'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
