import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import 'login_required_dialog.dart';

/// Fila compacta de lugar para las pantallas de lista (Ubicaciones, Home,
/// Marcadores), según el rediseño: estrella de favorito a la izquierda,
/// nombre + descripción corta al centro, flecha a la derecha.
class PlaceListRow extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceListRow({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(place.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber.shade700 : Theme.of(context).colorScheme.outline,
              ),
              onPressed: () {
                if (!auth.isLoggedIn) {
                  showLoginRequiredDialog(context);
                  return;
                }
                context.read<FavoritesProvider>().toggle(auth.token!, place.id);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    place.shortDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
