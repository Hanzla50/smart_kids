// Import necessary packages and page widgets
import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/Homepage/home_page.dart';
import '../Start/profile_info.dart';
import 'Letters_EL.dart';
import 'Numbers_EL.dart';
import 'Phonics_EL.dart';
//import 'LetterMatching.dart';
import 'LetterMatching.dart';
// import '../DICTIONARY_GLOSSARY/dictionary_menu.dart';

class Literacy_Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0), // Remove app bar space
            child: AppBar(
              elevation: 0, // Remove app bar shadow
              backgroundColor: Colors.transparent, // Make app bar transparent
            ),
          ),
          extendBodyBehindAppBar: true, // Extend body behind app bar
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/Dictionary_Glossary/background.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                          16.0, 24.0, 0.0, 8.0), // Adjusted padding
                      child: Text(
                        'Early Literacy',
                        style: TextStyle(
                          fontFamily: 'MadimiOne', // Change font family
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0, // Adjusted font size
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 0.0, 16.0, 16.0), // Adjusted padding
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: <Widget>[
                            _buildMenuItem(context, 'Letters',
                                'assets/letters.png', Letters_EL()),
                            _buildMenuItem(context, 'Numbers',
                                'assets/numbers.png', Numbers_EL()),
                              _buildMenuItem(context, 'Numbers',

                                'assets/words.png', Phonics_EL()),
                                 _buildMenuItem(context, 'Numbers',
                                 'assets/letter_tracing.png', LetterMatching()),
                                _buildMenuItem(context, 'Numbers',
                                'assets/matching.png', LetterMatching()),
                                 _buildMenuItem(context, 'Numbers',
                                 'assets/letter_recognition.png', Letters_EL()),
              
                            
                            // Add more menu items as needed
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const Homepage(studentName: ''))
                            );
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .white, // Background color of the circle
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 30.0,
                                color: Colors.green, // Color of the arrow icon
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
