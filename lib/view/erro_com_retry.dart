import 'package:flutter/material.dart';

/// Mensagem de erro com botão "Tentar novamente".
/// Usado quando um StreamBuilder falha ao recuperar dados (RF004).
class ErroComRetry extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const ErroComRetry({
    super.key,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 10),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
