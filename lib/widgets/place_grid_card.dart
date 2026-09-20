import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import 'login_required_dialog.dart';

/// Tarjeta compacta para grids de 3 columnas (estilo Instagram): solo la
/// imagen con el nombre superpuesto abajo y el corazón de favorito arriba.
class PlaceGridCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceGridCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(place.id);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              place.coverImageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const ColoredBox(color: Color(0xFFE0E0E0));
              },
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Color(0xFFE0E0E0),
                child: Icon(Icons.image_not_supported_outlined, size: 20),
              ),
            ),
            // Scrim para que el texto se lea sobre cualquier foto.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 14, 6, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                  ),
                ),
                child: Text(
                  place.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            if (place.isCurated)
              const Positioned(
                top: 4,
                left: 4,
                child: Icon(Icons.star, size: 14, color: Colors.amber, shadows: [
                  Shadow(blurRadius: 3, color: Colors.black87),
                ]),
              ),
            Positioned(
              top: 2,
              right: 2,
              child: Material(
                color: Colors.black.withOpacity(0.35),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (!auth.isLoggedIn) {
                      showLoginRequiredDialog(context);
                      return;
                    }
                    context.read<FavoritesProvider>().toggle(auth.token!, place.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
