import 'package:flutter/material.dart';

import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import '../model/sessao.dart';
import '../model/usuario.dart';
import 'erro_com_retry.dart';
import 'menu_lateral.dart';

/// RF004: perfil lido em tempo real da coleção "usuarios" (StreamBuilder).
class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final sessao = getIt<Sessao>();
  final controller = getIt<PerfilController>();
  late Stream<Usuario?> _stream = sessao.usuarioStream;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Só usuário autenticado acessa o perfil
    if (!sessao.estaLogado) {
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
      body: StreamBuilder<Usuario?>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErroComRetry(
              mensagem: 'Não foi possível carregar o perfil.',
              onTentarNovamente: () =>
                  setState(() => _stream = sessao.usuarioStream),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final usuario = snapshot.data;
          if (usuario == null) {
            return const Center(child: Text('Perfil não encontrado.'));
          }
          return _PerfilForm(usuario: usuario, controller: controller);
        },
      ),
    );
  }
}

/// Formulário separado para preencher os campos só uma vez (initState),
/// sem apagar o que a pessoa digita quando o stream atualiza.
class _PerfilForm extends StatefulWidget {
  final Usuario usuario;
  final PerfilController controller;

  const _PerfilForm({required this.usuario, required this.controller});

  @override
  State<_PerfilForm> createState() => _PerfilFormState();
}

class _PerfilFormState extends State<_PerfilForm> {
  final nomeCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restaurar();
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    telefoneCtrl.dispose();
    super.dispose();
  }

  void _restaurar() {
    nomeCtrl.text = widget.usuario.nome;
    telefoneCtrl.text = widget.usuario.telefone;
  }

  Future<void> salvar() async {
    if (widget.controller.carregando) return;
    final messenger = ScaffoldMessenger.of(context);

    final erro =
        await widget.controller.salvar(nomeCtrl.text, telefoneCtrl.text);
    messenger.showSnackBar(
      SnackBar(content: Text(erro ?? 'Perfil atualizado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final ocupado = widget.controller.carregando;
          return Column(
            children: [
              const Icon(Icons.account_circle, size: 90),
              const SizedBox(height: 20),
              TextField(
                controller: nomeCtrl,
                enabled: !ocupado,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: telefoneCtrl,
                enabled: !ocupado,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Telefone (com DDD)'),
              ),
              const SizedBox(height: 10),
              // e-mail só para visualização
              TextFormField(
                initialValue: widget.usuario.email,
                enabled: false,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: ocupado ? null : salvar,
                      child: ocupado
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: ocupado ? null : _restaurar,
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
