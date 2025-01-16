import 'package:flutter/material.dart';
import 'package:skincares/camara.dart';
import 'package:skincares/streak.dart';

// Main App Widget
class SkincareTracker extends StatefulWidget {
  const SkincareTracker({super.key});

  @override
  _SkincareTrackerState createState() => _SkincareTrackerState();
}

class _SkincareTrackerState extends State<SkincareTracker> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  bool _isSearchOpen = false;
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> routineItems = [
    {
      'name': 'Cleanser',
      'product': 'Cetaphil Gentle Skin Cleanser',
      'time': '8:00 PM',
      'description': 'Gentle formula for all skin types.',
      'image': 'assets/images/c.jpg',
      'isCompleted': false,
      'usage': 'Apply to damp face, massage gently, rinse thoroughly.',
      'frequency': 'Twice daily',
      'ingredients': [
        'Water',
        'Cetyl Alcohol',
        'Propylene Glycol',
        'Sodium Lauryl Sulfate'
      ],
    },
    {
      'name': 'Toner',
      'product': 'Thayers Witch Hazel Toner',
      'time': '8:05 PM',
      'description': 'Helps balance skin',
      'image': 'assets/images/t.jpg',
      'isCompleted': false,
      'usage': 'Apply with cotton pad after cleansing.',
      'frequency': 'Twice daily',
      'ingredients': ['Witch Hazel', 'Aloe Vera', 'Glycerin'],
    },
    {
      'name': 'Moisturizer',
      'product': 'Kiehl\'s Ultra Facial Cream',
      'time': '8:10 PM',
      'description': 'Deep hydration for all-day moisture.',
      'image': 'assets/images/m.jpg',
      'isCompleted': false,
      'usage': 'Apply a small amount to face and neck.',
      'frequency': 'Twice daily',
      'ingredients': ['Water', 'Glycerin', 'Squalane', 'Shea Butter'],
    },
    {
      'name': 'Sunscreen',
      'product': 'Supergoop Unseen Sunscreen',
      'time': '8:15 PM',
      'description': 'Broad-spectrum SPF 40 protection.',
      'image': 'assets/images/s.jpg',
      'isCompleted': false,
      'usage': 'Apply generously 15 minutes before sun exposure.',
      'frequency': 'Daily morning and reapply every 2 hours',
      'ingredients': ['Avobenzone', 'Homosalate', 'Octisalate'],
    },
    {
      'name': 'Lip Balm',
      'product': 'Burt\'s Bees Lip Balm',
      'time': '8:20 PM',
      'description': 'Hydrating balm to keep lips smooth and moisturized.',
      'image': 'assets/images/lipbalm.jpg',
      'isCompleted': false,
      'usage': 'Apply evenly to lips as needed throughout the day.',
      'frequency': 'As needed daily',
      'ingredients': [
        'Beeswax',
        'Coconut Oil',
        'Shea Butter',
        'Peppermint Oil'
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredRoutineItems {
    if (!_isSearchOpen || _searchController.text.isEmpty) {
      return routineItems;
    }
    return routineItems.where((item) {
      final searchTerm = _searchController.text.toLowerCase();
      return item['name'].toLowerCase().contains(searchTerm) ||
          item['product'].toLowerCase().contains(searchTerm) ||
          item['description'].toLowerCase().contains(searchTerm);
    }).toList();
  }

  ThemeData _getTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.pink[400],
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.pink[50],
        foregroundColor: _isDarkMode ? Colors.white : Colors.pink[700],
      ),
    );
  }

  Widget _buildRoutineView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: _isSearchOpen ? 0 : 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: _isSearchOpen
              ? null
              : FlexibleSpaceBar(
                  title: Text(
                    'Daily Skincare Routine',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.pink[700],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _isDarkMode ? Colors.grey[800]! : Colors.pink[100]!,
                          _isDarkMode ? Colors.grey[900]! : Colors.pink[50]!,
                        ],
                      ),
                    ),
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(_isSearchOpen ? Icons.close : Icons.search),
              onPressed: () => setState(() => _isSearchOpen = !_isSearchOpen),
            ),
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
          bottom: _isSearchOpen
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        filled: true,
                        fillColor:
                            _isDarkMode ? Colors.grey[800] : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                )
              : null,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildRoutineCard(filteredRoutineItems[index]),
              childCount: filteredRoutineItems.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> item) {
    final completedItems =
        routineItems.where((item) => item['isCompleted']).length;
    final progress = completedItems / routineItems.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showRoutineDetail(item),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    item['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (item['isCompleted'])
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Completed',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: item['isCompleted'],
                          onChanged: (bool? value) {
                            setState(() => item['isCompleted'] = value);
                          },
                          activeColor: Colors.pink[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['product'],
                    style: TextStyle(
                      fontSize: 16,
                      color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color:
                            _isDarkMode ? Colors.grey[400] : Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['time'],
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              _isDarkMode ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          _isDarkMode ? Colors.grey[700] : Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pink[400]!),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoutineDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        item['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['product'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item['isCompleted'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Completed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailSection(
                      'Description',
                      item['description'],
                      Icons.info_outline,
                    ),
                    _buildDetailSection(
                      'Usage Instructions',
                      item['usage'],
                      Icons.help_outline,
                    ),
                    _buildDetailSection(
                      'Frequency',
                      item['frequency'],
                      Icons.repeat,
                    ),
                    _buildDetailSection(
                      'Ingredients',
                      '• ${(item['ingredients'] as List).join('\n• ')}',
                      Icons.science_outlined,
                    ),
                    const SizedBox(height: 20),
                    if (!item['isCompleted'])
                      ElevatedButton(
                        onPressed: () {
                          setState(() => item['isCompleted'] = true);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Mark as Complete'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: _isDarkMode ? Colors.pink[300] : Colors.pink[400]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Skincare Tracker'),
        ),
        body: _selectedIndex == 0
            ? _buildRoutineView()
            : Center(
                child: Text(
                  'This is Page ${_selectedIndex + 1}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const YourWidget()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StreaksPage()),
              );
            } else {
              setState(() => _selectedIndex = index);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Streaks',
            ),
          ],
        ),
      ),
    );
  }
}
