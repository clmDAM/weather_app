import 'package:flutter/material.dart';
import 'package:app_tiempo/paginas/nueva_ciudad.dart';

void showInputDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Utiliza un TextEditingController para obtener la entrada del usuario
      TextEditingController locationController = TextEditingController();
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
              // Agrega la nueva ubicación a la lista de ubicaciones
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
