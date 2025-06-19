import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/graph/full_graph_screen.dart';
import '../screens/weight/log_weight_screen.dart';
import '../screens/timeline/timeline_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/about/about_screen.dart';

class DrawerMenu extends StatelessWidget {
  final UserProfile? userProfile;

  DrawerMenu({this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppTheme.cardBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      _getInitials(),
                      style: TextStyle(color: AppTheme.primaryBlue, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userProfile?.name ?? 'User',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    userProfile?.email ?? 'user@email.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              Icons.person,
              'Profile',
                  () => _navigateTo(context, ProfileScreen()),
            ),
            _buildDrawerItem(
              Icons.show_chart,
              'Full Graph',
                  () => _navigateTo(context, FullGraphScreen()),
            ),
            _buildDrawerItem(
              Icons.add_box,
              'Log Weight',
                  () => _navigateTo(context, LogWeightScreen()),
            ),
            _buildDrawerItem(
              Icons.timeline,
              'Surgery Timeline',
                  () => _navigateTo(context, TimelineScreen()),
            ),
            _buildDrawerItem(
              Icons.settings,
              'Settings',
                  () => _navigateTo(context, SettingsScreen()),
            ),
            _buildDrawerItem(
              Icons.info,
              'About',
                  () => _navigateTo(context, AboutScreen()),
            ),
            _buildDrawerItem(
              Icons.restart_alt,
              'Reset App',
                  () => _showResetDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    if (userProfile?.name == null || userProfile!.name!.isEmpty) {
      return 'U';
    }
    List<String> names = userProfile!.name!.split(' ');
    String initials = names[0][0].toUpperCase();
    if (names.length > 1) {
      initials += names[names.length - 1][0].toUpperCase();
    }
    return initials;
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset App'),
          content: Text('Are you sure you want to reset the app? This will delete all your data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Clear all data
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigate to splash screen
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}