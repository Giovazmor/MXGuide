# MXGuide — Frontend Flutter

Frontend de **MXGuide**, guía turística curada de México, hecho en Flutter.
Cubre el Sprint 4 del plan SCRUM ("Integración Frontend y experiencia de
usuario") más el rediseño visual pedido después: mapa en Home, listas con
estrella de favorito, botón (+) para agregar fotos/reseñas, Perfil y
Settings con selector de idioma y de tema.

## Sobre los datos: mock por ahora

El ZIP del backend que compartiste (`backend_GuideMX-main`) solo trae la
documentación de arquitectura (`mxguide-backend-documentacion.md`) — el
código de NestJS vive en un submódulo aparte que no venía incluido. Así que
esta app corre **100% con datos dummy** (12 lugares curados de ejemplo, con
coordenadas reales, categorías, estados) para que puedas verla funcionando
sin depender del backend.

Toda la app está armada con **patrón repositorio**: cada pantalla habla con
una interfaz (`AuthRepository`, `PlacesRepository`, `FavoritesRepository`,
`ReviewsRepository`), nunca directo con Mock o con HTTP. Para conectar
contra el backend real cuando esté levantado, es un solo cambio:

```dart
// lib/core/constants/api_config.dart
static const bool useMockData = false; // antes: true
static const String baseUrl = 'https://tu-api-real.com'; // o 10.0.2.2:3000 en emulador
```

Nada más se toca — ninguna pantalla ni provider cambia. Los archivos en
`lib/services/api/` ya están escritos contra los endpoints documentados en
la sección 5 del doc. El endpoint para subir la **foto** de una reseña de
usuario no está documentado todavía (solo el de `PlaceImage` vía
admin/Cloudinary) — por ahora la foto de una reseña solo vive en memoria del
lado del cliente; hay un `// TODO` en `api_reviews_repository.dart` para
cuando el equipo defina ese endpoint.

**Usuario demo para probar login:** `demo@mxguide.com` / `123456`
(o regístrate con cualquier correo nuevo, se guarda en memoria).

## Cómo correrlo

Este ZIP trae `lib/`, `pubspec.yaml` y los archivos de configuración de
Dart — **no** trae las carpetas `android/` `ios/` etc. (esas las genera
Flutter). Pasos:

```bash
# Si es la primera vez (proyecto nuevo):
flutter create --org com.mxguide mxguide_app
cd mxguide_app
# Reemplaza pubspec.yaml, analysis_options.yaml y toda la carpeta lib/
# con los de este ZIP.

# Si ya tienes el proyecto de antes, solo pisa lib/ y pubspec.yaml con
# los de este ZIP.

flutter pub get
flutter run
```

## Configurar Google Maps (pantalla Home)

La pantalla Home ahora muestra un mapa real (`google_maps_flutter`) con un
pin por cada lugar curado. Sin una API key configurada, el mapa no truena,
pero se ve gris/sin calles. Pasos:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/), crea o
   usa un proyecto, y habilita **Maps SDK for Android**, **Maps SDK for
   iOS** y **Maps JavaScript API** (si vas a correr en Chrome/web).
2. Crea una API key en "Credenciales". Puedes restringirla por plataforma
   después, pero para desarrollo una key sin restricciones es más simple.
