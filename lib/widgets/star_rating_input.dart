import 'package:flutter/material.dart';

/// Selector de calificación 1-5 estrellas (para AddReviewScreen).
class StarRatingInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => onChanged(starIndex),
          icon: Icon(
            starIndex <= value ? Icons.star : Icons.star_border,
            color: Colors.amber.shade700,
            size: size,
          ),
        );
      }),
    );
  }
}

/// Versión de solo lectura para mostrar una calificación (reseñas, listas).
class StarRatingDisplay extends StatelessWidget {
  final double value;
  final double size;

  const StarRatingDisplay({super.key, required this.value, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < value.round();
        return Icon(
          filled ? Icons.star : Icons.star_border,
          color: Colors.amber.shade700,
          size: size,
        );
      }),
    );
  }
}
