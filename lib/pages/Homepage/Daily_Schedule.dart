import 'package:flutter/material.dart';

class Daily_Schedule extends StatelessWidget {
  const Daily_Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/to_do_list.jpg'), // Update with your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
