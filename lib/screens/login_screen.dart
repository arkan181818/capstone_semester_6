import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEDED), Color(0xFFD6E17A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// TITLE
                const Text(
                  "RUNTRACK",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Athlete Portal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Enter your credentials to continue",
                  style: TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 20),

                /// EMAIL
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("EMAIL ADDRESS"),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "name@event.com",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                /// PASSWORD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("PASSWORD"),
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),

                const SizedBox(height: 5),

                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    onPressed: () {
                      Get.offNamed(AppRoutes.home);
                    },
                    child: const Text("LOGIN →"),
                  ),
                ),

                const SizedBox(height: 15),

                /// SIGN UP (SUDAH BISA DIKLIK)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "OFFICIAL KOTA TEGAL RACE PARTNER",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}