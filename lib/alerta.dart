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
