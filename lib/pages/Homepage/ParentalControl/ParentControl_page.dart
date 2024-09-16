import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kids_v1/controllers/currentUserController.dart';
import 'package:smart_kids_v1/model/customUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/Profile_Screen.dart';
// import 'package:smart_kids_v1/pages/Homepage/ParentalControl/Profile_Screen.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/timeLimit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kids_v1/pages/Start/profile_info.dart';



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


class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int quizzesDone = 0;
  int totalScore = 0;
  double totalPercentage = 0.0;
  int generalKnowledgeQuizzesDone = 0;
  int mathQuizzesDone = 0;
  int englishQuizzesDone = 0;

  @override
  void initState() {
    super.initState();
    loadQuizReport();
  }

  Future<void> loadQuizReport() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch results for each quiz
    setState(() {
      generalKnowledgeQuizzesDone = prefs.getInt('general_knowledge_quizzes_done') ?? 0;
      mathQuizzesDone = prefs.getInt('math_quizzes_done') ?? 0;
      englishQuizzesDone = prefs.getInt('english_quizzes_done') ?? 0;

      final int generalKnowledgeTotalScore = prefs.getInt('general_knowledge_total_score') ?? 0;
      final int mathTotalScore = prefs.getInt('math_total_score') ?? 0;
      final int englishTotalScore = prefs.getInt('english_total_score') ?? 0;

      final int totalQuizzesDone = generalKnowledgeQuizzesDone + mathQuizzesDone + englishQuizzesDone;
      final int totalScoreAccumulated = generalKnowledgeTotalScore + mathTotalScore + englishTotalScore;

      quizzesDone = totalQuizzesDone;
      totalScore = totalScoreAccumulated;

      final totalQuestions = (generalKnowledgeQuizzesDone + mathQuizzesDone + englishQuizzesDone) == 0
          ? 1  // To prevent division by zero
          : (generalKnowledgeQuizzesDone + mathQuizzesDone + englishQuizzesDone);

      totalPercentage = (totalScoreAccumulated / totalQuestions) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 196, 196, 197),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activity Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 251, 251, 251),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Quizzes Done: $quizzesDone", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Total Score: $totalScore", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Total Percentage: ${totalPercentage.toStringAsFixed(2)}%", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text(
                        "Skills:",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 89, 89, 89)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 174, 192, 224),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quizzes Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 251, 251, 251),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("General Knowledge Quizzes Done: $generalKnowledgeQuizzesDone", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Math Quizzes Done: $mathQuizzesDone", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("English Quizzes Done: $englishQuizzesDone", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      const Text(
                        "Skills:",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 47, 21, 93)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
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


// class AddChildScreen extends StatefulWidget {
//   @override
//   _AddChildScreenState createState() => _AddChildScreenState();
// }

// class _AddChildScreenState extends State<AddChildScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Child'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Child Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _ageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Age',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String name = _nameController.text.trim();
//                 int age = int.tryParse(_ageController.text.trim()) ?? 0;
//                 if (name.isNotEmpty && age > 0) {
//                   // Create a new Child object with entered values
//                   Navigator.pop(context, Child(name, age));
//                 } else {
//                   // Show a snackbar if the input is invalid
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter valid name and age.'),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               },
//               child: Text('Save Child Information'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





