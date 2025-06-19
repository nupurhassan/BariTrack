import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FullGraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Progress Graph'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 64, color: AppTheme.primaryBlue),
            SizedBox(height: 16),
            Text(
              'Full Graph View',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Chart implementation with fl_chart or syncfusion',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}