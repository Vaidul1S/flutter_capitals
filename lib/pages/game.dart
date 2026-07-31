import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/world.dart';
import '../data/usa.dart';

class HighScoreEntry {
  final int score;
  final int question;
  final String type;
  final String mode;

  HighScoreEntry(this.record, {
    required this.score,
    required this.question,
    required this.type, 
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'question': question,
    'type': type,
  };

  factory HighScoreEntry.fromJson(Map<String, dynamic> json) => HighScoreEntry(
    score: json['score'] as int,
    question: json['question'] as int,
    type: json['type'] as String,
    mode: json['mode'] as String,
  );
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameScreenState();
}

class _GameScreenState extends State<Game> {
  final Random _random = Random();

  int score = 0;
  String guess = 'Choose your answer';
  int question = 0;
  bool gameOn = false;
  int? lives;
  bool gameOver = false;
  int? length;
  int pick = 0;
  List<HighScoreEntry> highScore = [];
  bool showHighScore = false;
  String? type;
  bool newRecord = false;
  String mode = 'World';

  List<String> currentOptions = [];
  
  final ValueNotifier<bool> selectedWorldNotifier = ValueNotifier<bool>(true);

  List<dynamic> get _currentList =>
      selectedWorldNotifier.value ? capitals : usCapitals;

  dynamic get currentItem => _currentList[pick];

