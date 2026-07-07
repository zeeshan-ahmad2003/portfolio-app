import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Map<String, String> _profile = {};
  bool _isOffline = false; // ← Week 5

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
    _loadApiContact();
  }

  Future<void> _loadLocalProfile() async {
    final data = await StorageService.loadProfile();
    if (mounted) setState(() => _profile = data);
  }

  Future<void> _loadApiContact() async {
    final res = await ApiService.getContact();
    if (!mounted || !res.success) return;
    final data = res.data as Map<String, dynamic>;
    setState(() {
      if (data['email'] != null) _profile['email'] = data['email'];
      if (data['phone'] != null) _profile['phone'] = data['phone'];
      if (data['location'] != null) _profile['location'] = data['location'];
      _isOffline = res.fromCache; // ← Week 5
    });
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchEmail() async {
    final email = _profile['email'] ?? 'z.ahmad2003x@gmail.com';
    final uri = Uri.parse('mailto:$email?subject=Hello Zeeshan');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPhone() async {
    final phone = _profile['phone'] ?? '0310-9803584';
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('$label copied!'),
          ],
        ),
        backgroundColor: AppColors.cyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.textWhite : AppColors.lightText;
    final textSub = isDark ? AppColors.textGrey : AppColors.lightTextSub;

    final email = _profile['email'] ?? 'z.ahmad2003x@gmail.com';
    final phone = _profile['phone'] ?? '0310-9803584';
    final location =
        _profile['location'] ?? 'Charsadda, Khyber Pakhtunkhwa, Pakistan';

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
            'Contact Me',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadLocalProfile();
          await _loadApiContact();
        },
        color: AppColors.cyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ── Week 5: Offline Banner ──────────────────────
              if (_isOffline)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: Colors.orange,
                        size: 16,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Offline — showing cached contact info. Pull to refresh.',
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

              // ── Header Banner ───────────────────────────────
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
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
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
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Let's Work Together",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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

              // ── Contact Cards ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ContactCard(
                      isDark: isDark,
                      icon: Icons.email_rounded,
                      color: AppColors.cyan,
                      title: 'Email',
                      subtitle: email,
                      onTap: _launchEmail,
                      onLongPress: () => _copyToClipboard(email, 'Email'),
                    ),
                    const SizedBox(height: 12),
                    _ContactCard(
                      isDark: isDark,
                      icon: Icons.phone_rounded,
                      color: AppColors.purple,
                      title: 'Phone',
                      subtitle: phone,
                      onTap: _launchPhone,
                      onLongPress: () => _copyToClipboard(phone, 'Phone'),
                    ),
                    const SizedBox(height: 12),
                    _ContactCard(
                      isDark: isDark,
                      icon: Icons.location_on_rounded,
                      color: const Color(0xFFF97316),
                      title: 'Location',
                      subtitle: location,
                      onTap: () =>
                          _launchURL('https://maps.google.com/?q=$location'),
                      onLongPress: () => _copyToClipboard(location, 'Location'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Social Links ────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
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
                            color: textPrimary,
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
                    Divider(
                      color: AppColors.cyan.withOpacity(0.12),
                      height: 24,
                    ),
                    _SocialRow(
                      isDark: isDark,
                      icon: Icons.link_rounded,
                      label: 'LinkedIn',
                      handle: 'zeeshan-ahmad-5b8a813aa',
                      color: const Color(0xFF0077B5),
                      onTap: () => _launchURL(
                        'https://www.linkedin.com/in/zeeshan-ahmad-5b8a813aa/',
                      ),
                    ),
                    Divider(
                      color: AppColors.cyan.withOpacity(0.12),
                      height: 24,
                    ),
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

              // ── Availability Badge ──────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cyan.withOpacity(isDark ? 0.12 : 0.07),
                      AppColors.purple.withOpacity(isDark ? 0.12 : 0.07),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Currently available for internships and freelance projects!',
                        style: TextStyle(
                          color: isDark ? AppColors.cyan : AppColors.cyanGlow,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
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
  final VoidCallback onLongPress;

  const _ContactCard({
    required this.isDark,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDark ? 0.08 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isDark ? AppColors.textWhite : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textGrey
                          : AppColors.lightTextSub,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: color.withOpacity(0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'hold to copy',
                  style: TextStyle(
                    fontSize: 8,
                    color: isDark ? AppColors.textDim : AppColors.lightTextSub,
                  ),
                ),
              ],
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
                    color: isDark ? AppColors.textWhite : AppColors.lightText,
                  ),
                ),
                Text(
                  handle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: isDark ? AppColors.textDim : AppColors.lightTextSub,
          ),
        ],
      ),
    );
  }
}
