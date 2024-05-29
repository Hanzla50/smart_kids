import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/Start/login_page.dart';
import 'package:smart_kids_v1/pages/Start/profile_info.dart';
import 'package:smart_kids_v1/user_auth/firebase_authentication.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuthService auth = FirebaseAuthService(); // Use the correct service class name

  bool changeButton = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Center(
          child: Text(
            "",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/sign_up.gif",
              height: 300,
              fit: BoxFit.fill,
            ),
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Email",
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
            
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Choose Password",
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      // Trigger the signup process
                      signUP();
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: changeButton ? 50 : 150,
                      height: 50,
                      alignment: Alignment.center,
                      child: changeButton
                          ? Icon(Icons.done, color: Colors.white)
                          : const Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 82, 58, 49),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUP() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email and password cannot be empty"),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }
    else if (password!.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password should be greater than lenght 8"),
          backgroundColor: Colors.black,
        ),
      );
    }
    else if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email must be in the format '@gmail.com"),
          backgroundColor: Colors.black,
        ),
      );
    }

    setState(() {
      changeButton = true;
    });

    try {
      User? user = await auth.signUpWithEmailAndPassword(email, password);
      setState(() {
        changeButton = false;
      });

      if (user != null) {
        Navigator.pushNamed(context, "/login");
        print("User successfully created");
      } else {
        print("Failed to create user");
      }
    } catch (e) {
      debugPrint("Error occurred during sign up: $e");
      setState(() {
        changeButton = false;
      });
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The email address is already in use by another account."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred. Please try again later."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
