import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
 final bool isLoggedIn;
 final int selectedIndex;
 final void Function(int index) onTap;

 const CustomBottomNavigation({
    super.key,
    required this.isLoggedIn,
    required this.selectedIndex,
    required this.onTap,
 });

 @override
 CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Adjust the height as needed
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildItem(Icons.home, 'Home', 0),
          _buildItem(Icons.sports_esports, 'Tournaments', 1),
          _buildItem(Icons.notifications, 'Notifications', 2),
          _buildItem(Icons.person, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: widget.selectedIndex == index ? Colors.blue[800] : Colors.grey[600],
          ),
          Text(
            label,
            style: TextStyle(
              color: widget.selectedIndex == index ? Colors.blue[800] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
