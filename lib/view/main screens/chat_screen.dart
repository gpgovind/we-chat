import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_chat/services/auth/auth_servicesa.dart';
import 'package:easy_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../auth screens/widgets/auth_textfield.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  const ChatScreen(
      {super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    log('called');
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //errors
          log('error');
          return const Center(child: Text('Error'));
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages'));
        }

        // for data
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }
  // build message

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        isCurrentUser: isCurrentUser,
      message: data['message'],
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AuthTextField(
            controller: _messageController,
            hintText: 'Type a message',
            obscureText: false,
          ),
        )),
        IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: const Icon(Icons.arrow_upward))
      ],
    );
  }
}
