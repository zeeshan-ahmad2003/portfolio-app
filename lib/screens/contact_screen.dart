import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse(
      'mailto:z.ahmad2003x@gmail.com?subject=Hello Zeeshan',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:0310-9803584');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            'Contact Me',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Banner ──
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
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cyan.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.contact_mail_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Let's Work Together",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Open to internships, collaborations\nand freelance projects.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Contact Cards ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ContactCard(
                    isDark: isDark,
                    icon: Icons.email_rounded,
                    color: AppColors.cyan,
                    title: 'Email',
                    subtitle: 'z.ahmad2003x@gmail.com',
                    onTap: _launchEmail,
                  ),
                  const SizedBox(height: 12),
                  _ContactCard(
                    isDark: isDark,
                    icon: Icons.phone_rounded,
                    color: AppColors.purple,
                    title: 'Phone',
                    subtitle: '0310-9803584',
                    onTap: _launchPhone,
                  ),
                  const SizedBox(height: 12),
                  _ContactCard(
                    isDark: isDark,
                    icon: Icons.location_on_rounded,
                    color: const Color(0xFFF97316),
                    title: 'Location',
                    subtitle: 'Charsadda, Khyber Pakhtunkhwa, Pakistan',
                    onTap: () => _launchURL(
                      'https://maps.google.com/?q=Charsadda,Khyber+Pakhtunkhwa,Pakistan',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Social Links ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.12),
                  width: 1,
                ),
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
                      const Icon(
                        Icons.share_rounded,
                        color: AppColors.cyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Social Media',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textWhite : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SocialRow(
                    isDark: isDark,
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    handle: '@zeeshan-ahmad2003',
                    color: isDark ? Colors.white70 : Colors.black87,
                    onTap: () =>
                        _launchURL('https://github.com/zeeshan-ahmad2003'),
                  ),
                  Divider(color: AppColors.cyan.withOpacity(0.15), height: 24),
                  _SocialRow(
                    isDark: isDark,
                    icon: Icons.link_rounded,
                    label: 'LinkedIn',
                    handle: 'Zeeshan Ahmad',
                    color: const Color(0xFF0077B5),
                    onTap: () => _launchURL(
                      'https://www.linkedin.com/in/zeeshan-ahmad-5b8a813aa/',
                    ),
                  ),
                  Divider(color: AppColors.cyan.withOpacity(0.15), height: 24),
                  _SocialRow(
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    label: 'Portfolio Website',
                    handle: 'zeeshan-portfolio.vercel.app',
                    color: AppColors.cyan,
                    onTap: () => _launchURL(
                      'https://zeeshan-portfolio-orcin-eight.vercel.app',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Availability Badge ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.cyan.withOpacity(isDark ? 0.15 : 0.08),
                    AppColors.purple.withOpacity(isDark ? 0.15 : 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Currently available for internships and freelance projects!',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.isDark,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDark ? 0.1 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isDark ? AppColors.textWhite : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textGrey : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: color.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String handle;
  final Color color;
  final VoidCallback onTap;

  const _SocialRow({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.handle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? AppColors.textWhite : Colors.black87,
                  ),
                ),
                Text(
                  handle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textGrey : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: isDark ? AppColors.textDim : Colors.black38,
          ),
        ],
      ),
    );
  }
}
