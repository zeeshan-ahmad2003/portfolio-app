import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F4FF),
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 3),
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
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Zeeshan Ahmad',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                'BS Computer Science student at Abdul Wali Khan University Mardan. '
                'CGPA: 3.25 | Batch: 2023–2027. Passionate about Flutter, '
                'AI/ML, and building real-world applications.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: isDark ? AppColors.textGrey : Colors.black87,
                ),
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
                  ),
                  const SizedBox(height: 12),
                  _EduItem(
                    degree: 'FSc Pre-Medical',
                    school: 'Edwards College Peshawar',
                    year: '2021 – 2023',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _EduItem(
                    degree: 'Matriculation (Science)',
                    school: 'Al Karim Public High School Charsadda',
                    year: '2019 – 2021',
                    isDark: isDark,
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
                  _SkillBar(skill: 'Git & GitHub', level: 0.80, isDark: isDark),
                  _SkillBar(skill: 'SQL / SQLite', level: 0.70, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

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
        color: isDark ? AppColors.cardDark : Colors.white,
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
                  color: isDark ? AppColors.textWhite : Colors.black87,
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
  const _EduItem({
    required this.degree,
    required this.school,
    required this.year,
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
          decoration: const BoxDecoration(
            color: AppColors.cyan,
            shape: BoxShape.circle,
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
                  fontSize: 14,
                  color: isDark ? AppColors.textWhite : Colors.black87,
                ),
              ),
              Text(
                school,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textGrey : Colors.black54,
                ),
              ),
              Text(
                year,
                style: const TextStyle(fontSize: 12, color: AppColors.cyan),
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
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
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
                  fontSize: 14,
                  color: isDark ? AppColors.textWhite : Colors.black87,
                ),
              ),
              Text(
                company,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textGrey : Colors.black54,
                ),
              ),
              Text(
                period,
                style: const TextStyle(fontSize: 12, color: AppColors.purple),
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textGrey : Colors.black87,
                ),
              ),
              Text(
                '${(level * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
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
              minHeight: 8,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
            ),
          ),
        ],
      ),
    );
  }
}
