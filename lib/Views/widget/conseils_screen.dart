import 'package:flutter/material.dart';
import 'package:gardemonpoids/Components/colors.dart';

class ConseilsScreen extends StatelessWidget {
  final int userId;

  const ConseilsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: const Text(
            'Conseils',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Text(
              "Conseils Nutritionnels",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "1. Mangez équilibré en incluant des fruits, légumes, protéines et glucides.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Text(
              "2. Buvez suffisamment d'eau chaque jour.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Text(
              "3. Faites de l'exercice régulièrement pour maintenir un poids santé.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Text(
              "4. Suivez vos progrès et ajustez vos habitudes en fonction de vos objectifs.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Ajoutez d'autres conseils pertinents ici
          ],
        ),
      ),
    );
  }
}
