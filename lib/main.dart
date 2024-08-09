import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardemonpoids/SQLite/auth_service.dart';
import 'package:gardemonpoids/Views/auth.dart';
import 'package:gardemonpoids/Views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garde Mon Poids',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<Map<String, String?>>(
        future: AuthService().getUserSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final userId = snapshot.data!['userId'];
            final userName = snapshot.data!['userName'];
            if (userId != null && userName != null) {
              return HomeScreen(userId: userId, userName: userName); // Remplacez par l'écran d'accueil approprié
            }
          }
          return const AuthScreen(); // Redirige vers AuthScreen si pas de session
        },
      ),
    );
  }
}
