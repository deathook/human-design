import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/chart_data.dart';
import 'services/api_service.dart';
import 'services/profile_storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/bodygraph_screen.dart';
import 'screens/vip_reading_screen.dart';
import 'screens/composite_screen.dart';
import 'screens/profiles_screen.dart';
import 'services/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HumanDesignApp());
}

class HumanDesignApp extends StatelessWidget {
  const HumanDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Human Design - Tinh Hoa Bản Mệnh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationHolder(),
    );
  }
}

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({super.key});

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;
  ChartData? _currentChart;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialChart();
  }

  Future<void> _loadInitialChart() async {
    final activeProfile = await ProfileStorageService.getActiveProfile();
    final name = activeProfile?.name ?? 'Hoàng Nhật Minh';
    final birthDate = activeProfile?.birthDate ?? '1985-07-17';
    final birthTime = activeProfile?.birthTime ?? '23:05';
    final gender = activeProfile?.gender ?? 'Nam';

    final chart = await ApiService.calculateChart(
      name: name,
      birthDate: birthDate,
      birthTime: birthTime,
      timezone: 'Asia/Ho_Chi_Minh',
      gender: gender,
      isVip: true,
    );

    if (mounted) {
      setState(() {
        _currentChart = chart;
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateActiveChart(ChartData newChart) {
    setState(() {
      _currentChart = newChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentChart == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF0F1017), size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                'HUMAN DESIGN',
                style: TextStyle(
                  color: AppTheme.goldLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'TINH HOA BẢN MỆNH',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(color: AppTheme.gold, strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      );
    }

    final screens = [
      HomeScreen(chart: _currentChart!, onNavigateTab: _onTabTapped),
      BodygraphScreen(chart: _currentChart!),
      VipReadingScreen(chart: _currentChart!),
      const CompositeScreen(),
      ProfilesScreen(currentChart: _currentChart!, onChartSelected: _updateActiveChart),
    ];

    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF232840), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.wb_twilight),
                  activeIcon: const Icon(Icons.wb_twilight, color: AppTheme.gold),
                  label: isEn ? 'Dashboard' : 'Vận Trình',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_tree_outlined),
                  activeIcon: const Icon(Icons.account_tree, color: AppTheme.gold),
                  label: isEn ? 'BodyGraph' : 'BodyGraph',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.workspace_premium_outlined),
                  activeIcon: const Icon(Icons.workspace_premium, color: AppTheme.gold),
                  label: isEn ? 'VIP Reading' : 'Luận Giải VIP',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border),
                  activeIcon: const Icon(Icons.favorite, color: AppTheme.gold),
                  label: isEn ? 'Composite' : 'Hợp Đôi',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person, color: AppTheme.gold),
                  label: isEn ? 'Profiles' : 'Hồ Sơ',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
