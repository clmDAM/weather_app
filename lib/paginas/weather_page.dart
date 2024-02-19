import 'package:app_tiempo/const.dart';
import 'package:app_tiempo/traducciones/traduccion_dia.dart';
import 'package:app_tiempo/traducciones/traduccion_tiempo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:app_tiempo/paginas/input_dialog.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherFactory _weatherFactory = WeatherFactory(API_KEY);
  Weather? _tiempo;
  List<Weather>? _prevision;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final currentWeather = await _weatherFactory.currentWeatherByCityName("Madrid");
    final fiveDayForecast = await _weatherFactory.fiveDayForecastByCityName("Madrid");

    setState(() {
      _tiempo = currentWeather;
      _prevision = fiveDayForecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white, // Establece el color blanco para el icono
              ),
            onPressed: () {
            // Llama a una función para mostrar el input box
            showInputDialog(context);
          },
      ),
  ],
),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 11, 72, 232), Colors.lightBlue],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_tiempo == null || _prevision == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ubicacion(),
            _tiempoActual(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            _previsionSemanal(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            _informacionExtra(),
          ],
        ),
        )
      );
    }
  }

  Widget _ubicacion() {
    IconData icono = Icons.location_on;
    DateTime hoy = _tiempo!.date!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 50,
              color: Colors.white,
            ),
            Text(
              _tiempo?.areaName ?? "",
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          "${TraduccionDia.traducirDia(DateFormat("EEEE").format(hoy))} ${DateFormat("d").format(hoy)} de ${TraduccionDia.traducirMes(DateFormat("MMMM").format(hoy))} de ${DateFormat("yyyy").format(hoy)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _tiempoActual() {
    return Column(
      children: [
        Image(image: NetworkImage("http://openweathermap.org/img/wn/${_tiempo?.weatherIcon}@4x.png")),
        Text(
          "${_tiempo?.temperature?.celsius?.toStringAsFixed(0)}ºC",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        Text(
          TraduccionTiempo.traducirTiempo(_tiempo?.weatherMain ?? ""),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ],
    );
  }

  Widget _previsionSemanal() {
  // Filtrar la lista de previsiones para obtener solo una por día
  List<Weather> previsionDiaria = [];
  for (int i = 0; i < _prevision!.length; i += 8) {
    previsionDiaria.add(_prevision![i]);
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: previsionDiaria.map<Widget>((prevision) {
        DateTime fecha = prevision.date!;
        return Container(
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: const Color.fromARGB(100, 235, 235, 235),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 8.0), // Espacio entre contenedores
          child: Column(
            children: [
              Text(
                DateFormat("d/M").format(fecha),
              ),
              Image(
                image: NetworkImage(
                    "http://openweathermap.org/img/wn/${prevision.weatherIcon}.png"),
              ),
              Text(
                "${prevision.temperature?.celsius?.toStringAsFixed(0)}ºC",
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

  Widget _informacionExtra() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 235, 235, 235),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Min: ${_tiempo?.tempMin?.celsius?.toStringAsFixed(0)}ºC",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Sens.: ${_tiempo?.tempFeelsLike?.celsius?.toStringAsFixed(0)}ºC",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Amanecer: ${_tiempo?.sunrise?.hour}:${_tiempo?.sunrise?.minute}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Max: ${_tiempo?.tempMax?.celsius?.toStringAsFixed(0)}ºC",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "Humedad: ${_tiempo?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "Ocaso: ${_tiempo?.sunset?.hour}:${_tiempo?.sunset?.minute}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}