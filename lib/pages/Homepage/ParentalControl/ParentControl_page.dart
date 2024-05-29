import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/model/customUser.dart';
import 'package:smart_kids_v1/pages/Start/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/timeLimit.dart';


class ParentControlpage extends StatefulWidget {
  const ParentControlpage({Key? key}) : super(key: key);

  @override
  _ParentControlpageState createState() => _ParentControlpageState();
}

class _ParentControlpageState extends State<ParentControlpage> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecordScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Parent Area",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          color: Colors.blue,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Record',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 196, 196, 197),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '                Activity Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 251, 251, 251),
                          

                        ),
                      ),
                      SizedBox(height: 10),
                      Text("      Activity Done:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("      Total Score:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("      Total Percentage:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("      Right:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("      Wrong:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                        "  Skills:",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 174, 192, 224),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '               Quizzes Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 251, 251, 251),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("     Activity Done:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("     Total Score:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("     Total Percentage:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("     Right:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("     Wrong:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(
                        "  Skills:",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 47, 21, 93)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), // Add spacing between the row and additional texts
            const Text(
              'Overall Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            const Center(
              child: Text(
                'Medium',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record'),
      ),
      body: Container(
        color: Colors.blue,
        
        child: Text('Record Screen'),
      ),
    );
  }
}

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
      json['name'] as String,
      json['age'] as int,
    );
  }
}



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CurrentUserController controller = Get.put(CurrentUserController());
  List<Child> children = [];

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final childListJson = prefs.getStringList('childList') ?? [];
    setState(() {
      children = childListJson
          .map((childJson) => Child.fromJson(jsonDecode(childJson)))
          .toList();
    });
  }

  Future<void> _addChild(Child newChild) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    children.add(newChild);
    final childListJson = children.map((child) => jsonEncode(child.toJson())).toList();
    await prefs.setStringList('childList', childListJson);
    setState(() {});
  }

  Future<void> _deleteChild(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Child'),
          content: Text('Are you sure you want to delete this child?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      children.removeAt(index);
      final childListJson = children.map((child) => jsonEncode(child.toJson())).toList();
      await prefs.setStringList('childList', childListJson);
      setState(() {});
    }
  }

  Future<void> _deleteAccount() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Perform account deletion logic
    }
  }

  Future<void> _editChild(int index, String newName, int newAge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    children[index] = Child(newName, newAge);
    final childListJson = children.map((child) => jsonEncode(child.toJson())).toList();
    await prefs.setStringList('childList', childListJson);
    setState(() {});
  }

  Future<void> _showEditProfileDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
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
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newName = nameController.text;
                int newAge = int.tryParse(ageController.text) ?? 0;
                _updateProfile(newName, newAge);
                Navigator.pop(context); 
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile(String newName, int newAge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int childIndex = children.indexWhere((element) => element.name == controller.currentUser.value.username);
    controller.updateUser(newName, newAge);
    _editChild(childIndex, newName, newAge);
  }

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
              child: Row(
                children: [
                  Obx(
                    () => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
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
                              '${controller.currentUser.value?.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
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
                                          builder: (context) => AddChildScreen(),
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
                          // Child item
                          Child child = children[index];
                          return GestureDetector(
                            onTap: () {
                              final currentUser = CustomUser(username: child.name, age: child.age);
                              controller.setCurrentUser(currentUser);
                              debugPrint("current user set to: ${currentUser.username}");
                            },
                            onLongPress: () {
                              _deleteChild(index);
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
                                    '${child.name} (${child.age})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: _showEditProfileDialog,
                    child: _buildIconButton('Edit Profile', Icons.edit),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLimitScreen()));
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
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacementNamed(context, '/signin');
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


class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Child'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Child Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Age',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                int age = int.tryParse(_ageController.text.trim()) ?? 0;
                if (name.isNotEmpty && age > 0) {
                  // Create a new Child object with entered values
                  Navigator.pop(context, Child(name, age));
                } else {
                  // Show a snackbar if the input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid name and age.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Save Child Information'),
            ),
          ],
        ),
      ),
    );
  }
}





