import 'package:flutter/material.dart';
import '../ai/fma_engine.dart';
import '../ai/recommendation_engine.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  String recommendation = "Not started";

  void analyze() {
    int finger = FMAEngine.score(45, 70);
    int grip = FMAEngine.score(3.2, 6);
    int wrist = FMAEngine.score(30, 70);

    setState(() {
      recommendation =
          RecommendationEngine.recommend(finger, grip, wrist);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rehab Session")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: analyze,
              child: const Text("Analyze Session"),
            ),
            const SizedBox(height: 20),
            Text(
              "AI Recommendation:\n$recommendation",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
