import 'package:flutter/material.dart';

import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/sessao.dart';
import 'menu_lateral.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final controller = getIt<PerfilController>();
  final nomeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomeCtrl.text = controller.nome;
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  void salvar() {
    final erro = controller.salvar(nomeCtrl.text);
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Perfil atualizado com sucesso!')),
    );
  }

  void cancelar() {
    nomeCtrl.text = controller.nome; // volta para o nome salvo
  }

  @override
  Widget build(BuildContext context) {
    // Só usuário autenticado acessa o perfil
    if (getIt<Sessao>().usuarioLogado == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (r) => false),
            child: const Text('Faça login para ver o perfil'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      drawer: const MenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 90),
            const SizedBox(height: 20),
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            // e-mail só para visualização
            TextFormField(
              initialValue: controller.email,
              enabled: false,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: salvar,
                    child: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: cancelar,
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
