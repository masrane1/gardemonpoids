import 'package:flutter/material.dart';

class ExerciseSummaryWidget extends StatelessWidget {
  final int totalSessions;
  final int sessionsCompleted;

  const ExerciseSummaryWidget({
    Key? key,
    required this.totalSessions,
    required this.sessionsCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Résumé des séances d\'exercice',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text('Séances complétées : $sessionsCompleted/$totalSessions'),
          const SizedBox(height: 10),
          Text(
            'Progression : ${((sessionsCompleted / totalSessions) * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
