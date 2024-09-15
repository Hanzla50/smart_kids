import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:smart_kids_v1/pages/Daily_Schedule/models/task.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/chart/chart.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/new_schedule_task.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/schedule_lists/schedule_task_list.dart';
import 'package:permission_handler/permission_handler.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();

    // Initialize the timezone package
    tz.initializeTimeZones();

    // Initialize the notification plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Use your app icon here

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    requestNotificationPermission();
    checkAndRequestExactAlarmPermission();
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Handle the case where permission is denied
      // You might want to provide some guidance to the user on how to enable notifications.
    }
  }

  Future<void> checkAndRequestExactAlarmPermission() async {
    if (await Permission.manageExternalStorage.request().isDenied) {
      // Provide instructions to the user on how to enable this permission
      // Optionally, open app settings
      await openAppSettings();
    }
  }

  

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });

    // Schedule a notification at the selected time
    _scheduleNotification(expense);
  }

  void _scheduleNotification(Expense expense) async {
    final time = expense.time;
    final scheduledNotificationDateTime = tz.TZDateTime(
      tz.local,
      expense.date.year,
      expense.date.month,
      expense.date.day,
      time.hour,
      time.minute,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_reminder_channel', // Channel ID
      'Task Reminders', // Channel Name
      channelDescription: 'This channel is for task reminders notifications', // Channel Description
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // Ensure `fullScreenIntent` is not used unless you explicitly want it
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        expense.hashCode, // Unique ID for the notification
        'Task Reminder', // Notification Title
        'Reminder for your task: ${expense.title}', // Notification Body
        scheduledNotificationDateTime, // Scheduled time
        platformChannelSpecifics, // Notification details (platform-specific)
        androidAllowWhileIdle: true, // Allow notification to show even when idle
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time, // Ensures it fires at the right time
      );
    } catch (e) {
      // Handle any errors that occur during scheduling
      print('Error scheduling notification: $e');
    }
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No Task Found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = Expanded(
        child: ExpensesList(
          expenses: _registeredExpenses,
          onRemoveExpense: _removeExpense,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Task'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                SizedBox(
                  height: 200, // Adjust the height of the chart as needed
                  child: Chart(expenses: _registeredExpenses),
                ),
                mainContent,
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: double.infinity,
                    child: Chart(expenses: _registeredExpenses),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
