import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/ParentControl_page.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  var inputText = "";
  var actives = [false, false, false, false, false];
  var clears = [false, false, false, false, false];
  var values = [1, 2, 3, 2, 1];
  var currentIndex = 0;
  var message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter Your Password",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < actives.length; i++)
                            AnimationBoxItem(
                              clear: clears[i],
                              active: actives[i],
                              value: values[i],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GridView.builder(
                  padding: EdgeInsets.all(0.0),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8 / 0.6,
                  ),
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(4.0),
                    width: 50,
                    height: 50,
                    child: index == 9
                        ? SizedBox()
                        : Center(
                            child: MaterialButton(
                              onPressed: () {
                                if (index == 11) {
                                  inputText =
                                      inputText.substring(0, inputText.length - 1);
                                  clears = clears.map((e) => false).toList();
                                  currentIndex--;
                                  if (currentIndex >= 0)
                                    setState(() {
                                      clears[currentIndex] = true;
                                      actives[currentIndex] = false;
                                    });
                                  else {
                                    currentIndex = 0;
                                  }
                                  return;
                                } else
                                  inputText += numbers[
                                          index == 10 ? index - 1 : index]
                                      .toString();
                                if (inputText.length == 5) {
                                  setState(() {
                                    clears = clears.map((e) => true).toList();
                                    actives = actives.map((e) => false).toList();
                                  });
                                  if (inputText == "11223") {
                                    setState(() {
                                      message = "Success";
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ParentControlpage()),
                                    );
                                  } else {
                                    setState(() {
                                      message = "Try Again";
                                    });
                                  }
                                  inputText = "";
                                  currentIndex = 0;
                                  return;
                                }
                                message = "";
                                clears = clears.map((e) => false).toList();
                                setState(() {
                                  actives[currentIndex] = true;
                                  currentIndex++;
                                });
                              },
                              color: Colors.white,
                              minWidth: 55,
                              height: 55,
                              child: index == 11
                                  ? Icon(
                                      Icons.backspace,
                                      color: Colors.green,
                                    )
                                  : Text(
                                      "${numbers[index == 10 ? index - 1 : index]}",
                                      style: TextStyle(
                                          fontSize: 21.0, color: Colors.green)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                  ),
                  itemCount: 12,
                ),
              ),
              SizedBox(
                height: 50.0,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AnimationBoxItem extends StatefulWidget {
  final clear;
  final value;
  final active;

  const AnimationBoxItem(
      {Key? key, this.clear = false, this.active = false, this.value})
      : super(key: key);

  @override
  State<AnimationBoxItem> createState() => _AnimationBoxItemState();
}

class _AnimationBoxItemState extends State<AnimationBoxItem>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clear) {
      animationController.forward(from: 0);
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Container(
        margin: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(),
            AnimatedContainer(
              duration: Duration(milliseconds: 800),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.active ? Colors.green : Colors.white24),
            ),
            Align(
              alignment: Alignment(0, animationController.value / widget.value - 1),
              child: Opacity(
                opacity: 1 - animationController.value,
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.active ? Colors.green : Colors.green),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      body: const Center(
        child: Text(
          'Password Entered Successfully!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
