import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final double progress;

  const ProgressWidget({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Progrès vers les objectifs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            minHeight: 10,
          ),
          const SizedBox(height: 10),
          Text('${(progress * 100).toStringAsFixed(1)}% atteint'),
        ],
      ),
    );
  }
}
