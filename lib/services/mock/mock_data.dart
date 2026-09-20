import '../../models/category.dart';
import '../../models/place.dart';
import '../../models/place_image.dart';
import '../../models/state_model.dart';

/// Curaduría de ejemplo (no un directorio abierto) para desarrollar el
/// frontend sin depender del backend. Los campos siguen el modelo `Place`
/// documentado en mxguide-backend-documentacion.md sección 4.1.
class MockData {
  static final categories = <PlaceCategory>[
    const PlaceCategory(id: 'cat-historico', name: 'Histórico', icon: 'account_balance'),
    const PlaceCategory(id: 'cat-natural', name: 'Natural', icon: 'park'),
    const PlaceCategory(id: 'cat-playa', name: 'Playa', icon: 'beach_access'),
    const PlaceCategory(id: 'cat-arqueologico', name: 'Arqueológico', icon: 'temple_buddhist'),
    const PlaceCategory(id: 'cat-cultural', name: 'Cultural', icon: 'museum'),
    const PlaceCategory(id: 'cat-religioso', name: 'Religioso', icon: 'church'),
  ];

  static final states = <PlaceState>[
    const PlaceState(id: 'state-cdmx', name: 'Ciudad de México'),
    const PlaceState(id: 'state-puebla', name: 'Puebla'),
    const PlaceState(id: 'state-oaxaca', name: 'Oaxaca'),
    const PlaceState(id: 'state-yucatan', name: 'Yucatán'),
    const PlaceState(id: 'state-qroo', name: 'Quintana Roo'),
    const PlaceState(id: 'state-jalisco', name: 'Jalisco'),
  ];

  static PlaceCategory _cat(String id) => categories.firstWhere((c) => c.id == id);
  static PlaceState _state(String id) => states.firstWhere((s) => s.id == id);

  static List<PlaceImage> _images(String seed, int count) {
    return List.generate(
      count,
      (i) => PlaceImage(id: '$seed-img-$i', url: 'https://picsum.photos/seed/$seed-$i/900/600', order: i),
    );
  }

