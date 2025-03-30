import 'barra_lateral.dart';
import 'package:flutter/material.dart';
import 'mapa.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 0, 0),
      endDrawer: Barra(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 3, 87, 0)),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.grey[400],
          ),
          MapaTiempoReal(),
          Positioned(
            top: size.height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
              ),
              child: Container(
                height: size.height * 0.65,
                color: Theme.of(context).scaffoldBackgroundColor,
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.70,
                ),
                child: const Center(
                  child: Text(
                    'Contenido de HomeView',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
