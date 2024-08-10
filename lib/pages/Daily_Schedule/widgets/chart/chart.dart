import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/models/task.dart';
import 'package:smart_kids_v1/pages/Daily_Schedule/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.Quiz),
      ExpenseBucket.forCategory(expenses, Category.Assesment),
      ExpenseBucket.forCategory(expenses, Category.Drawing),
      ExpenseBucket.forCategory(expenses, Category.Lectures),
      ExpenseBucket.forCategory(expenses, Category.Others),
    ];
  }

  TimeOfDay get earliestTime {
    // Find the earliest time across all categories
    return buckets.map((b) => b.earliestTime).reduce((a, b) =>
        a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute) ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    // Display the proportion of earliest times (example logic)
                    fill: bucket.expenses.length / expenses.length,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
