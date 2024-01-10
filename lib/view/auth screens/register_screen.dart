import 'package:flutter/material.dart';

import 'package:easy_chat/view/auth%20screens/widgets/auth_button.dart';
import 'package:easy_chat/view/auth%20screens/widgets/auth_textfield.dart';

import '../../services/auth_servicesa.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key, this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;

  void register(BuildContext context) async {
    final authService = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await authService.createUserWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("password don't match"),
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
              "Welcome let's create an account for you ",
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
              height: 10,
            ),
            AuthTextField(
              obscureText: true,
              controller: _confirmPasswordController,
              hintText: 'Confirm password',
            ),
            const SizedBox(
              height: 25,
            ),
            AuthButton(
              btnName: 'Register',
              onTap: () {
                register(context);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account ? ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
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
