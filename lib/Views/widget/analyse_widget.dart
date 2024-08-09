import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gardemonpoids/JSON/poids.dart';

class AnalyseWidget extends StatelessWidget {
  final List<Poids> poidsList;

  const AnalyseWidget({Key? key, required this.poidsList}) : super(key: key);

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

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(
              "Historique de poids",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Use titleLarge instead of headline6
            ),
            SizedBox(
              height: 200,
              child: charts.TimeSeriesChart(
                series,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
