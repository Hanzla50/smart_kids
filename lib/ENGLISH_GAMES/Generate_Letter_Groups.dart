// import 'package:dummy_app/English_Games/Guess_Letters.dart';
// import 'package:dummy_app/English_Games/LetterMatching.dart';
// import 'package:dummy_app/English_Games/Missing_Letter_game.dart';
import 'package:flutter/material.dart';
// import 'package:dummy_app/English_Games/Arrange_letter_game.dart';

class GenerateLetterGroups extends StatelessWidget {
  final bool isUpperCase; // Recognize uppercase or lowercase
  final String gameType; // Recognize which game screen to navigate to

  GenerateLetterGroups({required this.isUpperCase, required this.gameType});

  // Made public by removing the underscore from the method name
  List<String> generateLetterGroups() {
    List<String> letterGroups = [];
    int startCharCode = isUpperCase ? 65 : 97; // 'A' or 'a'
    int endCharCode = isUpperCase ? 90 : 122; // 'Z' or 'z'

    for (int i = 0; i < endCharCode - startCharCode + 1; i += 5) {
      if (i + 4 < endCharCode - startCharCode + 1) {
        String group = String.fromCharCode(startCharCode + i) +
            String.fromCharCode(startCharCode + i + 1) +
            String.fromCharCode(startCharCode + i + 2) +
            String.fromCharCode(startCharCode + i + 3) +
            String.fromCharCode(startCharCode + i + 4);
        letterGroups.add(group);
      } else {
        // Handle the last group manually
        String group = String.fromCharCode(startCharCode + i);
        for (int j = i + 1; j < endCharCode - startCharCode + 1; j++) {
          group += String.fromCharCode(startCharCode + j);
        }
        letterGroups.add(group);
        break;
      }
    }

    // Manually add the last group as VWXYZ if the final group is less than 5 characters
    if (letterGroups.last.length < 5) {
      letterGroups.removeLast();
      letterGroups.add('VWXYZ');
    }

    return letterGroups;
  }

  @override
  Widget build(BuildContext context) {
    // Call the public method to generate letter groups
    List<String> letterGroups = generateLetterGroups();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                padding: const EdgeInsets.only(
                    top: 10, right: 80), // Bring AppBar lower
                child: AppBar(
                  title: const Text(
                    'Select Letters Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'madimiOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                  padding: const EdgeInsets.only(top: 50, bottom: 0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: letterGroups.length,
                    itemBuilder: (context, index) {
                      // Encrypt the display of the letter group
                      String encryptedGroup = letterGroups[index][0] +
                          '...' +
                          letterGroups[index]
                              .substring(letterGroups[index].length - 1);

                      // return Padding(
                      //   padding: const EdgeInsets.only(bottom: 16.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Widget nextPage;
                      //       switch (gameType) {
                      //         case 'ArrangeLetterGame':
                      //           nextPage = Arrange_letter_game(
                      //             selectedLetters: letterGroups[
                      //                 index], // Pass actual letters
                      //           );
                      //           break;
                      //         case 'GuessLetterGame':
                      //           nextPage = GuessLetterGame(
                      //             selectedLetters: letterGroups[
                      //                 index], // Pass actual letters
                      //           );
                      //           break;
                      //         case 'LetterMatchingGame':
                      //           nextPage = LetterMatchingGame(
                      //             selectedLetters: letterGroups[
                      //                 index], // Pass actual letters
                      //           );
                      //           break;
                      //         case 'MissingLetterGame':
                      //           nextPage = MissingLetterGame(
                      //             sequence: letterGroups[
                      //                 index], // Pass actual letters
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
                      //       padding: const EdgeInsets.all(16),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white.withOpacity(1),
                      //         borderRadius: BorderRadius.circular(30),
                      //         border: Border.all(
                      //           color: Colors.white,
                      //           width: 0,
                      //         ),
                      //       ),
                      //       child: Text(
                      //         encryptedGroup, // Display encrypted letters
                      //         style: TextStyle(
                      //           fontFamily: "arial",
                      //           fontSize: 30,
                      //           color: Colors.amber,
                      //           fontWeight: FontWeight.w900,
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
