import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Added more elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: color.withOpacity(0.2), // Custom shadow color
      child: Padding(
        padding:
            const EdgeInsets.all(20.0), // Increased padding for spacious design
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make icon inside a circle
                color: color
                    .withOpacity(0.1), // Light background color for the icon
              ),
              padding: const EdgeInsets.all(16), // Add space around the icon
              child: Icon(
                icon,
                color: color,
                size: 36, // Larger icon for better visibility
              ),
            ),
            SizedBox(height: 12), // Increased spacing
            Text(
              value,
              style: TextStyle(
                fontSize: 28, // Larger font size
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.2, // Slight letter-spacing for a modern look
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16, // Slightly larger subtitle font size
                fontWeight: FontWeight.w500, // Subtle weight for the title
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
