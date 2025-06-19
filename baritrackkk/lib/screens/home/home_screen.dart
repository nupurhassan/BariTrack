import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';
import '../../widgets/drawer_menu.dart';
import '../../widgets/weight_progress_card.dart';
import '../../widgets/graph_preview_card.dart';
import '../../widgets/alert_banner.dart';
import '../profile/profile_screen.dart';
import '../weight/log_weight_screen.dart';
import '../graph/full_graph_screen.dart';
import '../timeline/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProfile? _userProfile;
  bool _isOffTrack = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfileJson = prefs.getString('userProfile');
    if (userProfileJson != null) {
      setState(() {
        _userProfile = UserProfile.fromJson(jsonDecode(userProfileJson));
        _checkIfOffTrack();
      });
    }
  }

  void _checkIfOffTrack() {
    if (_userProfile != null) {
      double expectedWeight = _userProfile!.getExpectedWeight(_userProfile!.weeksPostOp);
      double currentWeight = _userProfile!.weight ?? _userProfile!.startingWeight ?? 0;
      double expectedLoss = (_userProfile!.startingWeight ?? 0) - expectedWeight;
      double actualLoss = (_userProfile!.startingWeight ?? 0) - currentWeight;

      _isOffTrack = actualLoss < (expectedLoss * 0.85); // 15% behind
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: DrawerMenu(userProfile: _userProfile),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    if (_userProfile == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${_userProfile!.name ?? "Friend"}!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_userProfile!.weeksPostOp} weeks post-op',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 24),
          WeightProgressCard(userProfile: _userProfile!),
          SizedBox(height: 24),
          GraphPreviewCard(userProfile: _userProfile!),
          SizedBox(height: 24),
          _buildLogWeightButton(),
          if (_isOffTrack) ...[
            SizedBox(height: 24),
            AlertBanner(),
          ],
        ],
      ),
    );
  }

  Widget _buildLogWeightButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogWeightScreen()),
          );
        },
        icon: Icon(Icons.add),
        label: Text(
          "Log This Week's Weight",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: AppTheme.primaryBlue,
      unselectedItemColor: Colors.grey,
      backgroundColor: AppTheme.cardBackground,
      type: BottomNavigationBarType.fixed,
      onTap: _onNavigationItemTapped,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Chart'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
    );
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullGraphScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimelineScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }
}