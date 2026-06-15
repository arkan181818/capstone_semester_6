import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';
import 'package:capstone/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  bool isChecked = false;
  bool isLoading = false;
  String? selectedGender;
  DateTime? selectedBirthDate;


  Future<void> registerUser() async {
    if (fullNameController.text.isEmpty ||
    usernameController.text.isEmpty ||
    emailController.text.isEmpty ||
    passwordController.text.isEmpty) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Lengkapi data"),
      ),
    );
  return;
}

if (passwordController.text !=
    confirmPasswordController.text) {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        "Password tidak sama",
      ),
    ),
  );

  return;
}

setState(() {
  isLoading = true;
});

final result = await AuthService.register(
  nama: fullNameController.text,
  username: usernameController.text,
  email: emailController.text,
  password: passwordController.text,
  nohp: phoneController.text,
  alamat: addressController.text,
  tglLahir: birthDateController.text,
);
if (result["status"] == 201) {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OtpScreen(
        email: emailController.text,
      ),
    ),
  );

} else {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result["data"]["msg"],
      ),
    ),
  );

}
setState(() {
  isLoading = false;
});


}

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

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
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              buildInput(
                "FULL NAME",
                "E.g. Budi Santoso",
                controller: fullNameController,
              ),
              buildInput(
                "USERNAME",
                "E.g. budi123",
                controller: usernameController,
              ),
              buildInput(
                "EMAIL ADDRESS",
                "runner@example.com",
                controller: emailController,
              ),
              buildInput(
                "NOMOR TELEPON",
                "E.g. +62 812...",
                controller: phoneController,
              ),
              buildInput(
                "TANGGAL LAHIR",
                "Pilih tanggal lahir",
                controller: birthDateController,
                readOnly: true,
                onTap: pickBirthDate,
              ),
              buildInput(
                "PASSWORD",
                "******",
                controller: passwordController,
                isPassword: true,
              ),
              buildInput(
                "CONFIRM PASSWORD",
                "******",
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              const Text(
                "JENIS KELAMIN",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedGender,
                hint: const Text(
                  "Pilih Jenis Kelamin",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "L",
                    child: Text("Laki-laki"),
                  ),
                  DropdownMenuItem(
                    value: "P",
                    child: Text("Perempuan"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              buildInput(
                "ALAMAT",
                "Masukkan alamat lengkap Anda",
                controller: addressController,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: Colors.orange,
                    value: isChecked,
                    onChanged: (v) {
                      setState(() {
                        isChecked = v!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "I agree to the Terms of Service and Privacy Policy.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isChecked && !isLoading
                      ? () {
                          registerUser();
                        }
                      : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "CREATE ACCOUNT →",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already part of the track? ",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickBirthDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedBirthDate = picked;
        birthDateController.text = formatDate(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}';
  }

  Widget buildInput(
    String label,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEFEFEF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
