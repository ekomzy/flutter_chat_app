import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_input_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(receiverID, messageController.text);

      messageController.clear();
    }
  }

  Widget _buildMessageList() {
    String senderID = authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatService.getMessage(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,

      // decoration: BoxDecoration(
      //   color: Colors.grey[500],
      //   borderRadius: BorderRadius.circular(20),
      // ),
      // margin: EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyInputField(
              hintText: "Type a message",
              obscureText: false,
              controller: messageController,
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Text(
              receiverEmail.split("@")[0][0].toUpperCase() +
                  receiverEmail.split("@")[0].substring(1),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }
}
