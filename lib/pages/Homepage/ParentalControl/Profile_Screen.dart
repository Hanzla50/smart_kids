import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/model/customUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/timeLimit.dart';
import 'package:smart_kids_v1/pages/Start/profile_info.dart';

class Child {
  final String name;
  final int age;

  Child(this.name, this.age);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      json['name'] as String? ?? 'Unknown',
      json['age'] as int? ?? 0,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CurrentUserController controller = Get.put(CurrentUserController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addChild(Map<String, dynamic> newChild) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .collection('children')
        .add(newChild);
  }

  Future<void> _deleteChild(String childId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .collection('children')
        .doc(childId)
        .delete();
    setState(() {
      
    });
  }

  Future<void> _deleteAccount() async {
    final bool? confirmDelete = await Get.dialog(
      AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Get.offAllNamed('/login');
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('profiles').doc(userId).delete();
      }
    }
  }

  Future<void> _editChild(String childId, String newName, int newAge) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .collection('children')
        .doc(childId)
        .update({
          'childName': newName,
          'childAge': newAge,
        });
      setState((){
      currentChild?['childName']=newName;
      currentChild?['childAge']=newAge;

      });
  }
Future<void> _showEditProfileDialog(BuildContext context, String childId) async {
  if (childId.isEmpty) {
    // Display an error message using Flutter's native SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid child ID')),
    );
    return;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Show a native Flutter dialog
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Edit Child Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Child Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Child Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String newName = nameController.text.trim();
              final int newAge = int.tryParse(ageController.text) ?? 0;

              if (newName.isEmpty || newAge <= 0) {
                // Show error using a native SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please provide valid inputs')),
                );
                return;
              }

              // Call the function to update the child data
              _editChild(childId, newName, newAge);
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}

 Future<void> _showDeleteChildDialog(BuildContext context, String childId) async {
  if (childId.isEmpty) {
    // Show an error message using native Flutter's SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid child ID')),
    );
    return;
  }

  // Show a native dialog and get the result
  final bool? confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Delete Child'),
        content: Text('Are you sure you want to delete this child profile?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false); // Close the dialog, return false
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true); // Close the dialog, return true
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );

  // Check the result and perform deletion if confirmed
  if (confirmDelete == true) {
    await _deleteChild(childId);
  }
}

 
  Map<String,dynamic>? currentChild;
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          const Text(
            'Your Children',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('children')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading children'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No children added yet'));
                }

                final children = snapshot.data!.docs;
                var temp = children[0].data() as Map<String, dynamic>;
                temp['id']=children[0].id;
                currentChild ??= temp;
                
                return Row(
                  children: [ 
                    Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage('assets/images/Profile.png'),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    currentChild?["childName"]+"("+currentChild?["childAge"].toString()+")",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Button to edit profile for a specific child

                                ],
                              ),
                            ),
                          
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: children.length + 1,
                        itemBuilder: (context, index) {
                          if (index == children.length) {
                            // Add Child button
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[300],
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(),
                                          ),
                                        );
                                        if (result != null) {
                                          _addChild(result);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  const Text(
                                    'Add Child',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Display each child
                            final childData = children[index].data() as Map<String, dynamic>;
                            final String childId = children[index].id;
                            final String name = childData['childName'] ?? 'Unknown'; // Corrected key
                            final int age = childData['childAge'] ?? 0;
                      
                            return GestureDetector(
                              onTap: () {
                                final currentUser = CustomUser(username: name, age: age);
                                controller.setCurrentUser(currentUser);
                                setState(() {
                                currentChild=childData;
                                currentChild?["id"]=children[index].id; 
                                });
                                debugPrint("current user set to: ${currentUser.username}");
                              },
                              onLongPress: () {
                                _showDeleteChildDialog(context,childId);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage('assets/images/Profile.png'),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '$name ($age)',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Button to edit profile for a specific child
                                    ElevatedButton(
                                      onPressed: () {
                                        _showEditProfileDialog(context,currentChild?['id']); // Pass the childId here
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    final username = controller.currentUser.value?.username ?? '';
                    if (username.isEmpty) {
                      Get.snackbar('Error', 'No child selected');
                      return;
                    }
                    debugPrint(currentChild?["id"]);
                    _showEditProfileDialog(context,currentChild?["id"]); // This can now be removed
                  },
                  child: _buildIconButton('Edit Profile', Icons.edit),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeLimitScreen()),
                    );
                  },
                  child: _buildIconButton('Time Limit', Icons.timer),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _deleteAccount,
                  child: _buildIconButton('Delete Account', Icons.delete),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // Navigate to the login screen or home screen
                      Get.offAllNamed('/signin');
                    } catch (e) {
                      print('Error signing out: $e');
                    }
                  },
                  child: _buildIconButton('Logout', Icons.logout),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildIconButton(String label, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 24,
            color: Colors.black,
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}