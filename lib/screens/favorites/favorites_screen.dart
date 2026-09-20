import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/places_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/place_list_row.dart';
import '../auth/login_screen.dart';
import '../place_detail/place_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Marcadores')),
      body: auth.isLoggedIn ? const _FavoritesList() : const _GuestFavoritesPrompt(),
    );
  }
}

class _GuestFavoritesPrompt extends StatelessWidget {
  const _GuestFavoritesPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Inicia sesión para guardar tus lugares favoritos',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesList extends StatefulWidget {
  const _FavoritesList();

  @override
  State<_FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<_FavoritesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      context.read<FavoritesProvider>().load(auth.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final places = context.watch<PlacesProvider>();

    if (favorites.isLoading) {
      return const LoadingIndicator();
    }

    final favoritePlaces = places.places.where((p) => favorites.isFavorite(p.id)).toList();

    if (favoritePlaces.isEmpty) {
      return const Center(child: Text('Aún no tienes lugares favoritos'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: favoritePlaces.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final place = favoritePlaces[index];
        return PlaceListRow(
          place: place,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id)),
          ),
        );
      },
    );
  }
}
