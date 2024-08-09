import 'package:flutter/material.dart';
import '../SQLite/database_helper.dart';

class AjoutPoidsForm extends StatefulWidget {
  final int userId;
  final VoidCallback onPoidsAdded;

  const AjoutPoidsForm({
    Key? key,
    required this.userId,
    required this.onPoidsAdded,
  }) : super(key: key);

  @override
  _AjoutPoidsFormState createState() => _AjoutPoidsFormState();
}

class _AjoutPoidsFormState extends State<AjoutPoidsForm> {
  final _poidsController = TextEditingController();

  void _submit() async {
    final poids = int.tryParse(_poidsController.text);
    if (poids != null) {
      final db = DatabaseHelper();
      await db.enregistrerPoids(poids, widget.userId);
      widget.onPoidsAdded(); // Rafraîchir la liste des poids
      Navigator.of(context).pop();
    } else {
      // Afficher une erreur si la saisie n'est pas valide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un poids valide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un Poids'),
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
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
