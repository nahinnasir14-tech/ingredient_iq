import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0; // Starts on the brand new Home Dashboard now!
  List<String> activeUserProfileFlags = ['Diabetic', 'Weight Loss'];
  List<Map<String, dynamic>> _scanHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load user configurations and scan logs from internal device memory
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load profile flags
    final List<String>? savedFlags = prefs.getStringList('user_profile_flags');
    if (savedFlags != null) {
      setState(() {
        activeUserProfileFlags = savedFlags;
      });
    }

    // Load scan logs history
    final String? historyString = prefs.getString('scan_history_logs');
    if (historyString != null) {
      setState(() {
        _scanHistory = List<Map<String, dynamic>>.from(jsonDecode(historyString));
      });
    }
  }

  // Save updated history locally to the S23 Ultra storage block
  Future<void> _saveHistoryToDevice(List<Map<String, dynamic>> updatedHistory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scan_history_logs', jsonEncode(updatedHistory));
  }

  void _updateSharedProfile(List<String> updatedFlags) async {
    setState(() {
      activeUserProfileFlags = updatedFlags;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_profile_flags', updatedFlags);
  }

  // Callable callback function to log a newly analyzed scan result dynamically
  void _addScanToHistory(Map<String, dynamic> newScan) {
    setState(() {
      _scanHistory.insert(0, newScan); // Pushes recent items to the top
    });
    _saveHistoryToDevice(_scanHistory);
  }

  void _clearHistory() {
    setState(() {
      _scanHistory.clear();
    });
    _saveHistoryToDevice(_scanHistory);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      HomeScreen(
        userProfile: activeUserProfileFlags,
        scanHistory: _scanHistory,
        onNavigateToScan: () => setState(() => _currentIndex = 1),
      ),
      ScannerScreen(
        userProfile: activeUserProfileFlags,
        onScanCompleted: _addScanToHistory,
      ),
      HistoryScreen(
        scanHistory: _scanHistory,
        onClearHistory: _clearHistory,
      ),
      ProfileScreen(
        initialProfile: activeUserProfileFlags,
        onProfileSaved: (newProfile) {
          _updateSharedProfile(newProfile);
          setState(() => _currentIndex = 0); // Jump back to home dashboard
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0F6E56),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_enhance_rounded), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history_toggle_off_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}