import 'package:flutter/material.dart';
import '../SQLite/database_helper.dart';
import '../JSON/poids.dart';

class ModifierPoidsForm extends StatefulWidget {
  final Poids poidsActuel;
  final VoidCallback onPoidsUpdated;

  const ModifierPoidsForm({
    Key? key,
    required this.poidsActuel,
    required this.onPoidsUpdated,
  }) : super(key: key);

  @override
  _ModifierPoidsFormState createState() => _ModifierPoidsFormState();
}

class _ModifierPoidsFormState extends State<ModifierPoidsForm> {
  final _poidsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _poidsController.text = widget.poidsActuel.poidsdujour.toString();
  }

  void _submit() async {
    final poids = int.tryParse(_poidsController.text);
    if (poids != null) {
      final db = DatabaseHelper();
      try {
        await db.modifierPoids(
          widget.poidsActuel.id,
          poids,
        );
        widget.onPoidsUpdated(); // Rafraîchir la liste des poids
        Navigator.of(context).pop();
      } catch (e) {
        // Gérer les erreurs si l'opération échoue
        print("Erreur lors de la mise à jour du poids : $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un poids valide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier le Poids'),
      content: TextField(
        controller: _poidsController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Poids du jour'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Modifier'),
        ),
      ],
    );
  }
}
