import 'package:flutter/material.dart';
import '../main.dart';
import '../services/storage_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  const ProfileScreen({super.key, required this.isDarkMode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> _profile = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await StorageService.loadProfile();
    if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.textWhite : AppColors.lightText;
    final textSub = isDark ? AppColors.textGrey : AppColors.lightTextSub;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.cyan),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        color: AppColors.cyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ── Header ──
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.cardDark, AppColors.bgDark]
                        : [AppColors.cyan, AppColors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
                child: Column(
                  children: [
                    // Edit button top right
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                isDarkMode: isDark,
                                currentProfile: _profile,
                              ),
                            ),
                          );
                          _loadProfile();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Photo
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      _profile['name'] ?? 'Zeeshan Ahmad',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'App Development Intern @ Codiora',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── About ──
              _ProfileCard(
                isDark: isDark,
                title: 'About Me',
                icon: Icons.info_outline_rounded,
                child: Text(
                  _profile['bio'] ??
                      'BS Computer Science student at Abdul Wali Khan University Mardan. '
                          'CGPA: 3.25 | Batch: 2023–2027.',
                  style: TextStyle(fontSize: 13, height: 1.7, color: textSub),
                ),
              ),

              // ── Education ──
              _ProfileCard(
                isDark: isDark,
                title: 'Education',
                icon: Icons.school_rounded,
                child: Column(
                  children: [
                    _EduItem(
                      degree: 'BS Computer Science',
                      school: 'Abdul Wali Khan University Mardan',
                      year: '2023 – 2027',
                      isDark: isDark,
                      color: AppColors.cyan,
                    ),
                    const SizedBox(height: 12),
                    _EduItem(
                      degree: 'FSc Pre-Medical',
                      school: 'Edwardes College Peshawar',
                      year: '2021 – 2023',
                      isDark: isDark,
                      color: AppColors.purple,
                    ),
                    const SizedBox(height: 12),
                    _EduItem(
                      degree: 'Matriculation (Science)',
                      school: 'Al Karim Public High School Charsadda',
                      year: '2019 – 2021',
                      isDark: isDark,
                      color: AppColors.cyan,
                    ),
                  ],
                ),
              ),

              // ── Experience ──
              _ProfileCard(
                isDark: isDark,
                title: 'Experience',
                icon: Icons.work_outline_rounded,
                child: Column(
                  children: [
                    _ExpItem(
                      role: 'App Development Intern',
                      company: 'Codiora Software House',
                      period: '2026 – Present',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _ExpItem(
                      role: 'Full Stack Intern',
                      company: 'DecodeLabs',
                      period: '2026',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _ExpItem(
                      role: 'ML Intern',
                      company: 'Arch Technologies',
                      period: '2026',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // ── Skills ──
              _ProfileCard(
                isDark: isDark,
                title: 'Skills',
                icon: Icons.bar_chart_rounded,
                child: Column(
                  children: [
                    _SkillBar(
                      skill: 'Flutter & Dart',
                      level: 0.70,
                      isDark: isDark,
                    ),
                    _SkillBar(skill: 'Python', level: 0.85, isDark: isDark),
                    _SkillBar(
                      skill: 'Machine Learning',
                      level: 0.75,
                      isDark: isDark,
                    ),
                    _SkillBar(skill: 'HTML / CSS', level: 0.80, isDark: isDark),
                    _SkillBar(skill: 'JavaScript', level: 0.65, isDark: isDark),
                    _SkillBar(skill: 'Java', level: 0.60, isDark: isDark),
                    _SkillBar(
                      skill: 'Git & GitHub',
                      level: 0.80,
                      isDark: isDark,
                    ),
                    _SkillBar(
                      skill: 'SQL / SQLite',
                      level: 0.70,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // ── Contact Info ──
              _ProfileCard(
                isDark: isDark,
                title: 'Contact Info',
                icon: Icons.contact_mail_rounded,
                child: Column(
                  children: [
                    _ContactRow(
                      icon: Icons.email_rounded,
                      label: _profile['email'] ?? 'z.ahmad2003x@gmail.com',
                      isDark: isDark,
                      color: AppColors.cyan,
                    ),
                    const SizedBox(height: 10),
                    _ContactRow(
                      icon: Icons.phone_rounded,
                      label: _profile['phone'] ?? '0310-9803584',
                      isDark: isDark,
                      color: AppColors.purple,
                    ),
                    const SizedBox(height: 10),
                    _ContactRow(
                      icon: Icons.location_on_rounded,
                      label: 'Charsadda, Khyber Pakhtunkhwa, Pakistan',
                      isDark: isDark,
                      color: const Color(0xFFF97316),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──

class _ProfileCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final Widget child;

  const _ProfileCard({
    required this.isDark,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(isDark ? 0.06 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.cyan, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textWhite : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _EduItem extends StatelessWidget {
  final String degree, school, year;
  final bool isDark;
  final Color color;

  const _EduItem({
    required this.degree,
    required this.school,
    required this.year,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? AppColors.textWhite : AppColors.lightText,
                ),
              ),
              Text(
                school,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
                ),
              ),
              Text(
                year,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpItem extends StatelessWidget {
  final String role, company, period;
  final bool isDark;

  const _ExpItem({
    required this.role,
    required this.company,
    required this.period,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withOpacity(0.4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? AppColors.textWhite : AppColors.lightText,
                ),
              ),
              Text(
                company,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
                ),
              ),
              Text(
                period,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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

  const _SkillBar({
    required this.skill,
    required this.level,
    required this.isDark,
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
                  color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
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

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
            ),
          ),
        ),
      ],
    );
  }
}
