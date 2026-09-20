import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/place.dart';
import '../../providers/auth_provider.dart';
import '../../providers/places_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/star_rating_input.dart';

/// Pantalla que abre el botón (+) del bottom nav: agregar foto y reseña
/// de un lugar turístico. Requiere sesión iniciada (HomeShell ya se
/// encarga de pedir login antes de llegar aquí).
class AddReviewScreen extends StatefulWidget {
  final String? initialPlaceId;
  const AddReviewScreen({super.key, this.initialPlaceId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentController = TextEditingController();
  String? _selectedPlaceId;
  int _rating = 5;
  Uint8List? _photoBytes;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPlaceId = widget.initialPlaceId;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;

    if (_selectedPlaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige el lugar sobre el que quieres opinar')),
      );
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un comentario')),
      );
      return;
    }

    setState(() => _submitting = true);
    final reviewsProvider = context.read<ReviewsProvider>();
    final ok = await reviewsProvider.submit(
      token: auth.token!,
      placeId: _selectedPlaceId!,
      rating: _rating,
      comment: _commentController.text.trim(),
      photoBytes: _photoBytes,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reviewsProvider.errorMessage ?? 'No se pudo enviar la reseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>().places;

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar reseña')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Lugar', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPlaceId,
                decoration: InputDecoration(
                  hintText: 'Selecciona un lugar',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: places
                    .map((Place p) => DropdownMenuItem<String>(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPlaceId = value),
              ),
              const SizedBox(height: 20),
              Text('Calificación', style: Theme.of(context).textTheme.titleSmall),
              StarRatingInput(value: _rating, onChanged: (v) => setState(() => _rating = v)),
              const SizedBox(height: 12),
              Text('Comentario', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '¿Qué te pareció este lugar?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Foto (opcional)', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_photoBytes != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _photoBytes!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(_photoBytes == null ? 'Agregar foto' : 'Cambiar foto'),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Publicar reseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
