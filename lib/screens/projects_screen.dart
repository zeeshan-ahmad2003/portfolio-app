import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../services/api_service.dart';

class Project {
  final String title;
  final String description;
  final String tech;
  final String githubUrl;
  final String liveUrl;
  final String fullDescription;
  final IconData icon;
  final List<Color> colors;
  final String category;
  final String? imagePath;

  Project({
    required this.title,
    required this.description,
    required this.tech,
    required this.githubUrl,
    required this.liveUrl,
    required this.fullDescription,
    required this.icon,
    required this.colors,
    required this.category,
    this.imagePath,
  });

  static String? _getImagePath(String title) {
    if (title.contains('YouTube')) return 'assets/images/yt_summarizer.png';
    if (title.contains('PDF')) return 'assets/images/pdf_compressor.png';
    if (title.contains('Portfolio')) return 'assets/images/portfolio_app.png';
    return null;
  }

  factory Project.fromApi(Map<String, dynamic> json) {
    final cat = json['category'] as String? ?? '';
    List<Color> colors;
    IconData icon;
    switch (cat) {
      case 'AI/ML':
        colors = [AppColors.purple, AppColors.cyan];
        icon = Icons.psychology_rounded;
        break;
      case 'Flutter':
        colors = [AppColors.cyan, AppColors.purple];
        icon = Icons.phone_android_rounded;
        break;
      case 'Python':
        colors = [const Color(0xFFF97316), const Color(0xFFFFB347)];
        icon = Icons.code_rounded;
        break;
      default:
        colors = [AppColors.cyan, AppColors.purple];
        icon = Icons.work_rounded;
    }
    return Project(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tech: json['tech'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      liveUrl: json['liveUrl'] ?? '',
      fullDescription: json['fullDescription'] ?? json['description'] ?? '',
      icon: icon,
      colors: colors,
      category: cat,
      imagePath: _getImagePath(json['title'] ?? ''),
    );
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _categories = ['All', 'Flutter', 'Python', 'AI/ML'];

  List<Project> _projects = [];
  bool _loadingApi = true;
  bool _isOffline = false; // ← Week 5

  final List<Project> _localProjects = [
    Project(
      title: 'YouTube Summarizer',
      description: 'AI-powered video summarizer with RAG architecture.',
      tech: 'Python · LangChain · Streamlit',
      githubUrl: 'https://github.com/zeeshan-ahmad2003/youtube-summarizer',
      liveUrl: 'https://youtube-summarizer-24gt.onrender.com',
      fullDescription:
          'A RAG-based tool that takes a YouTube video URL, extracts the '
          'transcript, and generates a smart summary using a language model. '
          'Built with Python, LangChain, and deployed live on Render.',
      icon: Icons.play_circle_rounded,
      colors: [const Color(0xFFE53935), const Color(0xFFFF6F60)],
      category: 'AI/ML',
      imagePath: 'assets/images/yt_summarizer.png',
    ),
    Project(
      title: 'PDF Compressor',
      description: 'Compress PDF files via web or desktop app.',
      tech: 'Python · Flask · Streamlit · Tkinter',
      githubUrl: 'https://github.com/zeeshan-ahmad2003',
      liveUrl: 'https://zeeshans-pdf-tool.streamlit.app',
      fullDescription:
          'Built in three versions: a Flask web app on Render, a Streamlit '
          'app on Streamlit Cloud, and an offline Tkinter desktop app.',
      icon: Icons.picture_as_pdf_rounded,
      colors: [const Color(0xFFF97316), const Color(0xFFFFB347)],
      category: 'Python',
      imagePath: 'assets/images/pdf_compressor.png',
    ),
    Project(
      title: 'Portfolio App',
      description: 'Professional Flutter mobile portfolio app.',
      tech: 'Flutter · Dart',
      githubUrl:
          'https://github.com/zeeshan-ahmad2003/portfolio-app/tree/week-3',
      liveUrl: 'https://github.com/zeeshan-ahmad2003/portfolio-app',
      fullDescription:
          'A professional mobile portfolio app built with Flutter during '
          'Codiora Software House internship.',
      icon: Icons.phone_android_rounded,
      colors: [AppColors.cyan, AppColors.purple],
      category: 'Flutter',
      imagePath: 'assets/images/portfolio_app.png',
    ),
    Project(
      title: 'AI Doctor Assistant',
      description: 'Multi-agent AI system for medical queries.',
      tech: 'Python · Groq API · LangGraph',
      githubUrl: 'https://github.com/zeeshan-ahmad2003',
      liveUrl: 'https://github.com/zeeshan-ahmad2003',
      fullDescription:
          'A three-agent system built with Python and Groq API. Agents '
          'handle diagnosis suggestions, prescription advice, and follow-up.',
      icon: Icons.medical_services_rounded,
      colors: [AppColors.purple, AppColors.cyan],
      category: 'AI/ML',
      imagePath: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadFromApi();
  }

  Future<void> _loadFromApi() async {
    setState(() => _loadingApi = true);
    final res = await ApiService.getProjects(
      category: _selectedCategory,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    );
    if (!mounted) return;
    if (res.success && res.data != null) {
      final list = (res.data as List)
          .map((j) => Project.fromApi(j as Map<String, dynamic>))
          .toList();
      setState(() {
        _projects = list;
        _loadingApi = false;
        _isOffline = res.fromCache; // ← Week 5
      });
    } else {
      setState(() {
        _projects = _localProjects;
        _loadingApi = false;
        _isOffline = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Project> get _filteredProjects {
    return _projects.where((p) {
      final matchesCat =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.tech.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();
  }

  void _onSearchChanged(String val) {
    setState(() => _searchQuery = val);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (_searchQuery == val && mounted) _loadFromApi();
    });
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    _loadFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final textSub = isDark ? AppColors.textGrey : AppColors.lightTextSub;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
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
      body: Column(
        children: [
          // ── Week 5: Offline Banner ──────────────────────────
          if (_isOffline)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Offline — showing cached projects. Pull to refresh.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Search Bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  color: isDark ? AppColors.textWhite : AppColors.lightText,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search projects or technologies...',
                  hintStyle: TextStyle(color: textSub, fontSize: 13),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.cyan,
                    size: 22,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: textSub,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Category Filter ─────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => _onCategoryChanged(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [AppColors.cyan, AppColors.purple],
                            )
                          : null,
                      color: isSelected ? null : cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.cyan.withOpacity(0.2),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.cyan.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : textSub,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredProjects.length} project${_filteredProjects.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSub,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_loadingApi) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      color: AppColors.cyan,
                      strokeWidth: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Projects List ───────────────────────────────────
          Expanded(
            child: _filteredProjects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: AppColors.cyan.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No projects found',
                          style: TextStyle(
                            color: textSub,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try a different search or category',
                          style: TextStyle(
                            color: textSub.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) => _ProjectCard(
                      project: _filteredProjects[index],
                      isDark: isDark,
                    ),
                  ),
          ),
        ],
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
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
          color: isDark ? AppColors.cardDark : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: project.colors.first.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: project.colors.first.withOpacity(isDark ? 0.12 : 0.07),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: project.imagePath != null
                  ? Stack(
                      children: [
                        Image.asset(
                          project.imagePath!,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _iconBanner(isDark: isDark),
                        ),
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: project.colors.first.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              project.category,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _iconBanner(isDark: isDark),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textWhite : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textGrey
                          : AppColors.lightTextSub,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: project.colors
                            .map((c) => c.withOpacity(0.1))
                            .toList(),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: project.colors.first.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      project.tech,
                      style: TextStyle(
                        fontSize: 10,
                        color: project.colors.first,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchURL(project.githubUrl),
                          icon: const Icon(Icons.code_rounded, size: 14),
                          label: const Text(
                            'GitHub',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: project.colors.first,
                            side: BorderSide(
                              color: project.colors.first.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                              size: 14,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Live Demo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _iconBanner({required bool isDark}) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: project.colors
              .map((c) => c.withOpacity(isDark ? 0.25 : 0.12))
              .toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: project.colors.first.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: project.colors.first.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: project.colors.first.withOpacity(0.3),
                ),
              ),
              child: Text(
                project.category,
                style: TextStyle(
                  fontSize: 10,
                  color: project.colors.first,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: project.colors),
                boxShadow: [
                  BoxShadow(
                    color: project.colors.first.withOpacity(0.4),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Icon(project.icon, size: 28, color: Colors.white),
            ),
          ),
        ],
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
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          project.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? AppColors.textWhite : AppColors.lightText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: project.imagePath != null
                  ? Stack(
                      children: [
                        Image.asset(
                          project.imagePath!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _detailIconBanner(),
                        ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: project.colors),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              project.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _detailIconBanner(),
            ),
            const SizedBox(height: 20),
            Text(
              project.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textWhite : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: project.colors
                      .map((c) => c.withOpacity(0.1))
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
                color: isDark ? AppColors.textWhite : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.fullDescription,
              style: TextStyle(
                fontSize: 14,
                height: 1.8,
                color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
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

  Widget _detailIconBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: project.colors
              .map((c) => c.withOpacity(isDark ? 0.25 : 0.12))
              .toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
          child: Icon(project.icon, size: 50, color: Colors.white),
        ),
      ),
    );
  }
}
