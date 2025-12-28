import 'package:flutter/material.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  int selectedIndex = 0;
  final Color orange = const Color(0xFFD3542C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Saved',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        actionsPadding: const EdgeInsets.only(left: 26, right: 26, bottom: 10),
        actions: const [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/miae.jpg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          const SizedBox(height: 31),

          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  _filterButton("Events", 0),
                  const SizedBox(width: 8),
                  _filterButton("Figures", 1),
                  const SizedBox(width: 8),
                  _filterButton("Region", 2),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: [
                Text(
                  'Recent Saves ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

      SizedBox(
        height: 260,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 26),
          children: [
            SizedBox(width: 290, child: _savedCard()),
            const SizedBox(width: 16),
            SizedBox(width: 290, child: _savedCard()),
            const SizedBox(width: 16),
            SizedBox(width: 290, child: _savedCard()),
          ],
        ),
      ),
          const SizedBox(height: 24),


          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: [
                Text(
                  'In 1945 ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 26),
              children: [
                SizedBox(width: 300, child: _savedCard()),
                const SizedBox(width: 16),
                SizedBox(width: 300, child: _savedCard()),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _savedCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/WWII.png',
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'End of WWII',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '1945',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Discover',
                        style: TextStyle(color: Colors.white,
                        fontSize: 16.0,),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.bookmark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String text, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        width: 105,
        height: 34,
        decoration: BoxDecoration(
          color: isSelected ? orange.withOpacity(0.1) : orange,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: orange, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? orange : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
