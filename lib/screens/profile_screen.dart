// Feature Module: User Health Profile Management Panel
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final List<String> initialProfile;
  final Function(List<String>) onProfileSaved;

  const ProfileScreen({super.key, required this.initialProfile, required this.onProfileSaved});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String specificAllergies = "";
  final TextEditingController _allergyController = TextEditingController();

  late List<Map<String, dynamic>> healthConditions;
  late List<Map<String, dynamic>> fitnessGoals;

  @override
  void initState() {
    super.initState();
    
    // Process input states down into layout flags sequentially
    healthConditions = [
      {'label': 'Diabetic', 'urdu': 'ذیابیطس', 'icon': '🩸', 'sub': 'Avoid high sugar ingredients', 'selected': widget.initialProfile.contains('Diabetic')},
      {'label': 'Heart Patient', 'urdu': 'دل کا مریض', 'icon': '❤️', 'sub': 'Avoid high sodium & fats', 'selected': widget.initialProfile.contains('Heart Patient')},
      {'label': 'Pregnant', 'urdu': 'حاملہ', 'icon': '🤱', 'sub': 'Avoid harmful additives', 'selected': widget.initialProfile.contains('Pregnant')},
      {'label': 'Allergic', 'urdu': 'الرجی', 'icon': '⚠️', 'sub': 'Nuts, gluten, dairy & more', 'selected': widget.initialProfile.any((element) => element.contains('Allergic'))},
    ];

    // Read allergy parameters if they exist
   final allergyMatch = widget.initialProfile.firstWhere((e) => e.contains('Allergic to'), orElse: () => '');
    if (allergyMatch.isNotEmpty) {
      specificAllergies = allergyMatch.replaceAll('Allergic to (', '').replaceAll(')', '');
      _allergyController.text = specificAllergies;
    }

    fitnessGoals = [
      {'label': 'Weight Loss', 'urdu': 'وزن کم کرنا', 'icon': '⚖️', 'sub': 'Low calorie, low fat', 'selected': widget.initialProfile.contains('Weight Loss')},
      {'label': 'Muscle Gain', 'urdu': 'مسلز بنانا', 'icon': '💪', 'sub': 'High protein focus', 'selected': widget.initialProfile.contains('Muscle Gain')},
      {'label': 'Keto Diet', 'urdu': 'کیٹو ڈائیٹ', 'icon': '🥑', 'sub': 'High fat, ultra low carb', 'selected': widget.initialProfile.contains('Keto Diet')},
      {'label': 'Clean Eating', 'urdu': 'صحت مند کھانا', 'icon': '🥗', 'sub': 'Avoid artificial preservatives', 'selected': widget.initialProfile.contains('Clean Eating')},
    ];
  }

  void _showAllergyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Specify Allergies (الرجی)'),
          content: TextField(
            controller: _allergyController,
            decoration: const InputDecoration(hintText: 'e.g., Peanuts, Gluten, Dairy'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => healthConditions[3]['selected'] = false);
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => specificAllergies = _allergyController.text.trim());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6E56)),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processAndSave() {
    List<String> outputProfile = [];
    for (var item in healthConditions) {
      if (item['selected']) {
        if (item['label'] == 'Allergic' && specificAllergies.isNotEmpty) {
          outputProfile.add('Allergic to ($specificAllergies)');
        } else {
          outputProfile.add(item['label']);
        }
      }
    }
    for (var item in fitnessGoals) {
      if (item['selected']) outputProfile.add(item['label']);
    }
    widget.onProfileSaved(outputProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Your Health Profile', style: TextStyle(fontWeight: FontWeight.w600)), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HEALTH CONDITIONS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...healthConditions.asMap().entries.map((entry) {
              int i = entry.key;
              var item = entry.value;
              return Card(
                color: item['selected'] ? const Color(0xFFE1F5EE) : const Color(0xFFF8F9FA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: item['selected'] ? const Color(0xFF0F6E56) : Colors.transparent, width: 1),
                ),
                child: ListTile(
                  leading: Text(item['icon'], style: const TextStyle(fontSize: 24)),
                  title: Text(item['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item['sub']} • ${item['urdu']}', style: const TextStyle(fontSize: 12)),
                  trailing: item['selected'] ? const Icon(Icons.check_circle, color: Color(0xFF0F6E56)) : const Icon(Icons.circle_outlined),
                  onTap: () {
                    setState(() => healthConditions[i]['selected'] = !item['selected']);
                    if (item['label'] == 'Allergic' && healthConditions[i]['selected']) _showAllergyDialog();
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text('FITNESS GOALS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...fitnessGoals.asMap().entries.map((entry) {
              int i = entry.key;
              var item = entry.value;
              return Card(
                color: item['selected'] ? const Color(0xFFE1F5EE) : const Color(0xFFF8F9FA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: item['selected'] ? const Color(0xFF0F6E56) : Colors.transparent, width: 1),
                ),
                child: ListTile(
                  leading: Text(item['icon'], style: const TextStyle(fontSize: 24)),
                  title: Text(item['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['sub'], style: const TextStyle(fontSize: 12)),
                  trailing: item['selected'] ? const Icon(Icons.check_circle, color: Color(0xFF0F6E56)) : const Icon(Icons.circle_outlined),
                  onTap: () => setState(() => fitnessGoals[i]['selected'] = !item['selected']),
                ),
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _processAndSave,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6E56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Save Profile & Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}