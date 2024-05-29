import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/pages/Homepage/home_page.dart';
import 'package:smart_kids_v1/routes.dart';

import '../../model/customUser.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CurrentUserController controller = Get.put(CurrentUserController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController _childNameController = TextEditingController();
  TextEditingController _childAgeController = TextEditingController();
  String? _gender; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/Profile.png",
              height: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Text(
              "Profile Info",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _childNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Child Name",
                        labelText: "Child Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid child name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: _childAgeController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Child Age",
                        labelText: "Child Age",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid age';
                        }
                        // Additional validation for age (e.g., numeric validation) can be added here
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Gender Radio Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: "male",
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            Text(
                              "Male",
                              style: TextStyle(color: Colors.white),
                            ),
                            Radio<String>(
                              value: "female",
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            Text(
                              "Female",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // TextFormField(
                    //   obscureText: true,
                    //   style: TextStyle(color: Colors.black),
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     hintText: "Enter Age",
                    //     labelText: "Age",
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     prefixIcon: Icon(Icons.calendar_today),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter a valid age';
                    //     }
                    //     // Additional validation for age (e.g., numeric validation) can be added here
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "GO",
                        style: TextStyle(fontSize: 35, color: Colors.black),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.setCurrentUser(
                            CustomUser(username: _childNameController.text, age: int.parse(_childAgeController.text))
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homepage(studentName: _childNameController.text),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }
}