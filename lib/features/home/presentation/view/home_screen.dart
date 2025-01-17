import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gym Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Deep Purple Theme Color
      ),
      body: _buildPageContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // Deep Purple for selected item
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildClassesPage();
      case 2:
        return _buildAttendancePage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🏋️ Welcome to Your Gym!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Membership Card
          Card(
            color: Colors.deepPurple, // Deep Purple Membership Card
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("💳 Active Membership",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8),
                  Text("Gold Plan - Expires: 15th March 2025",
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Gym Highlights
          const Text("🔥 Today's Highlights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHighlightCard("💪 Workouts Done", "3/5 Days"),
              _buildHighlightCard("📅 Next Class", "Yoga - 6 PM"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(String title, String subtitle) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildClassesPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("📅 Upcoming Gym Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildClassItem("🔥 HIIT Workout", "Tomorrow, 7 AM"),
        _buildClassItem("🧘 Yoga Session", "Friday, 6 PM"),
        _buildClassItem("🏋️ Strength Training", "Sunday, 8 AM"),
      ],
    );
  }

  Widget _buildClassItem(String className, String schedule) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.deepPurple),
        title: Text(className,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(schedule),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Deep Purple Button
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Join", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildAttendancePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("✅ Attendance Tracker",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Workouts Completed: 3/5 this week",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text("Mark Attendance",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("👤 Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Name: John Doe", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          const Text("Email: johndoe@gmail.com",
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          const Text("Membership: Gold Plan",
              style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text("Update Profile",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
