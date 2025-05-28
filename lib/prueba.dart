import 'barra_lateral.dart';
import 'package:flutter/material.dart';
import 'mapa.dart';

class HomeView extends StatefulWidget {
  final String groupId;
  final String userId;

  const HomeView({super.key, required this.groupId, required this.userId});

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
            child: MapaTiempoReal(
              groupId: widget.groupId,
              userId: widget.userId,
            ),
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
                  setState(() {
                    _panelHeight = notification.extent;
                  });
                  return true;
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
