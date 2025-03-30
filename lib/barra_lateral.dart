import 'package:flutter/material.dart';
import 'main.dart'; // Asegúrate de que este import apunte al archivo donde está MyApp

class Barra extends StatefulWidget {
  const Barra({super.key});

  @override
  State<Barra> createState() => _BarraState();
}

class _BarraState extends State<Barra> {
  bool mostrarConfiguracion = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Botón de cerrar la barra lateral
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text("Volver"),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                setState(() {
                  mostrarConfiguracion = false; // Resetea a estado original
                });
              },
            ),

            const DrawerHeader(
              child: Center(
                child: Text(
                  'Menú',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (!mostrarConfiguracion) ...[
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Configuración"),
                onTap: () {
                  setState(() {
                    mostrarConfiguracion = true;
                  });
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Modo oscuro"),
                onTap: () {
                  MyApp.of(context)?.toggleTheme();
                  Navigator.pop(context);
                },
              ),
              const ListTile(
                leading: Icon(Icons.language),
                title: Text("Idioma"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
