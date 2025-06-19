import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surgery Timeline'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: AppTheme.primaryBlue),
            SizedBox(height: 16),
            Text(
              'Surgery Timeline',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your weight loss journey milestones',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}