import 'package:flutter/material.dart';
import 'package:flutter_capitals/notifiers.dart';
import '../data/world.dart';
import '../data/usa.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  List<dynamic> get currentList =>
      selectedWorldNotifier.value ? capitals : usCapitals;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(68, 107, 119, 0.4),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              selectedWorldNotifier.value = !selectedWorldNotifier.value;
            },
            icon: ValueListenableBuilder<bool>(
              valueListenable: selectedWorldNotifier,
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
                      height: 50,
                      child: selectedWorld
                          ? Image.asset('assets/images/world.png')
                          : Image.asset('assets/images/usa.png'),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: selectedWorldNotifier,
              builder: (context, selectedWorld, child) {
                final List<dynamic> currentList = selectedWorld ? capitals : usCapitals;
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
                              fontFamily: 'Unkempt Bold',
                              color: Color.fromRGBO(156, 39, 176, 1),
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
