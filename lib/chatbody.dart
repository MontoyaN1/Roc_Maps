// ================= chat_body.dart =================
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatBody extends StatefulWidget {
  final String groupId;
  final String currentUserId;

  const ChatBody({super.key, required this.groupId, required this.currentUserId});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();
  late DatabaseReference _messagesRef;

  @override
  void initState() {
    super.initState();
    _messagesRef = FirebaseDatabase.instance.ref('groups/${widget.groupId}/messages');

    // Marcar todos como leídos
    _messagesRef.once().then((snapshot) {
      final messages = snapshot.snapshot.value as Map?;
      final total = messages?.length ?? 0;
      FirebaseDatabase.instance
          .ref('groups/${widget.groupId}/readStatus/${widget.currentUserId}')
          .set(total);
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = {
      'sender': widget.currentUserId,
      'text': text,
      'timestamp': ServerValue.timestamp,
    };

    _messagesRef.push().set(message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: _messagesRef.orderByChild('timestamp').onValue,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return Center(child: Text('No hay mensajes aún.'));
              }

              final messagesMap = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              final messages = messagesMap.entries.toList()
                ..sort((a, b) =>
                    (a.value['timestamp'] ?? 0).compareTo(b.value['timestamp'] ?? 0));

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index].value;
                  final isMe = msg['sender'] == widget.currentUserId;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg['text'] ?? '', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          msg['sender'] ?? 'Anon',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}