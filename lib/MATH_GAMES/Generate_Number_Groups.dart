import 'package:flutter/material.dart';
// import 'package:dummy_app/MATH_GAMES/Sort_Number_Game.dart';
// import 'package:dummy_app/MATH_GAMES/Guess_Number_Game.dart';

class GenerateNumberGroups extends StatelessWidget {
  final String gameType; // Recognize which game screen to navigate to

  GenerateNumberGroups({required this.gameType});

  List<String> _generateNumberGroups() {
    List<String> numberGroups = [];
    for (int i = 1; i <= 100; i += 10) {
      String group = '$i-${i + 9}';
      numberGroups.add(group);
    }
    print('Generated Number Groups: $numberGroups'); // Debugging print
    return numberGroups;
  }

  @override
  Widget build(BuildContext context) {
    List<String> numberGroups = _generateNumberGroups();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
           // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(1, 212, 119, 1),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Bring AppBar lower
                child: AppBar(
                  title: const Text(
                    'Select Number Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'madimiOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: numberGroups.length,
                    itemBuilder: (context, index) {
                      // return Padding(
                      //   padding: const EdgeInsets.only(bottom: 16.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Widget nextPage;
                      //       switch (gameType) {
                      //         case 'NumberArrangingGame':
                      //           nextPage = Arrange_number_game(
                      //             selectedNumbers: numberGroups[index],
                      //           );
                      //           break;
                      //         case 'GuessNumberGame':
                      //           nextPage = GuessNumberGame(
                      //             selectedNumbers: numberGroups[index],
                      //           );
                      //           break;
                             
                      //         // Add other cases for different games
                      //         default:
                      //           throw Exception('Unknown game type');
                      //       }

                      //       Navigator.of(context).push(
                      //         PageRouteBuilder(
                      //           pageBuilder:
                      //               (context, animation, secondaryAnimation) {
                      //             return nextPage;
                      //           },
                      //           transitionsBuilder: (context, animation,
                      //               secondaryAnimation, child) {
                      //             const begin = Offset(1.0, 0.0);
                      //             const end = Offset.zero;
                      //             const curve = Curves.easeInOut;
                      //             var tween = Tween(begin: begin, end: end)
                      //                 .chain(CurveTween(curve: curve));
                      //             var offsetAnimation = animation.drive(tween);
                      //             return SlideTransition(
                      //                 position: offsetAnimation, child: child);
                      //           },
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       padding: const EdgeInsets.all(0),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white.withOpacity(0.9),
                      //         borderRadius: BorderRadius.circular(10),
                      //         border: Border.all(
                      //           color: Colors.white,
                      //           width: 0,
                      //         ),
                      //       ),
                      //       child: Text(
                      //         numberGroups[index],
                      //         style: TextStyle(
                      //           fontFamily: "madimiOne",
                      //           fontSize: 28,
                      //           color: Colors.amber,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
