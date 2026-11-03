import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../data/reading_content.dart';
import '../services/language_service.dart';

class VipReadingScreen extends StatefulWidget {
  final ChartData chart;

  const VipReadingScreen({super.key, required this.chart});

  @override
  State<VipReadingScreen> createState() => _VipReadingScreenState();
}

class _VipReadingScreenState extends State<VipReadingScreen> {
  // Trạng thái mở khóa VIP (mặc định mở đầy đủ để trải nghiệm hoặc người dùng có thể bấm khóa/mở)
  bool isVipUnlocked = true;

  @override
  Widget build(BuildContext context) {
    final chart = widget.chart;

    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        // Lấy dữ liệu 10 chương chuyên sâu
        final ch1 = ReadingContent.getChapter1(isEn);
        final ch2 = ReadingContent.getChapter2('Manifesting_Generator', isEn);
        final ch3 = ReadingContent.getChapter3(chart.authorityName, isEn);
        final ch4 = ReadingContent.getChapter4(chart.definitionName, isEn);
        final ch5 = ReadingContent.getChapter5(chart.profileKey, isEn ? chart.crossNameEn : chart.crossName, isEn);
        final ch6 = ReadingContent.getChapter6(chart.definedCenters, chart.undefinedCenters, isEn);
        final ch7 = ReadingContent.getChapter7(chart.activeChannels, isEn);
        final ch8 = ReadingContent.getChapter8(chart.activations, isEn);
        final ch9 = ReadingContent.getChapter9(isEn);
        final ch10 = ReadingContent.getChapter10(isEn);

        return Scaffold(
          appBar: AppBar(
            title: Text(isEn ? 'PERSONAL HUMAN DESIGN REPORT' : 'BẢN LUẬN GIẢI ĐỊNH MỆNH VIP'),
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
                icon: Icon(
                  isVipUnlocked ? Icons.lock_open : Icons.lock,
                  color: isVipUnlocked ? AppTheme.goldLight : AppTheme.textMuted,
                ),
                tooltip: isVipUnlocked ? (isEn ? 'VIP Unlocked' : 'VIP Đã Mở Khóa') : (isEn ? 'Locked' : 'Đang Khóa'),
                onPressed: () {
                  setState(() {
                    isVipUnlocked = !isVipUnlocked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isVipUnlocked
                            ? (isEn ? 'VIP 10-Chapter Report Unlocked!' : 'Đã mở khóa toàn bộ 10 chương luận giải VIP!')
                            : (isEn ? 'Switched to free preview mode' : 'Đã chuyển về bản xem trước miễn phí'),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Trạng thái VIP
                if (!isVipUnlocked)
                  _buildVipPromoCard(isEn)
                else
                  _buildVipActiveBadge(isEn),
                const SizedBox(height: 16),

                // TỔNG QUAN BẢN MỆNH (ĐÃ SỬA LỖI TRÀN CHỮ HOÀN TOÀN)
                _buildSectionHeader(
                  isEn ? 'CHART SUMMARY' : 'TỔNG QUAN BẢN MỆNH',
                  Icons.auto_awesome,
                ),
                _buildCleanOverviewCard(chart, isEn),
                const SizedBox(height: 20),

                // DANH SÁCH 10 CHƯƠNG CHUYÊN SÂU
                _buildSectionHeader(
                  isEn ? '10-CHAPTER COMPREHENSIVE REPORT' : '10 CHƯƠNG LUẬN GIẢI CHUYÊN SÂU (CHUẨN SÁCH & IHDS)',
                  Icons.menu_book,
                ),
                const SizedBox(height: 8),

                _buildExpandableChapter(ch1, '01', Icons.explore, false),
                _buildExpandableChapter(ch2, '02', Icons.bolt, !isVipUnlocked),
                _buildExpandableChapter(ch3, '03', Icons.compass_calibration, !isVipUnlocked),
                _buildExpandableChapter(ch4, '04', Icons.polyline, !isVipUnlocked),
                _buildExpandableChapter(ch5, '05', Icons.brightness_7, !isVipUnlocked),
                _buildExpandableChapter(ch6, '06', Icons.hub, !isVipUnlocked),
                _buildExpandableChapter(ch7, '07', Icons.share, !isVipUnlocked),
                _buildExpandableChapter(ch8, '08', Icons.auto_awesome_mosaic, !isVipUnlocked),
                _buildExpandableChapter(ch9, '09', Icons.lightbulb, !isVipUnlocked),
                _buildExpandableChapter(ch10, '10', Icons.library_books, !isVipUnlocked),

                const SizedBox(height: 28),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanOverviewCard(ChartData chart, bool isEn) {
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
          _buildStackedInfo(isEn ? 'Full Name' : 'Họ và tên', chart.userName, AppTheme.goldLight),
          _buildStackedInfo(isEn ? 'Energy Type' : 'Nhóm Năng Lượng', isEn ? chart.typeNameEn : chart.typeName, AppTheme.textPrimary),
          _buildStackedInfo(isEn ? 'Strategy' : 'Chiến Lược Sống', isEn ? chart.strategyNameEn : chart.strategyName, AppTheme.textPrimary),
          _buildStackedInfo(isEn ? 'Inner Authority' : 'Thẩm Quyền Ra Quyết Định', isEn ? chart.authorityNameEn : chart.authorityName, AppTheme.goldLight),
          _buildStackedInfo(isEn ? 'Profile' : 'Hồ Sơ (Profile)', isEn ? chart.profileNameEn : chart.profileName, AppTheme.textPrimary),
          _buildStackedInfo(isEn ? 'Definition' : 'Định Nghĩa', isEn ? chart.definitionNameEn : chart.definitionName, AppTheme.textSecondary),
          _buildStackedInfo(isEn ? 'Incarnation Cross' : 'Thánh Giá Hóa Thân', isEn ? chart.crossNameEn : chart.crossName, AppTheme.goldLight),
        ],
      ),
    );
  }

  Widget _buildStackedInfo(String label, String value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(color: valColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Color(0xFF22263A), height: 12),
        ],
      ),
    );
  }

