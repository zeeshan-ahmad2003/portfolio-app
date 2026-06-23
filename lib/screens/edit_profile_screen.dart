import 'package:flutter/material.dart';
import '../main.dart';
import '../services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final Map<String, String> currentProfile;

  const EditProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.currentProfile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isSaving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile['name'] ?? 'Zeeshan Ahmad',
    );
    _bioController = TextEditingController(
      text:
          widget.currentProfile['bio'] ??
          'BS Computer Science student at Abdul Wali Khan University Mardan '
              '(CGPA 3.25, Batch 2023–2027). Passionate about Flutter, AI/ML, '
              'and building practical software solutions.',
    );
    _emailController = TextEditingController(
      text: widget.currentProfile['email'] ?? 'z.ahmad2003x@gmail.com',
    );
    _phoneController = TextEditingController(
      text: widget.currentProfile['phone'] ?? '0310-9803584',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await StorageService.saveProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    setState(() {
      _isSaving = false;
      _saved = true;
    });

    // Show success then go back
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bg = isDark ? AppColors.bgDark : AppColors.lightBg;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.textWhite : AppColors.lightText;
    final textSub = isDark ? AppColors.textGrey : AppColors.lightTextSub;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.cyan, AppColors.purple],
          ).createShader(bounds),
          child: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          // Save button in appbar
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: AppColors.cyan,
                      strokeWidth: 2,
                    ),
                  )
                : _saved
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ──
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.cyan, AppColors.purple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Info Banner ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.cyan,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Changes are saved locally on your device.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textGrey
                            : AppColors.lightTextSub,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Form Fields ──
            _FieldLabel(text: 'Full Name', isDark: isDark),
            const SizedBox(height: 8),
            _InputField(
              controller: _nameController,
              hint: 'Your full name',
              icon: Icons.person_rounded,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSub: textSub,
            ),

            const SizedBox(height: 18),

            _FieldLabel(text: 'Email Address', isDark: isDark),
            const SizedBox(height: 8),
            _InputField(
              controller: _emailController,
              hint: 'your@email.com',
              icon: Icons.email_rounded,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSub: textSub,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 18),

            _FieldLabel(text: 'Phone Number', isDark: isDark),
            const SizedBox(height: 8),
            _InputField(
              controller: _phoneController,
              hint: '0310-XXXXXXX',
              icon: Icons.phone_rounded,
              isDark: isDark,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSub: textSub,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 18),

            _FieldLabel(text: 'Bio', isDark: isDark),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _bioController,
                maxLines: 4,
                style: TextStyle(color: textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  hintStyle: TextStyle(color: textSub, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Save Button ──
            GestureDetector(
              onTap: _isSaving ? null : _saveProfile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _saved
                      ? const LinearGradient(
                          colors: [AppColors.success, AppColors.success],
                        )
                      : const LinearGradient(
                          colors: [AppColors.cyan, AppColors.purple],
                        ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSaving)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else if (_saved)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 22,
                      )
                    else
                      const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    const SizedBox(width: 10),
                    Text(
                      _isSaving
                          ? 'Saving...'
                          : _saved
                          ? 'Saved Successfully!'
                          : 'Save Changes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _FieldLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textGrey : AppColors.lightTextSub,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isDark;
  final Color cardBg;
  final Color textPrimary;
  final Color textSub;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textSub,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cyan.withOpacity(0.15), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textSub, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.cyan, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
