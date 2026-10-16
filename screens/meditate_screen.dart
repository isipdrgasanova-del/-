import 'package:flutter/material.dart';

class MeditateScreen extends StatelessWidget {
  const MeditateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditate', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.person, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('Bible In a Year', true),
                _buildChip('Dailies', false),
                _buildChip('Minutes', false),
                _buildChip('Novena', false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network('https://picsum.photos/300/150?random=7', fit: BoxFit.contain),
                const SizedBox(height: 10),
                const Text('A Song of Moon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('Start with the basics', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('3 Sessions'),
                    Text('Start >'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildGridCard('The Sleep Hour', 'Ashria Mukherjee', Colors.orange)),
              const SizedBox(width: 15),
              Expanded(child: _buildGridCard('Easy on the Mission', 'Peter Mach', Colors.blue)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildGridCard('Relax with Me', 'Amanda James', Colors.blue)),
              const SizedBox(width: 15),
              Expanded(child: _buildGridCard('Sun and Energy', 'Michael Hill', Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
        backgroundColor: isSelected ? Colors.teal : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }

  Widget _buildGridCard(String title, String author, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
            child: Center(child: Icon(Icons.wb_sunny, color: color, size: 40)),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(author, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}