  Widget _buildExpandableChapter(Map<String, dynamic> data, String num, IconData icon, bool isLocked) {
    final title = data['title'] as String? ?? 'Chương $num';
    final subtitle = data['subtitle'] as String? ?? '';
    final paragraphs = (data['paragraphs'] as List?)?.cast<String>() ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLocked ? const Color(0xFF262A40) : AppTheme.gold.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: num == '01' || num == '02',
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isLocked ? Colors.white10 : AppTheme.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              num,
              style: TextStyle(
                color: isLocked ? AppTheme.textMuted : AppTheme.goldLight,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLocked ? AppTheme.textSecondary : AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
          subtitle: subtitle.isNotEmpty
              ? Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.goldLight, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isLocked ? const Icon(Icons.lock, color: AppTheme.textMuted, size: 18) : null,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: isLocked
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161826),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lock_outline, color: AppTheme.goldLight, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nội dung luận giải VIP chuyên sâu đã bị khóa. Vui lòng mở khóa để xem toàn bộ.',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: paragraphs.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            p,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12.5,
                              height: 1.55,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipPromoCard(bool isEn) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Color(0xFF0F1017), size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isEn ? 'UNLOCK LIFETIME VIP REPORT' : 'MỞ KHÓA BẢN ĐỒ ĐỊNH MỆNH VIP',
                  style: const TextStyle(
                    color: Color(0xFF0F1017),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Unlock all 10 in-depth chapters covering your life purpose, 9 centers with not-self mental monologues, channels, and 13 planetary gates.'
                : 'Mở khóa trọn vẹn 10 chương luận giải chuẩn sách "Human Design Cho Người Mới Bắt Đầu" & IHDS. Thấu suốt sứ mệnh, 9 trung tâm, đối thoại phi ngã, các kênh tài năng và 13 hành tinh.',
            style: const TextStyle(color: Color(0xFF1E2235), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F1017),
                foregroundColor: AppTheme.goldLight,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  isVipUnlocked = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn ? 'VIP Report Unlocked!' : 'Chúc mừng bạn đã mở khóa Luận Giải VIP trọn đời!')),
                );
              },
              child: Text(isEn ? 'UNLOCK VIP REPORT NOW' : 'MỞ KHÓA VIP NGAY (199.000đ / Trọn Đời)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipActiveBadge(bool isEn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gold, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: AppTheme.goldLight, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEn ? 'VIP ACTIVE: Full 10-Chapter In-Depth Report' : 'GÓI VIP ĐÃ MỞ KHÓA: Toàn Bộ 10 Chương Luận Giải Định Mệnh',
              style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldLight, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.goldLight,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
