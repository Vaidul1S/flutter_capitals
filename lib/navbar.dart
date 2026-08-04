import 'package:flutter/material.dart';
import 'package:flutter_capitals/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          height: 60,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Papyrus',
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.games_outlined, size: 20),
              label: 'Game',
            ),
            NavigationDestination(
              icon: Icon(Icons.copyright_rounded, size: 20),
              label: 'Credits',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_rounded, size: 20),
              label: 'Lists',
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
