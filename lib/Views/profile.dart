import 'package:flutter/material.dart';
import 'package:gardemonpoids/Components/colors.dart';
import 'package:gardemonpoids/JSON/users.dart';
import 'package:gardemonpoids/Views/login.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, this.profile});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 77,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/no_user.jpg"),
                  radius: 75,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile?.fullName ?? "",
                style: const TextStyle(fontSize: 28, color: primaryColor),
              ),
              Text(
                profile?.email ?? "",
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
              /* Button(
                  label: "SIGN UP",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }), */
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                title: Text(profile?.fullName ?? ""),
                subtitle:
                    const Text("Full name", style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.email, size: 30),
                title: Text(profile?.email ?? ""),
                subtitle: const Text("Email"),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle, size: 30),
                subtitle: Text(profile?.usrName ?? ""),
                title: const Text("Username"),
              ),
              // const Spacer(), // Pushes the button to the bottom
              IconButton(
                icon: Icon(Icons.logout, color: Colors.red, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
