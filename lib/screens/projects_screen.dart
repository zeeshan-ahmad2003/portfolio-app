import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  final List<Map<String, String>> projects = const [
    {
      'title': 'YouTube Video Summarizer',
      'description':
          'RAG-based web app that fetches YouTube transcripts and generates clean summaries via Groq\'s LLaMA model. Final project for KP IT Board ML & DeepLearning.AI course.',
      'technologies': 'Python · Flask · RAG · Groq · LLaMA',
    },
    {
      'title': 'PDF Compressor',
      'description':
          'Live Streamlit app compressing PDFs by 60–70% using Ghostscript. Supports files up to 200 MB across four quality presets. Built and deployed in 2 days.',
      'technologies': 'Python · Streamlit · Ghostscript · PyMuPDF',
    },
    {
      'title': 'Portfolio Mobile App',
      'description':
          'A personal portfolio mobile app built with Flutter during Codiora Software House internship. Features login, profile, projects and contact screens.',
      'technologies': 'Flutter · Dart',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'My Projects',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: projects.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final project = projects[index];
            return Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.folder, color: Colors.teal, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          project['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project['description']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.code, color: Colors.grey, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          project['technologies']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
