import 'GlossaryMenu.dart';
import 'package:flutter/material.dart';
import 'pic_dict_menu.dart';
import '../literacy/Letters_EL.dart';

class Dictionary_Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                      'Dictionary & Glossary',
                      style: TextStyle(
                        fontFamily: 'MadimiOne', // Change font family
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0, // Adjusted font size
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 0.0, 16.0, 16.0), // Adjusted padding
                      child: GridView.count(
                        crossAxisCount: 1, // One column per row
                        childAspectRatio: 3 / 1.5, // Increase box height
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        children: <Widget>[
                          _buildMenuItem(
                              context,
                              'Picture Dictionary',
                              'assets/Dictionary_Glossary/pic_dict.png',
                              Pic_dict_Menu()),
                          _buildMenuItem(
                              context,
                              'Glossary',
                              'assets/Dictionary_Glossary/glossary.png',
                              GlossaryMenu()),
                          _buildMenuItem(
                              context,
                              'Translation',
                              'assets/Dictionary_Glossary/translation.png',
                              Letters_EL()),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Colors.white, // Background color of the circle
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
              color: Colors.greenAccent.withOpacity(0.8),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // Changes position of shadow
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
