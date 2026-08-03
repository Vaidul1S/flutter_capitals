import 'package:flutter/material.dart';
import '../data/world.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(68, 107, 119, 0.4),
      child: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: capitals.length,
          itemBuilder: (context, index) {
            final country = capitals[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),              
              child: Column(
                children: [
                  Text(
                    '${country.name} ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Unkempt Bold',
                      color: Color.fromRGBO(156, 39, 176, 1),
                    ),
                  ),
                  Text(
                    '${country.capital} ',
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
        ),
      ),
    );
  }
}
