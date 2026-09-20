import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Text(
                      (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(user?.name ?? 'Invitado', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 28),
              Text('Language', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: settings.language,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: SettingsProvider.availableLanguages
                    .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) settings.setLanguage(value);
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.light_mode_outlined, size: 18),
                      const SizedBox(width: 6),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) => themeProvider.toggleTheme(value),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.dark_mode_outlined, size: 18),
                    ],
                  ),
                  Text('Tema', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showInfoDialog(
                        context,
                        title: 'Feedback',
                        message:
                            '¿Alguna idea o problema? Esta pantalla es un placeholder, lista para conectar a un formulario o correo real.',
                      ),
                      child: const Text('Feedback'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _showInfoDialog(
                        context,
                        title: 'Ayuda',
                        message:
                            'MXGuide es una guía turística curada de México. Explora, guarda tus lugares favoritos y comparte fotos y reseñas.',
                      ),
                      child: const Text('Ayuda'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (auth.isLoggedIn)
                OutlinedButton.icon(
                  onPressed: () {
                    auth.logout();
                    context.read<FavoritesProvider>().clear();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              Center(
                child: Text('Versión 1.13.0a', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}
