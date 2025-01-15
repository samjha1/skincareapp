import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skincase/camara.dart';

class SkincareTracker extends StatefulWidget {
  const SkincareTracker({super.key});

  @override
  _SkincareTrackerState createState() => _SkincareTrackerState();
}

class _SkincareTrackerState extends State<SkincareTracker> {
  int _selectedIndex = 0;

  final List<Map<String, String>> routineItems = [
    {
      'name': 'Cleanser',
      'product': 'Cetaphil Gentle Skin Cleanser',
      'time': '8:00 PM',
      'description': 'Gentle formula for all skin types.',
      'image': 'assets/images/c.jpg', // Placeholder for the image
    },
    {
      'name': 'Toner',
      'product': 'Thayers Witch Hazel Toner',
      'time': '8:05 PM',
      'description': 'Helps balance skin’s pH.',
      'image': 'assets/images/t.jpg',
    },
    {
      'name': 'Moisturizer',
      'product': 'Kiehl\'s Ultra Facial Cream',
      'time': '8:04 PM',
      'description': 'Deep hydration for all-day moisture.',
      'image': 'assets/images/m.jpg',
    },
    {
      'name': 'Sunscreen',
      'product': 'Supergoop Unseen Sunscreen',
      'time': '8:06 PM',
      'description': 'Broad-spectrum SPF 40 protection.',
      'image': 'assets/images/s.jpg',
    },
    {
      'name': 'Lip Balm',
      'product': 'Glossier Birthday Balm Dotcom',
      'time': '8:08 PM',
      'description': 'Hydrates and nourishes lips.',
      'image': 'assets/images/lipbalm.png',
    },
  ];

  Widget _buildRoutineView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Skincare Routine',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routineItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineDetailPage(
                        routineItem: routineItems[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipOval(
                      child: Image.asset(
                        routineItems[index]['image']!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      routineItems[index]['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      routineItems[index]['product']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          routineItems[index]['time']!,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• ${routineItems[index]['description']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.pink[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStreaksView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 6, // Add shadow for better depth
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.pink[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Goal: 3 Streak Days',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.pink[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                  Text(
                    'Streak Days',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Daily Streak',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '2',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                  Text(
                    'Last 30 Days • 100%',
                    style: TextStyle(
                      color: Colors.pink[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height:
                        120, // Increased height for better chart visualization
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(1, 4),
                              FlSpot(2, 3.5),
                              FlSpot(3, 5),
                              FlSpot(4, 3),
                              FlSpot(5, 4),
                            ],
                            isCurved: true,
                            color: Colors.pink[600]!,
                            barWidth: 4, // Increased bar width for visibility
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[200],
              foregroundColor: Colors.pink[700],
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4, // Added slight elevation for the button
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildRoutineView(),
          _buildStreaksView(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // Adds a notch for the FAB
        notchMargin: 10, // Space around the FAB notch
        child: Container(
          height: 50, // Increased height for better visuals
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Better spacing
            children: [
              // Search Icon
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 0 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              // Add Spacer for the FAB
              const Spacer(),
              // People Icon
              IconButton(
                icon: Icon(
                  Icons.people,
                  color: _selectedIndex == 1 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => YourWidget()),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// Routine Detail Page
class RoutineDetailPage extends StatelessWidget {
  final Map<String, String> routineItem;

  const RoutineDetailPage({super.key, required this.routineItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routineItem['name']!),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(routineItem['image']!, width: 300, height: 300),
            const SizedBox(height: 20),
            Text(
              routineItem['product']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              routineItem['description']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add to your routine logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                foregroundColor: Colors.pink[700],
              ),
              child: const Text('Add to Routine'),
            ),
          ],
        ),
      ),
    );
  }
}
