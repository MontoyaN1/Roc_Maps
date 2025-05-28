import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'miembros.dart';

class JoinGroupScreen extends StatefulWidget {
  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> _joinGroup() async {
    final code = _codeController.text.trim();
    final userName = _userNameController.text.trim();

    if (code.isEmpty || userName.isEmpty) return;

    final ref = FirebaseDatabase.instance.ref('groups/$code');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.child('members').update({userName: true});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MiembrosScreen(
            groupId: code,
            currentUserId: userName,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo no encontrado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unirse a un Grupo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Tu nombre',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código del grupo',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinGroup,
              child: Text('Unirse'),
            )
          ],
        ),
      ),
    );
  }
}
