import 'package:flutter/material.dart';
import 'package:rocmaps/barra_lateral.dart';
import 'package:rocmaps/mapa.dart';

class HomeView extends StatefulWidget {
  final String? groupId;
  final String? currentUserId;

  const HomeView({super.key, this.groupId, this.currentUserId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      endDrawer: Barra(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 3, 87, 0)),
      ),
      body: MapaTiempoReal(
        groupId: widget.groupId ?? 'sin_grupo',
        userId: widget.currentUserId ?? 'anonimo',
      ),
    );
  }
}
