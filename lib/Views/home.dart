import 'package:flutter/material.dart';
import 'package:gardemonpoids/Components/colors.dart';
import 'package:gardemonpoids/SQLite/auth_service.dart';
import 'package:gardemonpoids/Views/login.dart';
import 'package:gardemonpoids/Views/modifier_poids_form.dart';
import 'package:gardemonpoids/Views/profile.dart';
import '../SQLite/database_helper.dart';
import 'package:gardemonpoids/JSON/poids.dart';
import 'package:gardemonpoids/JSON/users.dart';
import 'package:gardemonpoids/Views/widget/footer_nav_widget.dart';
import 'package:gardemonpoids/Views/widget/analyse_widget.dart'; // Import the new widget
import 'ajout_poids_form.dart';

class HomeScreen extends StatefulWidget {
  final Users? userProfile;
  final String userName;
  final String userId;
  const HomeScreen({
    super.key,
    required this.userName,
    required this.userId,
    this.userProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper();
  Users? currentUser;
  List<Poids> poidsList = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user =
          await db.getUser(widget.userName); // Utilisation de widget.userName
      setState(() {
        currentUser = user;
      });
      if (currentUser != null) {
        _loadPoids(); // Load weight data after user is retrieved
      }
    } catch (e) {
      print("Erreur lors du chargement de l'utilisateur : $e");
    }
  }

  Future<void> _loadPoids() async {
    if (currentUser != null && currentUser!.usrId != null) {
      try {
        final poids = await db.obtenirListePoids(currentUser!.usrId!);
        print("Poids récupérés : $poids"); // Vérifiez les données récupérées
        setState(() {
          poidsList = poids
              .map((data) => Poids(
                    id: data['id'],
                    date: DateTime.parse(data['date']),
                    poidsdujour: (data['poidsdujour'] as num).toDouble(),
                    usrName: currentUser!.usrName,
                  ))
              .take(7)
              .toList();
          print(
              "poidsList après transformation : $poidsList"); // Vérifiez la liste après transformation
        });
      } catch (e) {
        print("Erreur lors du chargement des poids : $e");
      }
    }
  }

  void _logout() async {
    await AuthService().clearUserSession();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showAjoutPoidsDialog() {
    if (currentUser != null && currentUser!.usrId != null) {
      showDialog(
        context: context,
        builder: (context) => AjoutPoidsForm(
          userId: currentUser!.usrId!,
          onPoidsAdded: _loadPoids, // Rafraîchit la liste après ajout
        ),
      );
    } else {
      print("Utilisateur non chargé");
    }
  }

  Future<void> _deletePoids(int id) async {
    try {
      await db.supprimerPoids(id);
      _loadPoids();
    } catch (e) {
      print("Erreur lors de la suppression du poids : $e");
    }
  }

  void _showModifierPoidsDialog(Poids poidsActuel) {
    if (currentUser != null && currentUser!.usrId != null) {
      showDialog(
        context: context,
        builder: (context) => ModifierPoidsForm(
          poidsActuel: poidsActuel,
          onPoidsUpdated: _loadPoids,
        ),
      );
    } else {
      print("Utilisateur non chargé");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        //backgroundColor: primaryColor,
      ),
      drawer: Drawer(
        child: Profile(profile: widget.userProfile),
      ),
      body: Column(
        children: [
          if (poidsList.isNotEmpty) AnalyseWidget(poidsList: poidsList),
          if (poidsList.isEmpty)
            const Center(
                child:
                    CircularProgressIndicator()), // Ajout d'un indicateur de chargement si la liste est vide
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Text(
                  "Derniers poids",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...poidsList.map((poids) {
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: currentUser != null
          ? FooterNavWidget(
              userId: currentUser!.usrId!,
              onPoidsAdded: _loadPoids,
            )
          : Container(),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce poids ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
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
}