  static final places = <Place>[
    Place(
      id: 'place-zocalo',
      name: 'Zócalo de la Ciudad de México',
      shortDescription: 'El corazón histórico y político de México.',
      longDescription:
          'La Plaza de la Constitución es una de las plazas más grandes del mundo, rodeada por la Catedral Metropolitana, el Palacio Nacional y el Antiguo Palacio del Ayuntamiento.',
      address: 'Plaza de la Constitución S/N, Centro Histórico',
      municipality: 'Ciudad de México',
      latitude: 19.4326,
      longitude: -99.1332,
      state: _state('state-cdmx'),
      categories: [_cat('cat-historico')],
      images: _images('zocalo', 4),
      openingHours: 'Abierto las 24 horas (espacio público)',
      entryCost: null,
      relevanceScore: 96,
    ),
    Place(
      id: 'place-chapultepec',
      name: 'Bosque de Chapultepec',
      shortDescription: 'Uno de los parques urbanos más grandes de Latinoamérica.',
      longDescription:
          'Incluye el Castillo de Chapultepec, varios museos, lagos artificiales y una gran área verde en el corazón de la ciudad.',
      address: 'Bosque de Chapultepec, Miguel Hidalgo',
      municipality: 'Ciudad de México',
      latitude: 19.4204,
      longitude: -99.1813,
      state: _state('state-cdmx'),
      categories: [_cat('cat-natural'), _cat('cat-cultural')],
      images: _images('chapultepec', 4),
      openingHours: 'Mar-Dom 5:00-17:00',
      entryCost: 0,
      relevanceScore: 92,
    ),
    Place(
      id: 'place-teotihuacan',
      name: 'Zona Arqueológica de Teotihuacán',
      shortDescription: 'Antigua ciudad prehispánica, Patrimonio de la Humanidad.',
      longDescription:
          'Hogar de las pirámides del Sol y de la Luna y de la Calzada de los Muertos, uno de los sitios arqueológicos más visitados de México.',
      address: 'Zona Arqueológica de Teotihuacán',
      municipality: 'San Juan Teotihuacán',
      latitude: 19.6925,
      longitude: -98.8438,
      state: _state('state-cdmx'),
      categories: [_cat('cat-arqueologico'), _cat('cat-historico')],
      images: _images('teotihuacan', 4),
      openingHours: 'Todos los días 9:00-17:00',
      entryCost: 95,
      relevanceScore: 98,
    ),
    Place(
      id: 'place-catedral-puebla',
      name: 'Catedral de Puebla',
      shortDescription: 'Catedral Basílica frente al Zócalo poblano.',
      longDescription:
          'Ejemplo destacado del barroco novohispano, con una de las torres más altas de México construidas en la época colonial.',
      address: '16 de Septiembre 100, Centro',
      municipality: 'Puebla de Zaragoza',
      latitude: 19.0433,
      longitude: -98.1982,
      state: _state('state-puebla'),
      categories: [_cat('cat-religioso'), _cat('cat-historico')],
      images: _images('catedral-puebla', 3),
      openingHours: 'Lun-Dom 10:00-18:00',
      entryCost: null,
      relevanceScore: 88,
    ),
    Place(
      id: 'place-cholula',
      name: 'Gran Pirámide de Cholula',
      shortDescription: 'La pirámide más grande del mundo por volumen.',
      longDescription:
          'Coronada por la Iglesia de Nuestra Señora de los Remedios, ofrece una de las mejores vistas de los volcanes Popocatépetl e Iztaccíhuatl.',
      address: 'Zona Arqueológica de Cholula',
      municipality: 'San Andrés Cholula',
      latitude: 19.0578,
      longitude: -98.3025,
      state: _state('state-puebla'),
      categories: [_cat('cat-arqueologico')],
      images: _images('cholula', 3),
      openingHours: 'Todos los días 9:00-18:00',
      entryCost: 80,
      relevanceScore: 90,
    ),
    Place(
      id: 'place-monte-alban',
      name: 'Monte Albán',
      shortDescription: 'Ciudad zapoteca prehispánica sobre una montaña.',
      longDescription:
          'Cuenta con terrazas, plataformas, montículos y pirámides monumentales, con vistas panorámicas del valle de Oaxaca.',
      address: 'Zona Arqueológica de Monte Albán',
      municipality: 'Santa Cruz Xoxocotlán',
      latitude: 17.0431,
      longitude: -96.7674,
      state: _state('state-oaxaca'),
      categories: [_cat('cat-arqueologico')],
      images: _images('monte-alban', 3),
      openingHours: 'Todos los días 8:00-17:00',
      entryCost: 90,
      relevanceScore: 91,
    ),
    Place(
      id: 'place-hierve-agua',
      name: 'Hierve el Agua',
      shortDescription: 'Cascadas petrificadas y albercas naturales.',
      longDescription:
          'Formaciones rocosas que simulan cascadas congeladas, con pozas de aguas minerales sobre un acantilado con vistas al valle.',
      address: 'San Lorenzo Albarradas',
      municipality: 'San Lorenzo Albarradas',
      latitude: 16.8667,
      longitude: -96.2750,
      state: _state('state-oaxaca'),
      categories: [_cat('cat-natural')],
      images: _images('hierve-agua', 3),
      openingHours: 'Todos los días 8:00-18:00',
      entryCost: 30,
      relevanceScore: 87,
    ),
    Place(
      id: 'place-chichen-itza',
      name: 'Chichén Itzá',
      shortDescription: 'Una de las Nuevas Siete Maravillas del Mundo.',
      longDescription:
          'La pirámide de Kukulkán es el ícono central de este sitio maya, célebre por el fenómeno de luz y sombra en los equinoccios.',
      address: 'Zona Arqueológica de Chichén Itzá',
      municipality: 'Tinúm',
      latitude: 20.6829,
      longitude: -88.5686,
      state: _state('state-yucatan'),
      categories: [_cat('cat-arqueologico'), _cat('cat-historico')],
      images: _images('chichen-itza', 4),
      openingHours: 'Todos los días 8:00-17:00',
      entryCost: 614,
      relevanceScore: 99,
    ),
    Place(
      id: 'place-valladolid',
      name: 'Centro histórico de Valladolid',
      shortDescription: 'Pueblo Mágico de calles coloniales y cenotes cercanos.',
      longDescription:
          'Su centro histórico conserva arquitectura colonial, con gastronomía yucateca tradicional y acceso a varios cenotes.',
      address: 'Centro, Valladolid',
      municipality: 'Valladolid',
      latitude: 20.6896,
      longitude: -88.2020,
      state: _state('state-yucatan'),
      categories: [_cat('cat-cultural')],
      images: _images('valladolid', 3),
      openingHours: 'Abierto las 24 horas (espacio público)',
      entryCost: null,
      relevanceScore: 82,
    ),
    Place(
      id: 'place-tulum',
      name: 'Zona Arqueológica de Tulum',
      shortDescription: 'Ruinas mayas frente al mar Caribe.',
      longDescription:
          'Único sitio maya construido sobre acantilados frente al mar, con playas de arena blanca a los pies de las ruinas.',
      address: 'Zona Arqueológica de Tulum',
      municipality: 'Tulum',
      latitude: 20.2144,
      longitude: -87.4291,
      state: _state('state-qroo'),
      categories: [_cat('cat-arqueologico'), _cat('cat-playa')],
      images: _images('tulum', 4),
      openingHours: 'Todos los días 8:00-17:00',
      entryCost: 90,
      relevanceScore: 93,
    ),
    Place(
      id: 'place-isla-mujeres',
      name: 'Isla Mujeres',
      shortDescription: 'Isla de aguas turquesa frente a Cancún.',
      longDescription:
          'Ideal para días de playa tranquilos y snorkel, con acceso en ferry desde Cancún o Puerto Juárez.',
      address: 'Isla Mujeres',
      municipality: 'Isla Mujeres',
      latitude: 21.2314,
      longitude: -86.7317,
      state: _state('state-qroo'),
      categories: [_cat('cat-playa')],
      images: _images('isla-mujeres', 3),
      openingHours: 'Abierto las 24 horas (espacio público)',
      entryCost: null,
      relevanceScore: 85,
    ),
    Place(
      id: 'place-tequila',
      name: 'Pueblo de Tequila',
      shortDescription: 'Pueblo Mágico cuna del tequila.',
      longDescription:
          'Rodeado de paisajes de agave azul declarados Patrimonio de la Humanidad, con recorridos por destilerías tradicionales.',
      address: 'Centro, Tequila',
      municipality: 'Tequila',
      latitude: 20.8825,
      longitude: -103.8383,
      state: _state('state-jalisco'),
      categories: [_cat('cat-cultural')],
      images: _images('tequila', 3),
      openingHours: 'Abierto las 24 horas (espacio público)',
      entryCost: null,
      relevanceScore: 80,
    ),
  ];
}
