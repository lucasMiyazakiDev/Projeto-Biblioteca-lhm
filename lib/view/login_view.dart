import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart'; 

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

  void entrar() {
    final erro = controller.entrar(emailCtrl.text, senhaCtrl.text);
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
                Image.asset('../../../assets/images/logo.png', height: 120),
                const SizedBox(height: 10),
                const Text('Biblioteca lhm', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail'),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: entrar,
                    child: const Text('Entrar'),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.cadastrarUsuario),
                  child: const Text('Cadastrar usuário'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.recuperarSenha),
                  child: const Text('Esqueceu a senha?'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.sobre),
                  child: const Text('Sobre'),
                ),
                const SizedBox(height: 10),
                const Text('Teste: teste@email.com / 123456'),
              ],
            );
          },
        ),
      ),
    );
  }
}
