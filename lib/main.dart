import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/places_provider.dart';
import 'providers/reviews_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';
import 'services/repository_factory.dart';

void main() {
  runApp(const MXGuideApp());
}

class MXGuideApp extends StatelessWidget {
  const MXGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(RepositoryFactory.createAuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => PlacesProvider(RepositoryFactory.createPlacesRepository())..loadInitial(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(RepositoryFactory.createFavoritesRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewsProvider(RepositoryFactory.createReviewsRepository()),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'MXGuide',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
