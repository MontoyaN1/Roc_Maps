import 'package:rocmaps/chat.dart';
import 'barra_lateral.dart';
import 'package:flutter/material.dart';
import 'mapa.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  double _panelHeight = 0.4;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      endDrawer: Barra(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 3, 87, 0)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: size.height * _panelHeight),
            child: const MapaTiempoReal(), // Tu widget de mapa
          ),
          Positioned(
            right: 10,
            //bottom: size.width * 0.1,
            child: ElevatedButton(onPressed: () {}, child: Icon(Icons.add)),
          ),

          DraggableScrollableSheet(
            initialChildSize: _panelHeight,
            minChildSize: 0.2, // 20% mínimo
            maxChildSize: 0.7, // 70% máximo
            snap: true,
            snapSizes: const [0.3, 0.5, 0.7],
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  // Actualiza el padding del mapa cuando el panel se mueve
                  setState(() {
                    _panelHeight = notification.extent;
                  });
                  return true;
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ChatUI(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
