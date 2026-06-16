import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class Project {
  final String title;
  final String description;
  final String tech;
  final String githubUrl;
  final String liveUrl;
  final String fullDescription;
  final IconData icon;
  final List<Color> colors;

  Project({
    required this.title,
    required this.description,
    required this.tech,
    required this.githubUrl,
    required this.liveUrl,
    required this.fullDescription,
    required this.icon,
    required this.colors,
  });
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final projects = [
      Project(
        title: 'YouTube Summarizer',
        description: 'AI-powered video summarizer with RAG architecture.',
        tech: 'Python · LangChain · Streamlit',
        githubUrl: 'https://github.com/zeeshan-ahmad2003/youtube-summarizer',
        liveUrl: 'https://youtube-summarizer-24gt.onrender.com',
        fullDescription:
            'A RAG-based tool that takes a YouTube video URL, extracts the transcript, '
            'and generates a smart summary using a language model. Built with Python, '
            'LangChain, and deployed live on Render.',
        icon: Icons.play_circle_rounded,
        colors: [const Color(0xFFE53935), const Color(0xFFFF6F60)],
      ),
      Project(
        title: 'PDF Compressor',
        description: 'Compress PDF files via web or desktop app.',
        tech: 'Python · Flask · Streamlit · Tkinter',
        githubUrl: 'https://github.com/zeeshan-ahmad2003',
        liveUrl: 'https://zeeshans-pdf-tool.streamlit.app',
        fullDescription:
            'Built in three versions: a Flask web app on Render, a Streamlit app on '
            'Streamlit Cloud, and an offline Tkinter desktop app.',
        icon: Icons.picture_as_pdf_rounded,
        colors: [const Color(0xFFF97316), const Color(0xFFFFB347)],
      ),
      Project(
        title: 'Portfolio App',
        description: 'This Flutter mobile portfolio app.',
        tech: 'Flutter · Dart',
        githubUrl: 'https://github.com/zeeshan-ahmad2003/portfolio-app',
        liveUrl: 'https://github.com/zeeshan-ahmad2003/portfolio-app',
        fullDescription:
            'A professional mobile portfolio app built with Flutter during the '
            'Codiora Software House internship. Features bottom navigation, '
            'project details, skills with progress bars, and dark mode.',
        icon: Icons.phone_android_rounded,
        colors: [AppColors.cyan, AppColors.purple],
      ),
      Project(
        title: 'AI Doctor Assistant',
        description: 'Multi-agent AI system for medical queries.',
        tech: 'Python · Groq API · LangGraph',
        githubUrl: 'https://github.com/zeeshan-ahmad2003',
        liveUrl: 'https://github.com/zeeshan-ahmad2003',
        fullDescription:
            'A three-agent system built with Python and Groq API. Agents handle '
            'diagnosis suggestions, prescription advice, and follow-up questions. '
            'Built as a KPITB course final project.',
        icon: Icons.medical_services_rounded,
        colors: [AppColors.purple, AppColors.cyan],
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F4FF),
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.cyan, AppColors.purple],
          ).createShader(bounds),
          child: const Text(
            'My Projects',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return _ProjectCard(project: projects[index], isDark: isDark);
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final bool isDark;

  const _ProjectCard({required this.project, required this.isDark});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(project: project, isDark: isDark),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: project.colors.first.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: project.colors.first.withOpacity(isDark ? 0.15 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: project.colors
                      .map((c) => c.withOpacity(isDark ? 0.25 : 0.15))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: project.colors.first.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: project.colors),
                        boxShadow: [
                          BoxShadow(
                            color: project.colors.first.withOpacity(0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(project.icon, size: 32, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textWhite : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textGrey : Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: project.colors
                            .map((c) => c.withOpacity(0.12))
                            .toList(),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: project.colors.first.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      project.tech,
                      style: TextStyle(
                        fontSize: 11,
                        color: project.colors.first,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchURL(project.githubUrl),
                          icon: const Icon(Icons.code_rounded, size: 16),
                          label: const Text('GitHub'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: project.colors.first,
                            side: BorderSide(
                              color: project.colors.first.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: project.colors),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: project.colors.first.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(project.liveUrl),
                            icon: const Icon(
                              Icons.launch_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Live Demo',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  final bool isDark;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.isDark,
  });

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F4FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          project.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textWhite : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: project.colors
                      .map((c) => c.withOpacity(isDark ? 0.25 : 0.15))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: project.colors.first.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: project.colors),
                    boxShadow: [
                      BoxShadow(
                        color: project.colors.first.withOpacity(0.5),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Icon(project.icon, size: 52, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              project.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textWhite : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: project.colors
                      .map((c) => c.withOpacity(0.12))
                      .toList(),
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: project.colors.first.withOpacity(0.3),
                ),
              ),
              child: Text(
                project.tech,
                style: TextStyle(
                  color: project.colors.first,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About this Project',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.fullDescription,
              style: TextStyle(
                fontSize: 14,
                height: 1.8,
                color: isDark ? AppColors.textGrey : Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(project.githubUrl),
                icon: const Icon(Icons.code_rounded, color: AppColors.cyan),
                label: const Text(
                  'View on GitHub',
                  style: TextStyle(color: AppColors.cyan),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: project.colors),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: project.colors.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(project.liveUrl),
                icon: const Icon(Icons.launch_rounded, color: Colors.white),
                label: const Text(
                  'Live Demo',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
