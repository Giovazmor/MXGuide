import 'package:flutter/foundation.dart';

/// Preferencia de idioma del usuario. Por ahora solo guarda la selección
/// en memoria durante la sesión: TODO conectar con flutter_localizations +
/// archivos .arb para que realmente traduzca la UI, y con
/// shared_preferences para que se recuerde entre aperturas de la app.
class SettingsProvider extends ChangeNotifier {
  static const List<String> availableLanguages = [
    'Español',
    'Inglés',
    'Portugués',
    'Francés',
    'Italiano',
  ];

  String _language = 'Español';
  String get language => _language;

  void setLanguage(String value) {
    if (!availableLanguages.contains(value)) return;
    _language = value;
    notifyListeners();
  }
}