3. **Android** — en `android/app/src/main/AndroidManifest.xml`, dentro de
   la etiqueta `<application>`, agrega:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="TU_API_KEY_AQUI" />
   ```
   Revisa también que `minSdkVersion` en `android/app/build.gradle` sea
   al menos 21.
4. **iOS** — en `ios/Runner/AppDelegate.swift`:
   ```swift
   import UIKit
   import Flutter
   import GoogleMaps

   @main
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GMSServices.provideAPIKey("TU_API_KEY_AQUI")
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```
5. **Web** — en `web/index.html`, antes del script de Flutter (dentro de
   `<head>` o `<body>`), agrega:
   ```html
   <script src="https://maps.googleapis.com/maps/api/js?key=TU_API_KEY_AQUI"></script>
   ```
6. Corre `flutter pub get` de nuevo y `flutter run`.

## Foto en reseñas (image_picker)

El botón (+) usa `image_picker` para elegir una foto de la galería. En Web
funciona sin configurar nada (usa el selector de archivos del navegador).
Para Android/iOS agrega esto si `flutter run` te pide permisos:

- **iOS** (`ios/Runner/Info.plist`):
  ```xml
  <key>NSPhotoLibraryUsageDescription</key>
  <string>MXGuide necesita acceso a tus fotos para agregarlas a una reseña</string>
  ```
- **Android**: normalmente no necesita permisos extra con `image_picker`
  reciente (usa el selector de fotos del sistema), pero si tu
  `compileSdkVersion` es viejo puede pedir `READ_MEDIA_IMAGES` en el
  manifest.

## Estructura del proyecto

```
lib/
├── main.dart                    # arranque, MultiProvider, MaterialApp
├── core/
│   ├── constants/api_config.dart   # switch mock/real + baseUrl
│   ├── theme/app_theme.dart        # colores Light/Dark (AppColors)
│   ├── routing/app_router.dart     # rutas nombradas (home/login/registro/detalle)
│   └── utils/validators.dart       # validaciones de formularios
├── models/                      # Place, Category, State, PlaceImage, User, Review
├── services/
│   ├── repositories/            # interfaces (contratos)
│   ├── mock/                    # implementación dummy (activa por default)
│   ├── api/                     # implementación real HTTP
│   └── repository_factory.dart  # decide mock vs real según ApiConfig
├── providers/                   # Auth, Places, Favorites, Reviews, Settings, Theme
├── screens/
│   ├── auth/                    # login, registro
│   ├── home/                    # home_shell (nav), home_map_screen, places_list_screen
│   ├── place_detail/            # detalle con galería + reseñas
│   ├── favorites/               # Marcadores (favoritos), pide login si eres invitado
│   ├── profile/                 # Perfil
│   ├── settings/                # idioma, tema, feedback/ayuda, logout
│   └── reviews/                 # AddReviewScreen (botón + del nav)
└── widgets/                     # PlaceListRow, StarRatingInput, MXBottomNav, etc.
```

## Navegación (rediseño)

Bottom nav de 4 pestañas + botón central:

1. **Home** (`home_map_screen.dart`) — mapa con pines de los lugares +
   panel inferior con una vista previa de destacados ("Ver todos" te manda
   a Ubicaciones).
2. **Ubicaciones** (`places_list_screen.dart`) — lista completa con
   buscador y filtros de categoría/estado.
3. **(+) central** — abre `AddReviewScreen`: elegir lugar, calificación de
   1 a 5 estrellas, comentario y una foto opcional. Pide login si entras
   como invitado.
4. **Marcadores** (`favorites_screen.dart`) — tus lugares favoritos.
5. **Perfil** (`profile_screen.dart`) — datos de tu cuenta + acceso a
   Settings (ícono de engrane en el AppBar).

En las listas (Ubicaciones, Marcadores, y el panel de Home), la ⭐ a la
izquierda de cada fila es el toggle de favorito — toqué esa parte del
mockup como "favorito rápido" en vez del ícono "⇧A" que traía el wireframe,
que no tenía una función clara.

## Settings

Selector de idioma (`Español`, `Inglés`, `Portugués`, `Francés`,
`Italiano`) — por ahora solo guarda la preferencia en memoria, **no
traduce la UI todavía**: para eso falta agregar `flutter_localizations` +
archivos `.arb` (queda como siguiente paso natural). También ahí vive el
switch de Light/Dark (antes estaba en el AppBar de Ubicaciones, se movió
aquí para que el header quedara limpio como en el mockup) y el botón de
cerrar sesión.

## Checklist cubierto

- [x] Login/registro con `/auth` → `screens/auth/`
- [x] Listado de lugares con filtros → `screens/home/places_list_screen.dart`
- [x] Detalle de lugar con galería → `screens/place_detail/`
- [x] Favoritos ("Marcadores") → `screens/favorites/`
- [x] Perfil (`/auth/me`) → `screens/profile/`
- [x] Navegación en modo invitado → `screens/home/home_shell.dart`
- [x] Mapa con pines en Home (google_maps_flutter, necesita tu API key)
- [x] Agregar fotos y reseñas por lugar (botón + del nav)
- [x] Settings: idioma + tema + feedback/ayuda + logout

Lo que **no** entra aquí (Sprint 5): geolocalización real ("cerca de mí"),
permisos de ubicación, IA, publicación en Play Store.

## Notas técnicas

- Manejo de estado: `provider` (ChangeNotifier).
- No usa `localStorage`: la sesión y las reseñas viven en memoria mientras
  la app está abierta. Para persistir entre reinicios, el siguiente paso
  natural es `shared_preferences` (token de sesión) — las reseñas ya
  dependen del backend real de todos modos.
- Imágenes de lugares: como es mock, vienen de `picsum.photos` con un seed
  por lugar. Al conectar el backend real, traen URLs de Cloudinary.
- Fotos de reseñas: se guardan como `Uint8List` en memoria (mock). En
  cuanto el backend defina el endpoint de subida, cambia `MockReviewsRepository`
  por `ApiReviewsRepository` (ya está el esqueleto) y ese TODO se resuelve.
