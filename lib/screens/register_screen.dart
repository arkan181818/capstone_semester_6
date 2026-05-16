import 'package:flutter/material.dart';
import '/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RUNTRACK"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              const Text(
                "CREATE\nACCOUNT",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Step into the race management ecosystem.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// INPUTS
              buildInput("FULL NAME", "E.g. Budi Santoso"),
              buildInput("EMAIL ADDRESS", "runner@example.com"),
              buildInput("NOMOR TELEPON", "E.g. +62 812..."),
              buildInput("PASSWORD", "******", isPassword: true),
              buildInput("CONFIRM", "******", isPassword: true),

              const SizedBox(height: 10),

              /// DROPDOWN
              const Text("JENIS KELAMIN"),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEFEFEF),
                  border: InputBorder.none,
                ),
                hint: const Text("Pilih Jenis Kelamin"),
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                onChanged: (value) {},
              ),

              const SizedBox(height: 10),

              buildInput("ALAMAT", "Masukkan alamat lengkap Anda"),

              const SizedBox(height: 10),

              /// CHECKBOX
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (v) {
                      setState(() {
                        isChecked = v!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms of Service and Privacy Policy.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: isChecked
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      : null, // disable kalau belum centang
                  child: const Text(
                    "CREATE ACCOUNT →",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// LOGIN LINK
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already part of the track? ",
                      children: [
                        TextSpan(
                          text: "LOGIN",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// INPUT WIDGET
  Widget buildInput(String label, String hint,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEFEFEF),
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}