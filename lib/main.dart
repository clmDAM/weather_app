import 'package:flutter/material.dart';
import 'package:app_tiempo/paginas/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define la lista de ciudades aquí
    List<String> ciudades = ['Madrid'];

    return MaterialApp(
      title: 'Applicación Meteorológica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Pasa la lista de ciudades como argumento al widget WeatherPage
      home: WeatherPage(title: 'Applicación Meteorológica', ciudades: ciudades),
    );
  }
}
