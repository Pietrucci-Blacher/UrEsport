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

class CustomBottomNavigationState extends State<CustomBottomNavigation> with SingleTickerProviderStateMixin {
 late AnimationController _controller;

 @override
 void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
 }

 @override
 void dispose() {
    _controller.dispose();
    super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return BottomNavigationBar(
     items: <BottomNavigationBarItem>[  // Removed 'const' here
       const BottomNavigationBarItem(
         icon: Icon(Icons.home),
         label: 'Home',
       ),
       const BottomNavigationBarItem(
         icon: Icon(Icons.sports_esports),
         label: 'Tournaments',
       ),
       BottomNavigationBarItem(
         icon: AnimatedIcon(
           icon: AnimatedIcons.event_add,
           progress: _controller,
         ),
         label: 'Notifications',
       ),
       const BottomNavigationBarItem(
         icon: Icon(Icons.person),
         label: 'Profile',
       ),
     ],
     currentIndex: widget.selectedIndex,
     selectedItemColor: Colors.blue[800],
     unselectedItemColor: Colors.grey[600],
     showSelectedLabels: true,
     onTap: widget.onTap,
   );
 }

}
