import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gardemonpoids/SQLite/database_helper.dart';
import 'package:gardemonpoids/JSON/poids.dart';
import 'package:gardemonpoids/JSON/users.dart';
import 'package:gardemonpoids/Views/widget/analyse_widget.dart'; // Import du widget AnalyseWidget
import 'package:gardemonpoids/Views/widget/comparaison_widget.dart';
import 'package:gardemonpoids/Views/widget/exercices_summary_widget.dart';
import 'package:gardemonpoids/Views/widget/progress_widget.dart'; // Import du widget ProgressWidget
import 'package:gardemonpoids/Views/modifier_poids_form.dart'; // Import du formulaire de modification

class StatistiquesScreen extends StatefulWidget {
  final int userId;

  const StatistiquesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _StatistiquesScreenState createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  final db = DatabaseHelper();
  List<Poids> poidsList = [];

  @override
  void initState() {
    super.initState();
    _loadPoids();
  }

  Future<void> _loadPoids() async {
    try {
      final poids = await db.obtenirListePoids(widget.userId);
      setState(() {
        poidsList = poids
            .map((data) => Poids(
                  id: data['id'],
                  date: DateTime.parse(data['date']),
                  poidsdujour: (data['poidsdujour'] as num).toDouble(),
                  usrName: '', // Ajustez en fonction de vos besoins
                ))
            .toList();
      });
    } catch (e) {
      print("Erreur lors du chargement des poids : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Poids, DateTime>> series = [
      charts.Series(
        id: "Poids",
        data: poidsList,
        domainFn: (Poids poids, _) => poids.date,
        measureFn: (Poids poids, _) => poids.poidsdujour,
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
      )
    ];

    // Calculs pour les statistiques de poids
    double moyennePoids = poidsList.isNotEmpty
        ? poidsList.map((p) => p.poidsdujour).reduce((a, b) => a + b) /
            poidsList.length
        : 0;
    double poidsMax = poidsList.isNotEmpty
        ? poidsList.map((p) => p.poidsdujour).reduce((a, b) => a > b ? a : b)
        : 0;
    double poidsMin = poidsList.isNotEmpty
        ? poidsList.map((p) => p.poidsdujour).reduce((a, b) => a < b ? a : b)
        : 0;

    // Exemple de valeurs pour les widgets
    double progress = 0.7; // Exemple de progrès de 70%
    double currentWeight =
        poidsList.isNotEmpty ? poidsList.last.poidsdujour : 0;
    double targetWeight = 70; // Exemple de poids cible
    int totalSessions = 20; // Nombre total de séances prévues
    int sessionsCompleted = 15; // Nombre de séances complétées

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Statistiques & Historiques',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
              ),
              items: [
                ProgressWidget(progress: progress),
                ComparisonWidget(
                  currentWeight: currentWeight,
                  targetWeight: targetWeight,
                ),
                ExerciseSummaryWidget(
                  totalSessions: totalSessions,
                  sessionsCompleted: sessionsCompleted,
                ),
              ].map((widget) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: widget,
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              "Liste des poids",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView(
                children: poidsList.map((poids) {
                  return ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text('Poids du jour'),
                    subtitle: Text(
                        '${poids.poidsdujour} kg (${poids.date.toLocal().toString().split(' ')[0]})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showModifierPoidsDialog(poids),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(poids.id),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer ce poids ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _deletePoids(id);
                Navigator.of(context).pop();
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePoids(int id) async {
    try {
      await db.supprimerPoids(id);
      _loadPoids();
    } catch (e) {
      print("Erreur lors de la suppression du poids : $e");
    }
  }

  void _showModifierPoidsDialog(Poids poids) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModifierPoidsForm(
          poidsActuel: poids,
          onPoidsUpdated: _loadPoids,
        );
      },
    );
  }
}
