import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'miembros.dart';

class GroupScreen extends StatefulWidget {
  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('groups');

  void _createGroup() async {
    final groupId = Uuid().v4().substring(0, 6);
    final groupName = _groupNameController.text.trim();
    final userName = _userNameController.text.trim();

    if (groupName.isEmpty || userName.isEmpty) return;

    await _dbRef.child(groupId).set({
      'name': groupName,
      'owner': userName,
      'admin': userName, // 👈 Aquí defines al admin
      'members': {userName: true},
      'ubicaciones': {}, // opcional si quieres dejarlo preparado
      'destino': {}, // idem
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => MiembrosScreen(groupId: groupId, currentUserId: userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Grupo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Tu nombre'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Nombre del grupo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Crear y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
