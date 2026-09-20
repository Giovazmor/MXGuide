class ApiConfig {
  /// Cambia esto por la URL real del backend NestJS cuando esté desplegado.
  /// - Emulador Android -> localhost de tu compu: usa 10.0.2.2
  /// - Dispositivo físico en la misma red: usa la IP de tu compu (ej. 192.168.x.x)
  /// - Backend en la nube: la URL pública (ej. https://api.mxguide.app)
  static const String baseUrl = 'http://10.0.2.2:3000';

  /// true  -> usa datos dummy (MockXRepository), no necesita backend corriendo.
  /// false -> usa HTTP real contra [baseUrl] (ApiXRepository).
  static const bool useMockData = true;
}
