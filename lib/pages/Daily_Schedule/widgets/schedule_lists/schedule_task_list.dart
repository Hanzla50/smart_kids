
import 'package:flutter/material.dart';

import 'package:smart_kids_v1/pages/Daily_Schedule/models/task.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/schedule_lists/schedule_task.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: ((ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(color: Theme.of(context).colorScheme.error.withOpacity(0.80), margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),),

            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expenses[index]))));
  }
}
