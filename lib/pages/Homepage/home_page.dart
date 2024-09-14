import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/pages/Art/Art Menu.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/tasks.dart';
import 'package:smart_kids_v1/pages/Homepage/Art.dart';
import 'package:smart_kids_v1/pages/Homepage/Dictionary.dart';
import 'package:smart_kids_v1/pages/Homepage/Games.dart';
import 'package:smart_kids_v1/pages/Homepage/Quiz.dart';
import 'package:smart_kids_v1/pages/Homepage/Subjects.dart';
import 'package:smart_kids_v1/pages/dictionary/dictionary_menu.dart';
import 'package:smart_kids_v1/pages/literacy/early_literacy_menu.dart';
import 'package:smart_kids_v1/pages/quiz/quiz.dart';
import 'Daily_Schedule.dart';
import 'package:smart_kids_v1/widgets/drawer.dart';
import 'notification_page.dart';
import 'saved_page.dart';

class Homepage extends StatefulWidget {
  final String studentName;

  const Homepage({Key? key, required this.studentName}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CurrentUserController controller = Get.put(CurrentUserController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String? _childName; // Variable to store fetched child's name
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchChildName(); // Fetch child's name on page load
  }

  Future<void> _fetchChildName() async {
    try {
      // Get the current authenticated parent
      User? parent = _auth.currentUser;

      if (parent != null) {
        // Query Firestore to fetch the child's name
        final snapshot = await _firestore
            .collection('profiles')
            .doc(parent.uid)
            .collection('children')
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Assuming you fetch the first child's name (modify if needed)
          final data = snapshot.docs.first.data();
          setState(() {
            _childName = data['childName']; // Fetch child's name from Firestore
          });
          print("Fetched child's name: $_childName"); // Log the fetched name
        }
      }
    } catch (e) {
      print("Error fetching child's name: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle Home navigation (Optional: No action needed for home)
        break;
      case 1:
        // Handle Notification navigation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
        break;
      case 2:
        // Handle Saved navigation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavedPage()),
        );
        break;
      default:
        // Handle default case
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () {
                // Observe the currentUser and show its data
                final user = controller.currentUser.value;
                return Text(
                  _childName ?? "Loading...",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ],
        leading: Obx(
          () {
            // Observe the currentUser and show its data
            final user = controller.currentUser.value;
            return GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer(); // Open drawer using GlobalKey
              },
              child: CircleAvatar(
                backgroundImage: user?.pfp != null
                    ? Image.network(user!.pfp!).image
                    : const AssetImage("assets/images/Profile.png"),
              ),
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 231, 240, 220),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      "assets/images/todaylessons.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Lessons',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 230, 0),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle Start button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: Icon(
                            Icons.play_circle_filled,
                            color: const Color.fromARGB(255, 255, 230, 3),
                            size: 30,
                          ),
                          label: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                            child: Text(
                              "START",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 230, 3),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            // Handle Recommendation button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Text(
                              "Recommendation",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              // Display six images in three rows
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First row with two images and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildImageWithText("assets/images/Early.png", "Early Learning", Literacy_Menu())),
                      SizedBox(width: 20),
                      Expanded(child: _buildImageWithText("assets/images/Dictionary.png", "Dictionary", Dictionary_Menu())),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Second row with two images and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildImageWithText("assets/images/subject.png", "Subjects", Subjectspage())),
                      SizedBox(width: 20),
                      Expanded(child: _buildImageWithText("assets/images/art.png", "Art", ArtMenu())),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Third row with two images and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildImageWithText("assets/images/game.png", "Games", Gamespage())),
                      SizedBox(width: 20),
                      Expanded(child: _buildImageWithText("assets/images/quiz.png", "Quizzes", HomeTask())),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildImageWithText("assets/images/to_do_list_logo.png", "Daily_Schedule", Expenses())),
                      SizedBox(width: 20),
                      Expanded(child: _buildImageWithText("assets/images/white.png", "", Daily_Schedule())),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 123, 250, 189),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Add bottom padding
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.discord_outlined),
                label: 'Feed',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithText(String imagePath, String text, Widget navigatePage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigatePage),
        );
      },
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, width: 100),
          SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
