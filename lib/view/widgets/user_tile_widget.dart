import 'package:flutter/material.dart';

class UserTileWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTileWidget({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondary),
          child: Row(
            children: [
              const Icon(Icons.person),
              
              const SizedBox(
                width: 20,
              ),
              Text(text),
            ],
          ),
        ));
  }
}
