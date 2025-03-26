import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/question.dart'; // Importation de la liste des questions

class MyWidget extends StatelessWidget {
  final Color color;
  final double textsize;
  final Question question; // Ajout du paramètre question

  const MyWidget(this.color, this.textsize, this.question, {super.key});

  void _previousQuestion() {
    // Fonction à implémenter plus tard
  }

  void _nextQuestion() {
    // Fonction à implémenter plus tard
  }

  void _checkAnswer(bool answer) {
    // Fonction à implémenter plus tard
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizz App"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: color,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "images/${question.image}", // Affichage de l'image de la question
              width: 250,
              height: 180,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, style: BorderStyle.solid),
              ),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Text(
                  question.questionText, // Affichage de la question
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: textsize,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _previousQuestion,
                  style: myButtonStyle,
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(true),
                  style: myButtonStyle,
                  child: const Text("TRUE", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  style: myButtonStyle,
                  child: const Text("FALSE", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: myButtonStyle,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
