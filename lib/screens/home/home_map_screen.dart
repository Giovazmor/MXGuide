import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../providers/places_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/place_list_row.dart';
import '../place_detail/place_detail_screen.dart';

/// Pantalla Home del rediseño: mapa con pines de los lugares curados +
/// panel inferior con una vista previa de lugares destacados.
///
/// Requiere el paquete google_maps_flutter con una API key configurada
/// (ver README, sección "Configurar Google Maps"). Sin la key, el widget
/// no truena, pero no vas a ver las calles/satélite, solo el fondo gris.
class HomeMapScreen extends StatefulWidget {
  final VoidCallback onSeeAllPressed;
  const HomeMapScreen({super.key, required this.onSeeAllPressed});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  List<Place> _featured = [];
  bool _loadingFeatured = true;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(19.4326, -99.1332), // Ciudad de México
    zoom: 5.0,
  );

  @override
  void initState() {
    super.initState();
    _loadFeatured();
  }

  Future<void> _loadFeatured() async {
    final placesProvider = context.read<PlacesProvider>();
    try {
      final featured = await placesProvider.fetchFeatured(limit: 6);
      if (!mounted) return;
      setState(() {
        _featured = featured;
        _loadingFeatured = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingFeatured = false);
    }
  }

  Set<Marker> _buildMarkers(List<Place> places) {
    return places.where((p) => p.latitude != null && p.longitude != null).map((p) {
      return Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.latitude!, p.longitude!),
        infoWindow: InfoWindow(
          title: p.name,
          snippet: p.shortDescription,
          onTap: () => _openDetail(p.id),
        ),
      );
    }).toSet();
  }

  void _openDetail(String placeId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: placeId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesProvider = context.watch<PlacesProvider>();
    final markerSource = placesProvider.places.isNotEmpty ? placesProvider.places : _featured;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _buildMarkers(markerSource),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _HeaderBadge(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _LocationsPanel(
              loading: _loadingFeatured,
              places: _featured,
              onSeeAll: widget.onSeeAllPressed,
              onOpenPlace: _openDetail,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
      ),
      child: Text(
        'MXGuide',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LocationsPanel extends StatelessWidget {
  final bool loading;
  final List<Place> places;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onOpenPlace;

  const _LocationsPanel({
    required this.loading,
    required this.places,
    required this.onSeeAll,
    required this.onOpenPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.42),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 16)],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Locations', style: Theme.of(context).textTheme.labelSmall),
                    Text('Ubicación', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                TextButton(onPressed: onSeeAll, child: const Text('Ver todos')),
              ],
            ),
            const Divider(height: 16),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: LoadingIndicator(),
              )
            else if (places.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Sin lugares destacados por ahora'),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return PlaceListRow(
                      place: place,
                      onTap: () => onOpenPlace(place.id),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
