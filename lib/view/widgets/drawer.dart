import 'package:flutter/material.dart';

import '../main screens/setting_screen.dart';

class MyDrawerWidget extends StatelessWidget {
  final void Function()? onTapLogout;
  const MyDrawerWidget({super.key, this.onTapLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.message,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                    title: const Text('H O M E'),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text('S E T T I N G'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    //

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: onTapLogout,
            ),
          ),
        ],
      ),
    );
  }
}
