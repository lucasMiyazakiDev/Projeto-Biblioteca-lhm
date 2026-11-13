import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/dependencias.dart';
import 'firebase_options.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // o Firebase precisa estar pronto antes de registrar as dependências
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configurarDependencias();

  // espera o Firebase restaurar a sessão salva (importante na web), para
  // quem já estava logado entrar direto na lista de livros
  final usuario = await FirebaseAuth.instance.authStateChanges().first;
  final rotaInicial = usuario != null ? AppRoutes.livros : AppRoutes.login;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // some na versão publicada no Hosting
      builder: (context) => MainApp(rotaInicial: rotaInicial),
    ),
  );
}

class MainApp extends StatelessWidget {
  final String rotaInicial;

  const MainApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca lhm',
      // necessários para o DevicePreview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: false, // visual simples (Material clássico)
        primarySwatch: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: rotaInicial,
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
