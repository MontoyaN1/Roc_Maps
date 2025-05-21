import 'package:flutter/material.dart';

void llenado(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text("¡AVISO!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text("Por favor, complete todos los campos."),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void crearGrupo(BuildContext context) {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text("Crear grupo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre del grupo",
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Crear"),
              onPressed: () {
                final nombre = nombreController.text.trim();
                final desc = descripcionController.text.trim();

                if (nombre.isEmpty || desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor completa todos los campos"),
                    ),
                  );
                  return;
                }

                // Aquí va la lógica real: puedes guardar en Firestore, local, etc.
                print("Grupo creado: $nombre - $desc");

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
  );
}
