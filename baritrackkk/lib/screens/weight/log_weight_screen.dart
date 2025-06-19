import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/weight_entry.dart';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';

class LogWeightScreen extends StatefulWidget {
  @override
  _LogWeightScreenState createState() => _LogWeightScreenState();
}

class _LogWeightScreenState extends State<LogWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Weight'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Your Weight',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              InkWell(
                onTap: _selectDate,
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
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (lbs)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _saveWeight,
                      icon: Icon(Icons.save),
                      label: Text('Save Weight'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveWeight() async {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final entry = WeightEntry(
        date: _selectedDate,
        weight: weight,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Save weight entry
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> entries = prefs.getStringList('weightEntries') ?? [];
      entries.add(jsonEncode(entry.toJson()));
      await prefs.setStringList('weightEntries', entries);

      // Update user profile with new weight
      String? userProfileJson = prefs.getString('userProfile');
      if (userProfileJson != null) {
        UserProfile userProfile = UserProfile.fromJson(jsonDecode(userProfileJson));
        userProfile.weight = weight;
        await prefs.setString('userProfile', jsonEncode(userProfile.toJson()));
      }

      // Update entries count
      int entriesCount = prefs.getInt('entriesCount') ?? 0;
      await prefs.setInt('entriesCount', entriesCount + 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Weight saved successfully!')),
      );

      Navigator.pop(context, true);
    }
  }
}