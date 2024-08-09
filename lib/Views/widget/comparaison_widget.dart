import 'package:flutter/material.dart';

class ComparisonWidget extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;

  const ComparisonWidget({
    Key? key,
    required this.currentWeight,
    required this.targetWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Comparaison',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text('Poids actuel : $currentWeight kg'),
          const SizedBox(height: 10),
          Text('Poids cible : $targetWeight kg'),
          const SizedBox(height: 10),
          Text(
            'Différence : ${(currentWeight - targetWeight).toStringAsFixed(1)} kg',
            style: TextStyle(
              color: currentWeight > targetWeight ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
