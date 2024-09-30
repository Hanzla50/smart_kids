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
    setState(() {});
  }

 Future<void> _deleteAccount() async {
  final bool? confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close the dialog and return false
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.clear();
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
               await FirebaseFirestore.instance.collection('profiles').doc(userId).delete();
             }
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
           
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
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
    setState(() {
      currentChild?['childName'] = newName;
      currentChild?['childAge'] = newAge;
    });
  }

  Future<void> _showEditProfileDialog(BuildContext context, String childId) async {
    if (childId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid child ID')),
      );
      return;
    }

    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide valid inputs')),
                  );
                  return;
                }

                _editChild(childId, newName, newAge);
                Navigator.of(dialogContext).pop();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid child ID')),
      );
      return;
    }

    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Child'),
          content: Text('Are you sure you want to delete this child profile?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _deleteChild(childId);
    }
  }

  Map<String, dynamic>? currentChild;

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
                      }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                         
                  }

                  final children = snapshot.data!.docs;

                  // Display the first child's data as the currentChild
                  var temp = children[0].data() as Map<String, dynamic>;
                  temp['id'] = children[0].id;
                  currentChild ??= temp;

                  return Row(
                    children: [
                     GestureDetector(
                                onTap: () {
                                  final currentUser = CustomUser(username: currentChild?['childName'], age: currentChild?['childAge']);
                                  controller.setCurrentUser(currentUser);
                                  setState(() {
                                    currentChild = currentChild;
                                    currentChild?["id"] = currentChild?['id'];
                                  });
                                  debugPrint("current user set to: ${currentUser.username}");
                                },
                                onLongPress: () {
                                  _showDeleteChildDialog(context, currentChild?['id']);
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
                                      // SizedBox(height: 8),
                                      Text(
                                        currentChild?['childName']+" (" +currentChild!['childAge'].toString()+')',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     _showEditProfileDialog(context, currentChild?['id']);
                                      //   },
                                      //   child: const Text('Edit'),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: children.length + 1,
                          itemBuilder: (context, index) {
                            if (index == children.length) {
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
                            }
                            else if(currentChild?['id']==children[index].id) return Padding(padding: EdgeInsets.all(0));
                             else {
                              final childData = children[index].data() as Map<String, dynamic>;
                              final String childId = children[index].id;
                              final String name = childData['childName'] ?? 'Unknown';
                              final int age = childData['childAge'] ?? 0;

                              return GestureDetector(
                                onTap: () {
                                  final currentUser = CustomUser(username: name, age: age);
                                  controller.setCurrentUser(currentUser);
                                  setState(() {
                                    currentChild = childData;
                                    currentChild?["id"] = children[index].id;
                                  });
                                  debugPrint("current user set to: ${currentUser.username}");
                                },
                                onLongPress: () {
                                  _showDeleteChildDialog(context, childId);
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
                                      // SizedBox(height: 8),
                                      Text(
                                        '$name ($age)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     _showEditProfileDialog(context, childId);
                                      //   },
                                      //   child: const Text('Edit'),
                                      // ),
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
                      _showEditProfileDialog(context, currentChild?["id"] ?? '');
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
