import 'package:flutter/material.dart';
import 'All_pic_dict.dart';

class Pic_dict_Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Picture Dictionary',
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
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: <Widget>[
                        _buildMenuItem(
                            context,
                            'Animals',
                            'assets/Dictionary_Glossary/animals.png',
                            'Animals'),
                        _buildMenuItem(context, 'Birds',
                            'assets/Dictionary_Glossary/birds.png', 'Birds'),
                        _buildMenuItem(context, 'Fruits',
                            'assets/Dictionary_Glossary/fruits.png', 'Fruits'),
                        _buildMenuItem(
                            context,
                            'Vegetables',
                            'assets/Dictionary_Glossary/vegitables.png',
                            'Vegetables'),
                        _buildMenuItem(
                            context,
                            'Body Parts',
                            'assets/Dictionary_Glossary/body_parts.png',
                            'Body_Parts'),
                        _buildMenuItem(context, 'Shapes',
                            'assets/Dictionary_Glossary/shapes.png', 'Shapes'),
                        _buildMenuItem(
                            context,
                            'Vehicles',
                            'assets/Dictionary_Glossary/vehicles.png',
                            'Vehicles'),
                        _buildMenuItem(context, 'Colors',
                            'assets/Dictionary_Glossary/colors.png', 'Colors'),
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
                          color: Colors.white, // Background color of the circle
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
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String imagePath, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllPicDict(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.6),
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
