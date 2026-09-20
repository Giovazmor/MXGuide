import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/places_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/login_required_dialog.dart';
import '../../widgets/star_rating_input.dart';
import '../reviews/add_review_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  Place? _place;
  bool _loading = true;
  String? _error;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final placesProvider = context.read<PlacesProvider>();
    // Primero intentamos usar el lugar que ya está en memoria (de la lista);
    // si no está (ej. se abrió el detalle por deep link), lo pedimos al
    // repositorio con GET /places/:id.
    final cached = placesProvider.findById(widget.placeId);
    if (cached != null) {
      setState(() {
        _place = cached;
        _loading = false;
      });
      context.read<ReviewsProvider>().loadForPlace(widget.placeId);
      return;
    }
    try {
      final place = await placesProvider.fetchDetail(widget.placeId);
      if (!mounted) return;
      setState(() {
        _place = place;
        _loading = false;
      });
      context.read<ReviewsProvider>().loadForPlace(widget.placeId);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: LoadingIndicator());
    }
    if (_error != null || _place == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Lugar no encontrado')),
      );
    }

    final place = _place!;
    final auth = context.watch<AuthProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(place.id);
    final galleryImages =
        place.images.isEmpty ? [place.coverImageUrl] : place.images.map((i) => i.url).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  if (!auth.isLoggedIn) {
                    showLoginRequiredDialog(context);
                    return;
                  }
                  context.read<FavoritesProvider>().toggle(auth.token!, place.id);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _Gallery(
                images: galleryImages,
                currentIndex: _currentImage,
                onPageChanged: (index) => setState(() => _currentImage = index),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    place.shortDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in place.categories)
                        Chip(
                          avatar: const Icon(Icons.category_outlined, size: 18),
                          label: Text(category.name),
                        ),
                      if (place.state != null)
                        Chip(
                          avatar: const Icon(Icons.map_outlined, size: 18),
                          label: Text(place.state!.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Acerca de este lugar', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    place.longDescription.isNotEmpty ? place.longDescription : place.shortDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  if (place.address.isNotEmpty || place.municipality.isNotEmpty)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: [place.address, place.municipality]
                          .where((s) => s.isNotEmpty)
                          .join(', '),
                    ),
                  if (place.openingHours != null)
                    _InfoRow(icon: Icons.schedule_outlined, label: place.openingHours!),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    label: place.isFree
                        ? 'Entrada gratuita'
                        : 'Entrada: \$${place.entryCost!.toStringAsFixed(0)} MXN',
                  ),
                  if (place.latitude != null && place.longitude != null)
                    _InfoRow(
                      icon: Icons.my_location_outlined,
                      label:
                          'Lat: ${place.latitude!.toStringAsFixed(5)}, Lng: ${place.longitude!.toStringAsFixed(5)}',
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'El mapa exploratorio y "lugares cercanos" se integran en el Sprint 5.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  _ReviewsSection(place: place),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final Place place;
  const _ReviewsSection({required this.place});

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = context.watch<ReviewsProvider>();
    final reviews = reviewsProvider.forPlace(place.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reseñas', style: Theme.of(context).textTheme.titleMedium),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddReviewScreen(initialPlaceId: place.id),
                ),
              ),
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Agregar'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (reviewsProvider.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: LoadingIndicator(),
          )
        else if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Sé la primera persona en dejar una foto o reseña de este lugar.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          )
        else
          ...reviews.map((review) => _ReviewTile(review: review)),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(review.userName, style: Theme.of(context).textTheme.bodyMedium),
              ),
              StarRatingDisplay(value: review.rating.toDouble()),
            ],
          ),
          const SizedBox(height: 6),
          Text(review.comment, style: Theme.of(context).textTheme.bodyMedium),
          if (review.photoBytes != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                review.photoBytes!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const Divider(height: 20),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _Gallery({
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Color(0xFFBDBDBD),
                child: Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
              ),
            );
          },
        ),
        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
