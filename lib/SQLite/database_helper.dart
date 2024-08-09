import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';

class DatabaseHelper {
  final String databaseName = "gardemonpoids.db";
  final String userTableName = 'users';
  final String poidsTableName = 'poids';

  // Table creation queries
  final String userTableCreationQuery = '''
    CREATE TABLE users (
      usrId INTEGER PRIMARY KEY AUTOINCREMENT,
      fullName TEXT,
      email TEXT,
      usrName TEXT UNIQUE,
      usrPassword TEXT
    )
  ''';

  final String poidsTableCreationQuery = '''
    CREATE TABLE poids (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usrId INTEGER,
      date TEXT,
      poidsdujour INTEGER,
      FOREIGN KEY (usrId) REFERENCES users (usrId)
    )
  ''';

  // Initialize database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute(userTableCreationQuery);
      await db.execute(poidsTableCreationQuery);
    });
  }

  // Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    try {
      var result = await db.query(
        userTableName,
        where: "usrName = ? AND usrPassword = ?",
        whereArgs: [usr.usrName, usr.password],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
      return false;
    }
  }

  // Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    try {
      if (await isUsernameTaken(usr.usrName)) {
        throw Exception("Nom d'utilisateur déjà pris");
      }
      return await db.insert(userTableName, usr.toMap());
    } catch (e) {
      print("Erreur lors de la création de l'utilisateur : $e");
      return -1; // Return -1 to indicate failure
    }
  }

  // Get current user details
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();
    try {
      var res =
          await db.query(userTableName, where: "usrName = ?", whereArgs: [usrName]);
      return res.isNotEmpty ? Users.fromMap(res.first) : null;
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }

  // Check if a username already exists
  Future<bool> isUsernameTaken(String usrName) async {
    final Database db = await initDB();
    var res =
        await db.query(userTableName, where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty;
  }

  // Add weight record
  Future<int> enregistrerPoids(int poidsdujour, int usrId) async {
    final Database db = await initDB();
    try {
      final date = DateTime.now().toIso8601String(); // Format de date ISO 8601
      return await db.insert(poidsTableName, {
        'usrId': usrId,
        'date': date,
        'poidsdujour': poidsdujour,
      });
    } catch (e) {
      print("Erreur lors de l'enregistrement du poids : $e");
      return -1; // Return -1 to indicate failure
    }
  }

  // Get list of weight records for a user
  Future<List<Map<String, dynamic>>> obtenirListePoids(int usrId) async {
    final Database db = await initDB();
    try {
      return await db.query(
        poidsTableName,
        where: "usrId = ?",
        whereArgs: [usrId],
        orderBy: "date DESC",
      );
    } catch (e) {
      print("Erreur lors de la récupération des poids : $e");
      return [];
    }
  }

  // Get most recent weight record for a user
  Future<Map<String, dynamic>?> obtenirDernierPoidsEnregistre(int usrId) async {
    final Database db = await initDB();
    try {
      final res = await db.query(
        poidsTableName,
        where: "usrId = ?",
        whereArgs: [usrId],
        orderBy: "date DESC",
        limit: 1,
      );
      return res.isNotEmpty ? res.first : null;
    } catch (e) {
      print("Erreur lors de la récupération du dernier poids : $e");
      return null;
    }
  }

  // Modifier le poids
Future<int> modifierPoids(int id, int poidsdujour) async {
  final Database db = await initDB();
  try {
    final date = DateTime.now().toIso8601String(); // Format de date ISO 8601
    return await db.update(
      poidsTableName,
      {'poidsdujour': poidsdujour, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print("Erreur lors de la modification du poids : $e");
    return -1; // Return -1 to indicate failure
  }
}

// Supprimer le poids
Future<int> supprimerPoids(int id) async {
  final Database db = await initDB();
  try {
    return await db.delete(
      poidsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print("Erreur lors de la suppression du poids : $e");
    return -1; // Return -1 to indicate failure
  }
}

Future<void> saveUserData(String userId, String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('token', token);
}
Future<Map<String, String?>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final token = prefs.getString('token');
  return {
    'userId': userId,
    'token': token,
  };
}
Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  await prefs.remove('token');
}


}
