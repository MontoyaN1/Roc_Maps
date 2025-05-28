import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String currentUserId;
  final int? totalMessages; // opcional, se puede usar para actualizar lectura

  ChatScreen({
    required this.groupId,
    required this.currentUserId,
    this.totalMessages,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late DatabaseReference _messagesRef;

  @override
  void initState() {
    super.initState();
    _messagesRef = FirebaseDatabase.instance
        .ref('groups/${widget.groupId}/messages');

    // Marcar como leído todos los mensajes actuales
    _messagesRef.once().then((snapshot) {
      final messages = snapshot.snapshot.value as Map?;
      final total = messages?.length ?? 0;

      FirebaseDatabase.instance
          .ref('groups/${widget.groupId}/readStatus/${widget.currentUserId}')
          .set(total);
    });
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = {
      'sender': widget.currentUserId,
      'text': messageText,
      'timestamp': ServerValue.timestamp,
    };

    _messagesRef.push().set(newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat del Grupo')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _messagesRef.orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No hay mensajes aún.'));
                }

                final messagesMap = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                final messages = messagesMap.entries.toList()
                  ..sort((a, b) {
                    final tsA = a.value['timestamp'] ?? 0;
                    final tsB = b.value['timestamp'] ?? 0;
                    return tsA.compareTo(tsB);
                  });

                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].value;
                    final sender = msg['sender'] ?? 'Anon';
                    final text = msg['text'] ?? '';

                    final isMe = sender == widget.currentUserId;

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.green[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            sender,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
