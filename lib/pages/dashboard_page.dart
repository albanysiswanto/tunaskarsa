import 'package:flutter/material.dart';
import 'package:tunaskarsa/service/auth_service.dart';
// import 'assignment_page.dart';
// import 'quiz_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi Albany",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Class XI-B | Roll no: 04",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          "2020-2021",
                          style: TextStyle(color: Colors.blue.shade800),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white70,
                        child: Icon(Icons.person, size: 28, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Attendance & Fees
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCard(
                    title: "80.39 %",
                    subtitle: "Attendance",
                    icon: Icons.school,
                    color: Colors.amber,
                  ),
                  _buildCard(
                    title: "64.58 %",
                    subtitle: "Progress",
                    icon: Icons.stacked_bar_chart,
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid Menu
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMenuItem(Icons.quiz, "Play Quiz", context, const Placeholder()),
                      _buildMenuItem(Icons.assignment, "Assignment", context, const Placeholder()),
                      _buildMenuItem(Icons.calendar_today, "Time Table", context, const Placeholder()),
                      _buildMenuItem(Icons.receipt, "Result", context, const Placeholder()),
                      _buildMenuItem(Icons.date_range, "Date Sheet", context, const Placeholder()),
                      _buildMenuItem(Icons.lock, "Change Password", context, const Placeholder()),
                      _buildMenuItem(Icons.event, "Events", context, const Placeholder()),
                      _logout(Icons.logout, "Logout", context,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context, Widget page) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blue.shade800),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _logout(IconData icon, String title, BuildContext context) {
    return ElevatedButton(
      onPressed: () async{
        await AuthService().signout(context: context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue.shade800),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}