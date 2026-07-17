import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/login_screen.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  final savedDark = await StorageService.loadTheme();
  runApp(MyApp(initialDarkMode: savedDark));
}

// ── AppColors ──
class AppColors {
  static const bgDark = Color(0xFF0A0E1A);
  static const cardDark = Color(0xFF0F1629);
  static const cardDark2 = Color(0xFF141B2D);
  static const cyan = Color(0xFF00D4FF);
  static const cyanGlow = Color(0xFF00A8CC);
  static const purple = Color(0xFF7B2FFF);
  static const purpleLight = Color(0xFF9B59FF);
  static const textWhite = Color(0xFFFFFFFF);
  static const textGrey = Color(0xFFA0AEC0);
  static const textDim = Color(0xFF6B7280);
  static const success = Color(0xFF00C896);
  static const lightBg = Color(0xFFF0F4FF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF1A1A2E);
  static const lightTextSub = Color(0xFF666680);
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  const MyApp({super.key, required this.initialDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  void _toggleTheme() async {
    setState(() => _isDarkMode = !_isDarkMode);
    await StorageService.saveTheme(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_ZA✨',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.cyan,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthWrapper(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
    );
  }
}

// ── Auth Wrapper ─────────────────────────────────────
class AuthWrapper extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AuthWrapper({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _checking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await ApiService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _checking = false;
      });
    }
  }

  void _onLoginSuccess() => setState(() => _isLoggedIn = true);
  void _onLogout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: AppColors.bgDark,
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: _gradientShader,
                child: Text(
                  '_ZA✨',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.cyan,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isLoggedIn) {
      return LoginScreen(
        isDarkMode: widget.isDarkMode,
        onLoginSuccess: _onLoginSuccess,
      );
    }

    return MainScreen(
      isDarkMode: widget.isDarkMode,
      onToggleTheme: widget.onToggleTheme,
      onLogout: _onLogout,
    );
  }
}

Shader _gradientShader(Rect bounds) => const LinearGradient(
  colors: [AppColors.cyan, AppColors.purple],
).createShader(bounds);

// ── MainScreen ────────
class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final screens = [
      HomeScreen(isDarkMode: isDark, onToggleTheme: widget.onToggleTheme),
      ProfileScreen(isDarkMode: isDark, onLogout: widget.onLogout),
      const ProjectsScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: _selectedIndex,
        isDark: isDark,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// ── Premium Floating Nav Bar ─────────
class _PremiumNavBar extends StatelessWidget {
  final int selectedIndex;
  final bool isDark;
  final Function(int) onTap;

  const _PremiumNavBar({
    required this.selectedIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
      {'icon': Icons.work_rounded, 'label': 'Projects'},
      {'icon': Icons.mail_rounded, 'label': 'Contact'},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      color: isDark ? AppColors.bgDark : AppColors.lightBg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.lightCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark
                ? AppColors.cyan.withValues(alpha: 0.2)
                : AppColors.cyan.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.cyan.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isActive = selectedIndex == index;
            final icon = items[index]['icon'] as IconData;
            final label = items[index]['label'] as String;

            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive)
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.cyan, AppColors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.4),
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 22),
                      )
                    else
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(
                          icon,
                          color: isDark
                              ? AppColors.textDim
                              : AppColors.lightTextSub,
                          size: 22,
                        ),
                      ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isActive
                            ? AppColors.cyan
                            : isDark
                            ? AppColors.textDim
                            : AppColors.lightTextSub,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
