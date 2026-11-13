import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/sessao.dart';
import '../model/usuario.dart';

/// Menu lateral usado nas telas principais.
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  void _ir(BuildContext context, String rota) {
    Navigator.pop(context); // fecha o menu
    // mantém a lista de livros como tela base
    Navigator.pushNamedAndRemoveUntil(
        context, rota, (r) => r.settings.name == AppRoutes.livros);
  }

  @override
  Widget build(BuildContext context) {
    final sessao = getIt<Sessao>();

    return Drawer(
      child: ListView(
        children: [
          // nome e e-mail vêm da coleção "usuarios" do Firestore
          StreamBuilder<Usuario?>(
            stream: sessao.usuarioStream,
            builder: (context, snapshot) {
              final usuario = snapshot.data;
              return UserAccountsDrawerHeader(
                accountName: Text(usuario?.nome ?? ''),
                accountEmail: Text(usuario?.email ?? sessao.email ?? ''),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Meus livros'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.livros, (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check),
            title: const Text('Livros lidos'),
            onTap: () => _ir(context, AppRoutes.livrosLidos),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () => _ir(context, AppRoutes.perfil),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () => _ir(context, AppRoutes.sobre),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () async {
              final navigator = Navigator.of(context);
              // sai das telas protegidas ANTES de encerrar a sessão,
              // para os streams do Firestore não darem erro de permissão
              navigator.pushNamedAndRemoveUntil(
                  AppRoutes.login, (r) => false);
              await sessao.sair();
            },
          ),
        ],
      ),
    );
  }
}
