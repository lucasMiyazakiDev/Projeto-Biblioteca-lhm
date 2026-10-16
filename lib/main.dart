import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/dependencias.dart';
import 'view/cadastrar_livro_view.dart';
import 'view/cadastrar_usuario_view.dart';
import 'view/detalhes_livro_view.dart';
import 'view/editar_livro_view.dart';
import 'view/listar_livros_view.dart';
import 'view/livros_lidos_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';

void main() {
  configurarDependencias();
  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca lhm',
      theme: ThemeData(
        useMaterial3: false, // visual simples (Material clássico)
        primarySwatch: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.cadastrarUsuario: (context) => const CadastrarUsuarioView(),
        AppRoutes.recuperarSenha: (context) => const RecuperarSenhaView(),
        AppRoutes.perfil: (context) => const PerfilView(),
        AppRoutes.sobre: (context) => const SobreView(),
        AppRoutes.livros: (context) => const ListarLivrosView(),
        AppRoutes.livrosLidos: (context) => const LivrosLidosView(),
        AppRoutes.cadastrarLivro: (context) => const CadastrarLivroView(),
        AppRoutes.editarLivro: (context) => const EditarLivroView(),
        AppRoutes.detalhesLivro: (context) => const DetalhesLivroView(),
      },
    );
  }
}
