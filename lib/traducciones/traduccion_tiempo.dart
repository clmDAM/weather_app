class TraduccionTiempo {
  static const _locale = 'es';

  static String traducirTiempo(String weather) {
    return _weatherTranslations[_locale]![weather] ?? weather;
  }

  static final Map<String, Map<String, String>> _weatherTranslations = {
    'es': {
      "clear sky": "Cielo despejado",
      "few clouds": "Pocas nubes",
      "scattered clouds": "Nubes dispersas",
      "broken clouds": "Nubes fragmentadas",
      "shower rain": "Aguacero",
      "rain": "Lluvia",
      "thunderstorm": "Tormenta eléctrica",
      "snow": "Nieve",
      "mist": "Neblina",
      "Thunderstorm": "Tormenta eléctrica",
      "Drizzle": "Llovizna",
      "Rain": "Lluvia",
      "Snow": "Nieve",
      "Mist": "Niebla",
      "Smoke": "Humo",
      "Haze": "Bruma",
      "Dust": "Polvo",
      "Fog": "Niebla",
      "Sand": "Arena",
      "Ash": "Ceniza",
      "Squall": "Chubasco",
      "Tornado": "Tornado",
      "Clear": "Despejado",
      "Clouds": "Nublado"
    },
  };
}