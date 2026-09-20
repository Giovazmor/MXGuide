import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/mx_bottom_nav.dart';
import '../auth/login_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../reviews/add_review_screen.dart';
import 'home_map_screen.dart';
import 'places_list_screen.dart';

/// Contenedor de navegación: 4 pestañas accesibles en modo invitado
/// (Home/mapa, Ubicaciones, Marcadores, Perfil) + el botón (+) central
/// para agregar fotos y reseñas, que pide login si hace falta.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      context.read<FavoritesProvider>().load(auth.token);
    });
  }

  void _goToTab(int index) => setState(() => _currentIndex = index);

  void _openAddReview() {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicia sesión'),
          content: const Text('Necesitas una cuenta para agregar fotos y reseñas.'),
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
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddReviewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeMapScreen(onSeeAllPressed: () => _goToTab(1)),
      const PlacesListScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: MXBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _goToTab,
        onAddPressed: _openAddReview,
      ),
    );
  }
}
