import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';

Future<void> showLoginRequiredDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Inicia sesión'),
      content: const Text(
        'Necesitas una cuenta para usar los favoritos. ¿Quieres iniciar sesión o registrarte?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text('Iniciar sesión'),
        ),
      ],
    ),
  );
}
