// widgets/routine_card.dart
import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  final String title;
  final List<String> steps;
  final Map<String, bool> completedSteps;
  final Function(String, String) onToggleStep;
  final IconData icon;

  const RoutineCard({
    super.key,
    required this.title,
    required this.steps,
    required this.completedSteps,
    required this.onToggleStep,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.pink),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(),
            ...steps.map((step) {
              final isCompleted = completedSteps['$title-$step'] ?? false;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  step,
                  style: TextStyle(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (bool? value) => onToggleStep(title, step),
                  activeColor: Colors.pink,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
