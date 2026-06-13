import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 65, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Zeeshan Ahmad',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    'BS Computer Science | AI & ML Enthusiast',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _sectionTitle('About Me'),
            _infoCard(
              'Motivated BS Computer Science student with a strong foundation in programming, software development, and problem-solving. Seeking to apply scalable AI system design in real-world applications.',
            ),
            const SizedBox(height: 20),
            _sectionTitle('Education'),
            _infoCard(
              '🎓 BS Computer Science (2023 – 2027)\nAbdul Wali Khan University Mardan\nCGPA: 3.25 / 4.0\n\n📘 FSc Pre-Engineering (2023) — A1 (932)\nEdwardes College Peshawar\n\n📗 Matriculation (2021) — A1 (1068)\nAl-Karim Public High School, Charsadda',
            ),
            const SizedBox(height: 20),
            _sectionTitle('Tech Skills'),
            _skillChips(),
            const SizedBox(height: 20),
            _sectionTitle('Certifications'),
            _infoCard('🏆 ML & DeepLearning.AI — KP IT Board 2026'),
            const SizedBox(height: 20),
            _sectionTitle('Career Goal'),
            _infoCard(
              'To become a professional AI & Mobile App developer and build impactful applications that solve real-world problems.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _infoCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _skillChips() {
    final skills = [
      'C++',
      'Java',
      'Python',
      'HTML',
      'CSS',
      'Flutter',
      'Dart',
      'MySQL',
      'MongoDB',
      'Git',
      'GitHub',
      'CNNs',
      'NLP',
      'RAG',
      'Agentic AI',
      'YOLO',
      'Gen AI',
      'VS Code',
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.map((skill) {
        return Chip(
          label: Text(skill, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
        );
      }).toList(),
    );
  }
}