  @override
  void initState() {
    super.initState();
    pick = _random.nextInt(_currentList.length);
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('capitals');
      if (data != null) {
        final decoded = jsonDecode(data) as List<dynamic>;
        setState(() {
          highScore = decoded
              .map((e) => HighScoreEntry.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (err) {
      debugPrint('Failed to load data: $err');
    }
  }

  Future<void> _persistHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(highScore.map((h) => h.toJson()).toList());
      await prefs.setString('capitals', encoded);
    } catch (err) {
      debugPrint('Failed to save data: $err');
    }
  }

  void _pickNewItem() {
    final list = _currentList;
    pick = _random.nextInt(list.length);
    final item = list[pick];
    final opts = <String>[
      item.name as String,
      list[_random.nextInt(list.length)].name as String,
      list[_random.nextInt(list.length)].name as String,
      list[_random.nextInt(list.length)].name as String,
    ];
    opts.shuffle(_random);
    currentOptions = opts;
  }

  void _submitGuess(String selected) {
    setState(() {
      if (selected == currentItem.name) {
        score += 1;
        guess = 'Correct!';
      } else {
        guess = 'Wrong!';
        if (lives != null) {
          lives = lives! - 1;
        }
      }
      if (length != null) {
        length = length! - 1;
      }
      question += 1;
      _pickNewItem();
    });
    _checkGameEnd();
  }

  void _reset() {
    setState(() {
      question = 0;
      score = 0;
      gameOn = true;
      guess = 'Choose your answer';
      _pickNewItem();
    });
  }

  void _startTheGame(int e) {
    setState(() {
      lives = null;
      length = null;

      if (e == 20) {
        length = 20;
        type = '20 questions';
      } else if (e == 50) {
        length = 50;
        type = '50 questions';
      } else if (e == 3) {
        lives = 3;
        type = '3 lives';
      } else if (e == 5) {
        lives = 5;
        type = '5 lives';
      } else if (e == 1) {
        lives = 1;
        type = 'Ultimate';
      }
    });
    _reset();
  }

  void _playAgain() {
    setState(() {
      gameOn = false;
      gameOver = false;
      showHighScore = false;
      newRecord = false;
    });
  }

  void _forfeit() {
    setState(() {
      lives = null;
      gameOn = false;
      gameOver = true;
    });
  }

  Future<void> _saveRecord(int currentScore, int currentQuestion, String currentMode) async {
    final matching = highScore.where((h) => h.type == type);
    final shouldSave =
        matching.isEmpty || matching.any((h) => h.score < currentScore);

    if (shouldSave) {
      setState(() {
        highScore = [
          ...highScore.where((h) => h.type != type),
          HighScoreEntry(
            score: currentScore,
            question: currentQuestion,
            type: type!,
            mode: currentMode = selectedWorldNotifier.value ? 'World' : 'USA',
          ),
        ];
        newRecord = true;
      });
      await _persistHighScore();
    }
  }

  void _checkGameEnd() {
    if (gameOn && (lives == 0 || length == 0)) {
      final finalScore = score;
      final finalQuestion = question;
      final finalMode = mode;
      setState(() {
        gameOn = false;
        gameOver = true;
      });
      _saveRecord(finalScore, finalQuestion, finalMode);
    }
  }

  void _eraseRecords() {
    setState(() {
      highScore = [];
    });
    _persistHighScore();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (gameOn) {
      body = _buildGameScreen();
    } else if (gameOver) {
      body = _buildGameOverScreen();
    } else if (showHighScore) {
      body = _buildHighScoreScreen();
    } else {
      body = _buildMenuScreen();
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(68, 107, 119, 0.4),
      body: SafeArea(child: body),
    );
  }

  // --------------------------------------------------------------------- Menu ---------------------------------------------------------------------
  Widget _buildMenuScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: Image.asset(
                  'assets/images/globe.jpg',
                  width: 350,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            _title('Capitals Game'),
            IconButton(
              onPressed: () {
                selectedWorldNotifier.value = !selectedWorldNotifier.value;
              },
              icon: ValueListenableBuilder<bool>(
                valueListenable: selectedWorldNotifier,
                builder: (context, selectedWorld, child) {
                  return Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Mode',
                        style: TextStyle(
                          fontFamily: 'Unkempt Bold',
                          color: const Color.fromRGBO(156, 39, 176, 1),
                          fontSize: 20,
                        ),
                      ),
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
            _menuButton('20 Questions', () => _startTheGame(20)),
            _menuButton('50 Questions', () => _startTheGame(50)),
            _menuButton('3 Lives', () => _startTheGame(3)),
            _menuButton('5 Lives', () => _startTheGame(5)),
            _menuButton('Ultimate', () => _startTheGame(1), ultimate: true),
            GestureDetector(
              onTap: () => setState(() => showHighScore = true),
              child: _recordsLabel('Records'),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------- Game ---------------------------------------------------------------------
  Widget _buildGameScreen() {
    final item = currentItem;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: _forfeit, child: _forfeitLabel()),
        ),
        if (lives != null && lives! > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Lives:',
                style: TextStyle(
                  fontFamily: 'Unkempt Bold',
                  fontSize: 24,
                  color: Color.fromRGBO(156, 39, 176, 1),
                ),
              ),
              const SizedBox(width: 20),
              ...List.generate(
                lives!,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: SvgPicture.asset(
                    'assets/images/heart.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Question #${question + 1}',
            style: const TextStyle(
              fontFamily: 'Unkempt Bold',
              fontSize: 18,
              color: Color.fromRGBO(156, 39, 176, 1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              item.capital as String,
              style: const TextStyle(
                fontFamily: 'Unkempt Bold',
                fontSize: 42,
                color: Color.fromRGBO(156, 39, 176, 1),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var i = 0; i < currentOptions.length; i++)
                GestureDetector(
                  onTap: () => _submitGuess(currentOptions[i]),
                  child: _optionLabel('${i + 1}. ${currentOptions[i]}'),
                ),
              Text(
                guess,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unkempt Bold',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: guess == 'Choose your answer'
                      ? const Color.fromRGBO(156, 39, 176, 1)
                      : (guess == 'Correct!'
                            ? const Color.fromRGBO(95, 220, 57, 1)
                            : const Color.fromRGBO(231, 36, 22, 1)),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              'Score: $score',
              style: const TextStyle(
                fontFamily: 'Unkempt Bold',
                fontSize: 36,
                color: Color.fromRGBO(156, 39, 176, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------- Game Over ---------------------------------------------------------------------
  Widget _buildGameOverScreen() {
    return Container(
      color: const Color.fromRGBO(16, 43, 51, 1),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _title('Game Over'),
            if (newRecord)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'New Record!!!',
                  style: TextStyle(
                    fontFamily: 'Unkempt Bold',
                    fontSize: 24,
                    color: Color.fromRGBO(95, 220, 57, 1),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'You made $score correct answers\nout of $question questions.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Unkempt Bold',
                  fontSize: 24,
                  color: Color.fromRGBO(156, 39, 176, 1),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Good luck next time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unkempt Bold',
                  fontSize: 24,
                  color: Color.fromRGBO(156, 39, 176, 1),
                ),
              ),
            ),
            _menuButton('To Menu', _playAgain),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------- High Scores ---------------------------------------------------------------------
  Widget _buildHighScoreScreen() {
    return Container(
      color: const Color.fromRGBO(16, 43, 51, 1),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: _eraseRecords,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(182, 133, 28, 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                margin: const EdgeInsets.only(top: 150, left: 20, bottom: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Text(
                  'Reset Records',
                  style: TextStyle(
                    fontFamily: 'Unkempt Bold',
                    fontSize: 18,
                    color: Color.fromRGBO(156, 39, 176, 1),
                    shadows: _textShadow(),
                  ),
                ),
              ),
            ),
          ),
          _title('High Scores'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: highScore
                    .map(
                      (h) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          '${h.mode} mode ${h.type} type - Score: ${h.score}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Unkempt Bold',
                            fontSize: 18,
                            color: Color.fromRGBO(156, 39, 176, 1),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          _menuButton('To Menu', _playAgain),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------- Style helpers ---------------------------------------------------------------------
  List<Shadow> _textShadow() => const [
    Shadow(color: Colors.black, offset: Offset(1, -1), blurRadius: 0),
  ];

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Unkempt Bold',
        fontSize: 36,
        color: Color.fromRGBO(156, 39, 176, 1),
      ),
    ),
  );

  Widget _menuButton(
    String label,
    VoidCallback onTap, {
    bool ultimate = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 280,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ultimate
                ? const Color.fromRGBO(156, 39, 176, 1)
                : const Color.fromRGBO(182, 133, 28, 1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Unkempt Bold',
              fontSize: 24,
              color: ultimate
                  ? const Color.fromRGBO(182, 133, 28, 1)
                  : const Color.fromRGBO(156, 39, 176, 1),
              shadows: _textShadow(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _recordsLabel(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(182, 133, 28, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Unkempt Bold',
          fontSize: 16,
          color: Color.fromRGBO(156, 39, 176, 1),
          shadows: _textShadow(),
        ),
      ),
    );
  }

  Widget _optionLabel(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(182, 133, 28, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Unkempt Bold',
          fontSize: 22,
          color: Color.fromRGBO(156, 39, 176, 1),
          shadows: _textShadow(),
        ),
      ),
    );
  }

  Widget _forfeitLabel() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(182, 133, 28, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        'Forfeit',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Unkempt Bold',
          fontSize: 18,
          color: Color.fromRGBO(156, 39, 176, 1),
          shadows: _textShadow(),
        ),
      ),
    );
  }
}
