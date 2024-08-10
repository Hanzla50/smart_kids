import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { Quiz, Assesment, Drawing, Lectures, Others }

const categoryIcons = {
  Category.Quiz: Icons.quiz,
  Category.Assesment: Icons.assignment,
  Category.Drawing: Icons.draw_outlined,
  Category.Lectures: Icons.work,
  Category.Others: Icons.free_cancellation_outlined,
};

class Expense {
  Expense({
    required this.time,
    required this.title,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final TimeOfDay time; // Replaced `double amount` with `TimeOfDay time`
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  String get formattedTime {
    // Manual formatting of TimeOfDay
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes'; // Return time in HH:mm format
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList(); // Alternative constructor

  final Category category;
  final List<Expense> expenses;

  // Assuming you want to aggregate the times (if needed)
  TimeOfDay get earliestTime {
    return expenses.map((e) => e.time).reduce((a, b) =>
        a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute)
            ? a
            : b);
  }
}
