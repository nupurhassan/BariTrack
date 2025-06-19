import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  UserProfile _userProfile = UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildPageIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _SurgeryDatePage(
                    userProfile: _userProfile,
                    onNext: () => _nextPage(),
                  ),
                  _PersonalInfoPage(
                    userProfile: _userProfile,
                    onNext: () => _nextPage(),
                  ),
                  _SurgeryTypePage(
                    userProfile: _userProfile,
                    onNext: () => _nextPage(),
                  ),
                  _ResultPage(
                    userProfile: _userProfile,
                    onComplete: () => _completeOnboarding(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: index == _currentPage ? 24 : 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index == _currentPage ? AppTheme.primaryBlue : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    await prefs.setString('userProfile', jsonEncode(_userProfile.toJson()));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}

// Surgery Date Page
class _SurgeryDatePage extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onNext;

  _SurgeryDatePage({required this.userProfile, required this.onNext});

  @override
  __SurgeryDatePageState createState() => __SurgeryDatePageState();
}

class __SurgeryDatePageState extends State<_SurgeryDatePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When was your surgery?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  widget.userProfile.surgeryDate = picked;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.goldenYellow),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.userProfile.surgeryDate != null
                        ? '${widget.userProfile.surgeryDate!.day}/${widget.userProfile.surgeryDate!.month}/${widget.userProfile.surgeryDate!.year}'
                        : 'Select Date',
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.userProfile.surgeryDate != null ? widget.onNext : null,
            child: Text('Next', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// Personal Info Page
class _PersonalInfoPage extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onNext;

  _PersonalInfoPage({required this.userProfile, required this.onNext});

  @override
  __PersonalInfoPageState createState() => __PersonalInfoPageState();
}

class __PersonalInfoPageState extends State<_PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about yourself',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          DropdownButtonFormField<String>(
            value: widget.userProfile.sex,
            decoration: InputDecoration(labelText: 'Sex'),
            items: ['Male', 'Female', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                widget.userProfile.sex = value;
              });
            },
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Age'),
            onChanged: (value) {
              widget.userProfile.age = int.tryParse(value);
            },
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Weight (lbs)'),
            onChanged: (value) {
              widget.userProfile.weight = double.tryParse(value);
              widget.userProfile.startingWeight = widget.userProfile.weight;
            },
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Height (cm)'),
            onChanged: (value) {
              widget.userProfile.height = double.tryParse(value);
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.userProfile.race,
            decoration: InputDecoration(labelText: 'Race'),
            items: ['Asian', 'Black', 'Hispanic', 'White', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                widget.userProfile.race = value;
              });
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.onNext,
            child: Text('Next', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// Surgery Type Page
class _SurgeryTypePage extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onNext;

  _SurgeryTypePage({required this.userProfile, required this.onNext});

  @override
  __SurgeryTypePageState createState() => __SurgeryTypePageState();
}

class __SurgeryTypePageState extends State<_SurgeryTypePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of surgery did you have?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          DropdownButtonFormField<String>(
            value: widget.userProfile.surgeryType,
            decoration: InputDecoration(labelText: 'Surgery Type'),
            items: ['Gastric Sleeve', 'Gastric Bypass', 'Duodenal Switch'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                widget.userProfile.surgeryType = value;
              });
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.userProfile.surgeryType != null ? widget.onNext : null,
            child: Text('Next', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// Result Page
class _ResultPage extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback onComplete;

  _ResultPage({required this.userProfile, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Journey Begins!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.goldenYellow),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your BMI: ${userProfile.bmi.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Text('Expected Weight Loss Timeline:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Month 1: ${userProfile.getExpectedWeight(4).toStringAsFixed(1)} lbs'),
                Text('Month 3: ${userProfile.getExpectedWeight(12).toStringAsFixed(1)} lbs'),
                Text('Month 6: ${userProfile.getExpectedWeight(24).toStringAsFixed(1)} lbs'),
              ],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: onComplete,
            child: Text('Get Started', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}