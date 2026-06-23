import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  Map<String, String> _profile = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await StorageService.loadProfile();
    if (mounted) setState(() => _profile = data);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final textSub = isDark ? AppColors.textGrey : AppColors.lightTextSub;
    final textPrimary = isDark ? AppColors.textWhite : AppColors.lightText;

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
            '_ZA✨',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppColors.cyan,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        color: AppColors.cyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ── Hero Section ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        // ── Glowing Profile Photo ──
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 134,
                              height: 134,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppColors.cyan, AppColors.purple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cyan.withOpacity(0.35),
                                    blurRadius: 28,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 126,
                              height: 126,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: bg,
                              ),
                            ),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/profile.jpeg',
                                width: 118,
                                height: 118,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Online green dot
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: bg, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success.withOpacity(0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Name from storage
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.cyan, AppColors.purple],
                          ).createShader(bounds),
                          child: Text(
                            _profile['name'] ?? 'Zeeshan Ahmad',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.cyan.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.cyan.withOpacity(0.08),
                          ),
                          child: const Text(
                            'Flutter Developer  •  CS Student',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Building modern mobile apps with Flutter & AI',
                          style: TextStyle(color: textSub, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Stats Row ──
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(0.12),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(isDark ? 0.07 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(value: '4+', label: 'Projects', isDark: isDark),
                    _GlowDivider(),
                    _StatItem(value: '3', label: 'Internships', isDark: isDark),
                    _GlowDivider(),
                    _StatItem(value: '8+', label: 'Skills', isDark: isDark),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── About Me ──
              _GlowCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'About Me', isDark: isDark),
                    const SizedBox(height: 10),
                    Text(
                      _profile['bio'] ??
                          'BS Computer Science student at Abdul Wali Khan '
                              'University Mardan (CGPA 3.25, Batch 2023–2027). '
                              'Passionate about Flutter, AI/ML, and building '
                              'practical software solutions.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        color: textSub,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Top Skills ──
              _GlowCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Top Skills', isDark: isDark),
                    const SizedBox(height: 14),
                    _SkillBar(
                      skill: 'Python',
                      level: 0.85,
                      isDark: isDark,
                      textPrimary: textPrimary,
                    ),
                    _SkillBar(
                      skill: 'Flutter & Dart',
                      level: 0.70,
                      isDark: isDark,
                      textPrimary: textPrimary,
                    ),
                    _SkillBar(
                      skill: 'Machine Learning',
                      level: 0.75,
                      isDark: isDark,
                      textPrimary: textPrimary,
                    ),
                    _SkillBar(
                      skill: 'HTML / CSS',
                      level: 0.80,
                      isDark: isDark,
                      textPrimary: textPrimary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Connect With Me ──
              _GlowCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Connect With Me', isDark: isDark),
                    const SizedBox(height: 14),
                    _GlowButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      gradientColors: [
                        const Color(0xFF333333),
                        const Color(0xFF555555),
                      ],
                      onTap: () =>
                          _launchURL('https://github.com/zeeshan-ahmad2003'),
                    ),
                    const SizedBox(height: 10),
                    _GlowButton(
                      label: 'LinkedIn',
                      icon: Icons.link_rounded,
                      gradientColors: [
                        const Color(0xFF0077B5),
                        const Color(0xFF00A0DC),
                      ],
                      onTap: () => _launchURL(
                        'https://www.linkedin.com/in/zeeshan-ahmad-5b8a813aa/',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _GlowButton(
                      label: 'Portfolio Website',
                      icon: Icons.language_rounded,
                      gradientColors: [AppColors.cyan, AppColors.purple],
                      onTap: () => _launchURL(
                        'https://zeeshan-portfolio-orcin-eight.vercel.app',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──

class _StatItem extends StatelessWidget {
  final String value, label;
  final bool isDark;
  const _StatItem({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.cyan, AppColors.purple],
          ).createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textDim : AppColors.lightTextSub,
          ),
        ),
      ],
    );
  }
}

class _GlowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cyan.withOpacity(0.05),
            AppColors.cyan.withOpacity(0.3),
            AppColors.cyan.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _GlowCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _GlowCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(isDark ? 0.06 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.cyan, AppColors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textWhite : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String skill;
  final double level;
  final bool isDark;
  final Color textPrimary;
  const _SkillBar({
    required this.skill,
    required this.level,
    required this.isDark,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              Text(
                '${(level * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: level,
              minHeight: 7,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _GlowButton({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
