import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar is intentionally left empty
        backgroundColor: Color.fromRGBO(
            255, 255, 255, 1.0), // Match the AppBar color with the background
        elevation: 0, // Remove the shadow of the AppBar
      ),
      backgroundColor: Color.fromRGBO(
          255, 255, 255, 1.0), // Set background color using RGB values
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(
              255, 255, 255, 1.0), // Set background color of the Container
          child: Column(
            children: <Widget>[
              // Add an image at the top of the screen
              Container(
                height: 150.0, // Adjust the height as needed
                width: double.infinity,
                child: Image.asset(
                  'assets/app_logo.png', // replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
              Spacer(), // Pushes the content down to center vertically
              Container(
                height: 300.0, // Adjust the height as needed
                width: double.infinity,
                child: Image.asset(
                  'assets/GIFS/gif3.gif', // replace with your GIF asset path
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20), // Add some space between the GIF and text
              Text(
                'SMART KIDS',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // Set text color to contrast with the background
                ),
              ),
              Spacer(), // Pushes the button to the bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0), // Reduced bottom padding
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed("/login"),
                  child: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(74, 185, 113,
                        1.0), // Set the background color using RGB values
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal:
                            50.0), // Decreased padding for smaller button height
                    textStyle: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
