import 'package:easy_chat/view/auth%20screens/widgets/auth_button.dart';
import 'package:easy_chat/view/auth%20screens/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_servicesa.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  void login(BuildContext context) async {
     AuthService _AuthServices = AuthService();

    try {
      await _AuthServices.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Welcome back you've been missed! ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(
              height: 25,
            ),
            AuthTextField(
              hintText: 'Email',
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            AuthTextField(
              obscureText: true,
              controller: _passwordController,
              hintText: 'Password',
            ),
            const SizedBox(
              height: 25,
            ),
            AuthButton(
              btnName: 'Login',
              onTap: () {
                login(context);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member ? ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
