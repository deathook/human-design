import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';

class HomeScreen extends StatefulWidget {
  final ChartData chart;
  final Function(int tabIndex)? onNavigateTab;

  const HomeScreen({
    super.key,
    required this.chart,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? transitData;
  bool isLoadingTransit = true;

  @override
  void initState() {
    super.initState();
    _loadTransit();
  }

  Future<void> _loadTransit() async {
    final data = await ApiService.getDailyTransit();
    if (mounted) {
      setState(() {
        transitData = data;
        isLoadingTransit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.chart;
    final sunTransit = transitData?['sun_transit'] ?? {};

    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        return Scaffold(
          appBar: AppBar(
            title: Text(isEn ? 'DAILY TRANSIT & WEATHER' : 'VẬN TRÌNH NHÂN KHÍ'),
            actions: [
              TextButton(
                onPressed: () {
                  LanguageService.toggleLanguage();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.gold, width: 1),
                  ),
                  child: Text(
                    isEn ? '🇻🇳 VI' : '🇬🇧 EN',
                    style: const TextStyle(color: AppTheme.goldLight, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppTheme.goldLight),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserGreetingCard(user, isEn),
                const SizedBox(height: 16),

                _buildDailyTransitCard(sunTransit, isEn),
                const SizedBox(height: 16),

                _buildQuickActions(isEn),
                const SizedBox(height: 16),

                _buildStrategyAdviceCard(user, isEn),
                const SizedBox(height: 16),

                _buildBookBanner(isEn),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserGreetingCard(ChartData user, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gold.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Color(0xFF0F1017), size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isEn ? "Hello" : "Xin chào"}, ${user.userName}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.gold, width: 0.8),
                      ),
                      child: Text(
                        isEn ? user.typeNameEn : user.typeName,
                        style: const TextStyle(
                          color: AppTheme.goldLight,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${isEn ? "Profile" : "Hồ sơ"} ${user.profileKey}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.textMuted, size: 16),
            onPressed: () => widget.onNavigateTab?.call(1),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTransitCard(Map<String, dynamic> sun, bool isEn) {
    final gate = sun['gate'] ?? 44;
    final line = sun['line'] ?? 3;
    final name = isEn ? (sun['name_en'] ?? 'Gate $gate.$line') : (sun['name_vi'] ?? 'Cổng $gate.$line');
    final msg = sun['message'] ?? 'Today’s energy is aligned with conscious awareness.';
    final highFreq = sun['high_frequency'] ?? 'Awareness, authenticity, and alignment.';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF261C42), Color(0xFF141728)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.purpleMystic.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: AppTheme.yellowPersonality, size: 22),
              const SizedBox(width: 8),
              Text(
                isEn ? 'TODAY\'S COSMIC WEATHER' : 'THỜI TIẾT VŨ TRỤ HÔM NAY',
                style: const TextStyle(
                  color: AppTheme.yellowPersonality,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.purpleMystic.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Gate $gate.$line',
                  style: const TextStyle(
                    color: AppTheme.goldLight,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            msg,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF16192B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_upward, color: AppTheme.emeraldActive, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${isEn ? "High frequency" : "Tần số cao"}: $highFreq',
                    style: const TextStyle(color: AppTheme.emeraldActive, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isEn) {
    return Row(
      children: [
        _buildActionPill(
          icon: Icons.account_tree,
          title: isEn ? 'BodyGraph' : 'Biểu Đồ Lá Số',
          color: AppTheme.cyanCosmic,
          onTap: () => widget.onNavigateTab?.call(1),
        ),
        const SizedBox(width: 10),
        _buildActionPill(
          icon: Icons.workspace_premium,
          title: isEn ? 'VIP Report' : 'Luận Giải VIP',
          color: AppTheme.gold,
          onTap: () => widget.onNavigateTab?.call(2),
        ),
        const SizedBox(width: 10),
        _buildActionPill(
          icon: Icons.favorite,
          title: isEn ? 'Composite' : 'So Hợp Đôi',
          color: AppTheme.redDesign,
          onTap: () => widget.onNavigateTab?.call(3),
        ),
      ],
    );
  }

  Widget _buildActionPill({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrategyAdviceCard(ChartData user, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D324D)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compass_calibration, color: AppTheme.goldLight, size: 20),
              const SizedBox(width: 8),
              Text(
                isEn ? 'DECISION COMPASS' : 'KIM CHỈ NAM RA QUYẾT ĐỊNH',
                style: const TextStyle(
                  color: AppTheme.goldLight,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${isEn ? "Strategy" : "Chiến lược"}: ${isEn ? user.strategyNameEn : user.strategyName}',
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.strategyDesc.isNotEmpty
                ? user.strategyDesc
                : (isEn ? 'Wait for life to come to you and respond.' : 'Lắng nghe phản hồi tự nhiên từ cơ thể.'),
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const Divider(color: Color(0xFF262A40), height: 20),
          Text(
            '${isEn ? "Authority" : "Thẩm quyền"}: ${isEn ? user.authorityNameEn : user.authorityName}',
            style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? 'Do not make decisions with your anxious mind. Trust the visceral guidance of your form.'
                : 'Không quyết định bằng tâm trí lo lắng. Lắng nghe tín hiệu chân thực từ quyền năng bên trong cơ thể bạn.',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBookBanner(bool isEn) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1E0F), Color(0xFF141724)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: AppTheme.goldLight, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'THE HUMAN DESIGN BOOK' : 'SÁCH HUMAN DESIGN CHO NGƯỜI MỚI',
                  style: const TextStyle(
                    color: AppTheme.goldLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEn
                      ? 'Exclusive authorship by TH Group & Ngô Xuân Hội. Complete analysis of 64 gates, 36 channels & 9 centers.'
                      : 'Tác quyền độc quyền TH Group - Tinh Hoa Bản Mệnh • Ngô Xuân Hội. Luận giải chi tiết 64 cổng, 36 kênh & 9 trung tâm.',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
