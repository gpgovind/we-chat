

import 'package:easy_chat/services/auth/auth_servicesa.dart';
import 'package:easy_chat/services/chat/chat_service.dart';
import 'package:easy_chat/view/widgets/drawer.dart';
import 'package:easy_chat/view/widgets/user_tile_widget.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logOut() {
    AuthService authServices = AuthService();
    authServices.logOut();
  }

  final ChatService _chatService = ChatService();
  final AuthService _authServices = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: MyDrawerWidget(
        onTapLogout: () => logOut(),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error while fetching data'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading...'));
        }
        return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList());
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authServices.getCurrentUser()!.email) {
      return UserTileWidget(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverEmail: userData["email"],
                  receiverId: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
