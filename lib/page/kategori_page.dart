import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          _buildCategoryCard(
            icon: Icons.public,
            title: 'Global News',
            gradientColors: [Colors.blueAccent, Colors.lightBlue],
          ),
          _buildCategoryCard(
            icon: Icons.sports_soccer,
            title: 'Sports',
            gradientColors: [Colors.green, Colors.lightGreen],
          ),
          _buildCategoryCard(
            icon: Icons.business,
            title: 'Business',
            gradientColors: [Colors.orange, Colors.deepOrange],
          ),
          _buildCategoryCard(
            icon: Icons.science,
            title: 'Science',
            gradientColors: [Colors.purple, Colors.deepPurple],
          ),
          _buildCategoryCard(
            icon: Icons.health_and_safety,
            title: 'Health',
            gradientColors: [Colors.redAccent, Colors.red],
          ),
          _buildCategoryCard(
            icon: Icons.movie,
            title: 'Entertainment',
            gradientColors: [Colors.indigo, Colors.blue],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
  }) =>
      Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigasi kategori tertentu
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.last.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
