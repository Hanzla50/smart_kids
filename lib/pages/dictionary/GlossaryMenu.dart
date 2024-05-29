import 'package:flutter/material.dart';
import 'Glossary.dart';
class GlossaryMenu extends StatelessWidget {
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
                    'Glossary',
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
                            'ball',
                            'assets/Dictionary_Glossary/GlossaryMenu/ball_m.png',
                            'ball'),
                        _buildMenuItem(context, 'bicycle',
                            'assets/Dictionary_Glossary/GlossaryMenu/bicycle_m.png', 'bicycle'),
                                  _buildMenuItem(
                            context,
                            'pencil',
                            'assets/Dictionary_Glossary/GlossaryMenu/pencil_m.png',
                            'pencil'),
                      
                        _buildMenuItem(
                            context,
                            'butterfly',
                            'assets/Dictionary_Glossary/GlossaryMenu/butterfly_m.png',
                            'butterfly'),
                        _buildMenuItem(
                            context,
                            'chair',
                            'assets/Dictionary_Glossary/GlossaryMenu/chair_m.png',
                            'chair'),
                        _buildMenuItem(context, 'cup',
                            'assets/Dictionary_Glossary/GlossaryMenu/cup_m.png', 'cup'),
                        _buildMenuItem(
                            context,  'dog',
                            'assets/Dictionary_Glossary/GlossaryMenu/dog_m.png', 'dog'),
                        _buildMenuItem(context, 'fish',
                            'assets/Dictionary_Glossary/GlossaryMenu/fish_m.png', 'fish'),                   
                               _buildMenuItem(
                            context,'mountain',
                            'assets/Dictionary_Glossary/GlossaryMenu/mountain_m.png','mountain'),
                         
                               _buildMenuItem(
                            context,'rainbow',
                            'assets/Dictionary_Glossary/GlossaryMenu/rainbow_m.png', 'rainbow'),
                               _buildMenuItem(
                            context,'sun',
                            'assets/Dictionary_Glossary/GlossaryMenu/sun_m.png','sun'),
                               _buildMenuItem(
                            context,'tree',
                            'assets/Dictionary_Glossary/GlossaryMenu/tree_m.png','tree'),
                              _buildMenuItem( context,'book',
                            'assets/Dictionary_Glossary/GlossaryMenu/book_m.png',
                            'book'),
                              _buildMenuItem(
                            context,
                            'moon',
                            'assets/Dictionary_Glossary/GlossaryMenu/moon_m.png',
                            'moon'),
                            _buildMenuItem(
                            context,'milk',
                            'assets/Dictionary_Glossary/GlossaryMenu/milk_m.png','milk'),
                            _buildMenuItem(
                            context,'flower',
                            'assets/Dictionary_Glossary/GlossaryMenu/flower_m.png','flower'),
                            
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
            builder: (context) => Glossary(category: category),
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
