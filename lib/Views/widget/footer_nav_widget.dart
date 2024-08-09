import 'package:flutter/material.dart';
import 'package:gardemonpoids/Views/ajout_poids_form.dart';
import 'package:gardemonpoids/Views/widget/conseils_screen.dart';
import 'package:gardemonpoids/Views/widget/statistiques_screen.dart'; // Importer StatistiquesScreen

class FooterNavWidget extends StatelessWidget {
  final int userId;
  final VoidCallback onPoidsAdded;

  const FooterNavWidget({
    Key? key,
    required this.userId,
    required this.onPoidsAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.indigoAccent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton "Statistique" à gauche
              Flexible(
                child: _buildNavButton(
                  context,
                  icon: Icons.bar_chart,
                  label: 'Statistique',
                  color: Colors.white,
                  onPressed: () {
                    // Action du bouton "Statistique" pour ouvrir StatistiquesScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StatistiquesScreen(userId: userId),
                      ),
                    );
                  },
                ),
              ),
              // Bouton central "Ajouter"
              Expanded(
                child: _buildFloatingActionButton(context),
              ),
              // Bouton "Conseils" à droite
              Flexible(
                child: _buildNavButton(
                  context,
                  icon: Icons.info,
                  label: 'Conseils',
                  color: Colors.white,
                  onPressed: () {
                    // Action du bouton "Conseils" pour ouvrir ConseilsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConseilsScreen(userId: userId),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.indigo,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AjoutPoidsForm(
                  userId: userId,
                  onPoidsAdded: onPoidsAdded,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
