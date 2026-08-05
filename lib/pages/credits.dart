import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  const Credits({super.key});

  Future<void> _openGithub() async {
    final uri = Uri.parse('https://github.com/Vaidul1S');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(182, 133, 28, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Unkempt Bold',
                      fontSize: 20,
                      color: Color.fromRGBO(156, 39, 176, 1),
                    ),
                    children: [
                      TextSpan(
                        text: 'Capitals!\n\n',
                        style: TextStyle(fontSize: 36),
                      ),
                      TextSpan(
                        text:
                            'Guess a capital by the world country name\nor by the state name of United States of America\n',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextSpan(
                        text: 'GitHub\n',
                        recognizer: TapGestureRecognizer()..onTap = _openGithub,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: _openGithub,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/gg.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: '\n\u00A9 Vaidul1s 2026 ',
                        recognizer: TapGestureRecognizer()..onTap = _openGithub,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
