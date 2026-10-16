import 'package:flutter/material.dart';

/// Informações da tela "Sobre".
class SobreController extends ChangeNotifier {
  final String nomeApp = 'Biblioteca lhm';
  final String versao = '1.0.0'; 
  final String objetivo =
      'Aplicativo para organizar uma biblioteca pessoal: cadastrar livros, '
      'editar, marcar como lido e acompanhar a leitura.';
  final String integrante = 'Lucas Hideki Miyazaki';
  final String disciplina = 'Programação para dispositivos móveis';
  final String instituicao = 'Fatec Ribeirão Preto';
  final String professor = 'Rodrigo Plotz';
}
