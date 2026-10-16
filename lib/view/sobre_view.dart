import 'package:flutter/material.dart';

import '../controller/sobre_controller.dart';
import '../core/dependencias.dart';
import '../model/sessao.dart';
import 'menu_lateral.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    final sobre = getIt<SobreController>();
    final logado = getIt<Sessao>().usuarioLogado != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      drawer: logado ? const MenuLateral() : null,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset('../../../assets/images/logo.png', height: 100),
          const SizedBox(height: 10),
          Text(
            sobre.nomeApp,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
          Text('Versão ${sobre.versao}', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          const Text('Objetivo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(sobre.objetivo),
          const SizedBox(height: 20),
          const Text('Aluno:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Nome: ${sobre.integrante}'),          
          const SizedBox(height: 20),
          const Text('Informações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Disciplina: ${sobre.disciplina}'),
          Text('Instituição: ${sobre.instituicao}'),
          Text('Professor: ${sobre.professor}'),
        ],
      ),
    );
  }
}
