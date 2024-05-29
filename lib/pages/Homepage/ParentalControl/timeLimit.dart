import 'dart:async';
import 'package:flutter/material.dart';

class TimeLimitScreen extends StatefulWidget {
  @override
  _TimeLimitScreenState createState() => _TimeLimitScreenState();
}

class _TimeLimitScreenState extends State<TimeLimitScreen> {
  bool _isTimeLimitEnabled = false;
  String _selectedTimeLimit = ''; 
  Timer? _timer; 

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Limit Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Limit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _isTimeLimitEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isTimeLimitEnabled = value;
                      _selectedTimeLimit = ''; 
                      _timer?.cancel(); // Cancel any existing timer
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_isTimeLimitEnabled)
              ElevatedButton(
                onPressed: () {
                  _showTimeLimitMenu();
                },
                child: Text('Show Time Limit Menu'),
              ),
          ],
        ),
      ),
    );
  }

  void _showTimeLimitMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Limit Menu'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('5 Minutes'),
                    leading: Radio(
                      value: '5 Minutes',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('1 Hour'),
                    leading: Radio(
                      value: '1 Hour',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('2 Hours'),
                    leading: Radio(
                      value: '2 Hours',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('3 Hours'),
                    leading: Radio(
                      value: '3 Hours',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('4 Hours'),
                    leading: Radio(
                      value: '4 Hours',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Custom'),
                    leading: Radio(
                      value: 'Custom',
                      groupValue: _selectedTimeLimit,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeLimit = value as String;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _handleTimeLimit();
                      Navigator.pop(context);
                    },
                    child: Text('Apply'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _handleTimeLimit() {
    if (_selectedTimeLimit.isNotEmpty) {
      int selectedMinutes;
      if (_selectedTimeLimit == '5 Minutes') {
        selectedMinutes = 5;
      } else if (_selectedTimeLimit == '1 Hour') {
        selectedMinutes = 60;
      } else if (_selectedTimeLimit == '2 Hours') {
        selectedMinutes = 120;
      } else if (_selectedTimeLimit == '3 Hours') {
        selectedMinutes = 180;
      } else if (_selectedTimeLimit == '4 Hours') {
        selectedMinutes = 240;
      } else {
        selectedMinutes = 0;
      }

      // Cancel any existing timer
      _timer?.cancel();

      // Start a new timer
      _timer = Timer(Duration(minutes: selectedMinutes), () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Time Limit Exceeded'),
              content: Text('Your time limit of $_selectedTimeLimit has been exceeded.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }
}

