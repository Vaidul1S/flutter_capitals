import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                      fontSize: 20,
                      fontFamily: 'Papyrus',
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: SvgPicture.asset(
                        country.capital,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
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
