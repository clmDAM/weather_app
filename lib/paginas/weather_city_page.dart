import 'package:app_tiempo/const.dart';
import 'package:app_tiempo/traducciones/traduccion_dia.dart';
import 'package:app_tiempo/traducciones/traduccion_tiempo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherCityPage extends StatefulWidget {
  final String cityName;

  const WeatherCityPage({Key? key, required this.cityName}) : super(key: key);

  @override
  _WeatherCityPageState createState() => _WeatherCityPageState();
}

class _WeatherCityPageState extends State<WeatherCityPage> {
  late WeatherFactory _weatherFactory;
  Weather? _tiempo;
  List<Weather>? _prevision;

  @override
  void initState() {
    super.initState();
    _weatherFactory = WeatherFactory(API_KEY);
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final currentWeather = await _weatherFactory.currentWeatherByCityName(widget.cityName);
    final fiveDayForecast = await _weatherFactory.fiveDayForecastByCityName(widget.cityName);

    setState(() {
      _tiempo = currentWeather;
      _prevision = fiveDayForecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tiempo == null || _prevision == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
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
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
