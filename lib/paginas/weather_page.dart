import 'package:flutter/material.dart';
import 'package:app_tiempo/paginas/weather_city_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key, required this.title, required this.ciudades}) : super(key: key);

  final String title;
  final List<String> ciudades; // Lista de ciudades

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
              color: Colors.white,
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
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.ciudades.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return WeatherCityPage(cityName: widget.ciudades[index]);
                },
              ),
            ),
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _listaIndicadores(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _listaIndicadores() {
    List<Widget> indicadores = [];
    for (int i = 0; i < widget.ciudades.length; i++) {
      indicadores.add(_indicador(i == _currentPage));
    }
    return indicadores;
  }

  Widget _indicador(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 8.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void showInputDialog(BuildContext context) {
    TextEditingController locationController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Ubicación'),
          content: TextField(
            controller: locationController,
            decoration: const InputDecoration(hintText: 'Ingrese una nueva ubicación'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                nuevaCiudad(locationController.text);
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void nuevaCiudad(String ciudad) {
    setState(() {
      widget.ciudades.add(ciudad);
    });
    // Mueve el PageView a la nueva página
    _pageController.jumpToPage(widget.ciudades.length - 1);
    _currentPage = widget.ciudades.length - 1;
  }
}
