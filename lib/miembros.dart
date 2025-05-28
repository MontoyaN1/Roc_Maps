import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rocmaps/home.dart';
import 'package:share_plus/share_plus.dart';

class MiembrosScreen extends StatelessWidget {
  final String groupId;
  final String currentUserId;

  MiembrosScreen({required this.groupId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final groupRef = FirebaseDatabase.instance.ref('groups/$groupId');

    return WillPopScope(
      onWillPop: () async {
        final confirmed = await _confirmarSalir(context);
        if (confirmed) {
          final ref = FirebaseDatabase.instance.ref(
            'groups/$groupId/members/$currentUserId',
          );
          await ref.remove();
        }
        return confirmed;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Miembros del Grupo')),
        body: StreamBuilder<DatabaseEvent>(
          stream: groupRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            if (!snapshot.hasData || !snapshot.data!.snapshot.exists) {
              return Center(child: Text('Grupo no encontrado'));
            }

            final groupData = snapshot.data!.snapshot.value as Map;
            final ownerId = groupData['owner'];
            final groupName = groupData['name'];
            final members = Map<String, dynamic>.from(
              groupData['members'] ?? {},
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Nombre del grupo: $groupName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Código para unirse: $groupId',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(
                            'Únete a nuestro grupo "$groupName" con el código: $groupId',
                          );
                        },
                        icon: Icon(Icons.share),
                        label: Text('Compartir código'),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<DataSnapshot>(
                        future:
                            FirebaseDatabase.instance
                                .ref(
                                  'groups/$groupId/readStatus/$currentUserId',
                                )
                                .get(),
                        builder: (context, readSnapshot) {
                          int readMessages = 0;
                          if (readSnapshot.hasData &&
                              readSnapshot.data!.value != null) {
                            readMessages = readSnapshot.data!.value as int;
                          }

                          return StreamBuilder<DatabaseEvent>(
                            stream:
                                FirebaseDatabase.instance
                                    .ref('groups/$groupId/messages')
                                    .onValue,
                            builder: (context, msgSnapshot) {
                              int totalMessages = 0;
                              if (msgSnapshot.hasData &&
                                  msgSnapshot.data!.snapshot.value != null) {
                                final messages = Map<String, dynamic>.from(
                                  msgSnapshot.data!.snapshot.value as Map,
                                );
                                totalMessages = messages.length;
                              }

                              final unread = totalMessages - readMessages;

                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => HomeView(
                                                groupId: groupId,
                                                currentUserId: currentUserId,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.chat),
                                    label: Text('Ir al Mapa y Chat'),
                                  ),
                                  if (unread > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$unread',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final userId = members.keys.elementAt(index);
                      final isOwner = userId == ownerId;

                      return ListTile(
                        leading: Icon(isOwner ? Icons.star : Icons.person),
                        title: Text(userId),
                        subtitle: isOwner ? Text('Administrador') : null,
                        tileColor:
                            isOwner
                                ? const Color.fromARGB(255, 29, 102, 32)
                                : null,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _confirmarSalir(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text('¿Salir del grupo?'),
              content: Text('Si sales, ya no aparecerás como miembro.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text('Salir', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
