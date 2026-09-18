import 'package:flutter/material.dart';
import 'package:flutter_capitals/data/eu.dart';
import 'package:flutter_capitals/notifiers.dart';
import '../data/world.dart';
import '../data/usa.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  static final List worlds = [capitals, usCapitals, euCapitals];
  static const List text = ["  World", "  USA", "  Europe"];
  static const List icons = [
    'assets/images/world.png',
    'assets/images/usa.png',
    'assets/images/europe2.png',
  ];

  List<dynamic> get currentList => worlds[selectedModeNotifier.value];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(68, 107, 119, 0.4),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              selectedModeNotifier.value =
                  (selectedModeNotifier.value + 1) % worlds.length;
            },
            icon: ValueListenableBuilder<int>(
              valueListenable: selectedModeNotifier,
              builder: (context, selectedWorld, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select List',
                      style: TextStyle(
                        fontFamily: 'Unkempt Bold',
                        color: Color.fromRGBO(156, 39, 176, 1),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 70,
                      child: Image.asset(icons[selectedWorld]),
                    ),
                    Text(
                      text[selectedWorld],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Unkempt Bold',
                        color: Color.fromRGBO(156, 39, 176, 1),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: selectedModeNotifier,
              builder: (context, selectedWorld, child) {
                final List<dynamic> currentList =
                    worlds[selectedModeNotifier.value];
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    final item = currentList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Unkempt Bold',
                              color: Color.fromRGBO(156, 39, 176, 1),
                            ),
                          ),
                          Text(
                            item.capital,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Unkempt',
                              color: Color.fromRGBO(182, 133, 28, 1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
