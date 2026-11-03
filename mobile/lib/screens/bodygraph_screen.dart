import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../widgets/bodygraph_view.dart';
import '../widgets/center_detail_sheet.dart';
import '../services/language_service.dart';
import 'fullscreen_bodygraph_viewer.dart';

class BodygraphScreen extends StatefulWidget {
  final ChartData chart;

  const BodygraphScreen({super.key, required this.chart});

  @override
  State<BodygraphScreen> createState() => _BodygraphScreenState();
}

class _BodygraphScreenState extends State<BodygraphScreen> {
  final TransformationController _transformController = TransformationController();

  void _showCenterDetail(String centerId) {
    final isDef = widget.chart.definedCenters.contains(centerId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CenterDetailSheet(
        centerId: centerId,
        isDefined: isDef,
        centerData: widget.chart.centers[centerId] as Map<String, dynamic>?,
      ),
    );
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chart = widget.chart;

    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        return Scaffold(
          appBar: AppBar(
            title: Text(isEn ? 'RAVE BODYGRAPH' : 'BIỂU ĐỒ NHÂN KHÍ BODYGRAPH'),
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
                icon: const Icon(Icons.refresh, color: AppTheme.goldLight),
                tooltip: isEn ? 'Reset Zoom' : 'Đặt lại kích thước',
                onPressed: _resetZoom,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: AppTheme.goldLight),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEn ? 'Chart image saved to gallery!' : 'Đã lưu hình ảnh lá số vào thư viện!')),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. THÔNG TIN TIÊU ĐỀ BẢN MỆNH (Phong cách tối giản thanh lịch như mẫu)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF252A40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chart.userName,
                              style: const TextStyle(
                                color: AppTheme.goldLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.gold, width: 1),
                              ),
                              child: Text(
                                '${isEn ? "Profile" : "Hồ sơ"}: ${chart.profileKey}',
                                style: const TextStyle(
                                  color: AppTheme.goldLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${isEn ? chart.typeNameEn : chart.typeName} • ${isEn ? chart.authorityNameEn : chart.authorityName}',
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${isEn ? chart.definitionNameEn : chart.definitionName} • ${chart.birthDate} ${chart.birthTime}',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. KHU VỰC BODYGRAPH CHÍNH HIỂN THỊ TO & RÕ RÀNG NHẤT (FULL CHIỀU RỘNG MÀN HÌNH)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF2D324D), width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: AspectRatio(
                                aspectRatio: 360 / 540,
                                child: BodygraphView(
                                  definedCenters: chart.definedCenters,
                                  activeChannels: chart.activeChannels,
                                  activeGates: chart.activeGates,
                                  variable: chart.variable,
                                  onCenterTap: _showCenterDetail,
                                  onDoubleTapOrExpand: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (ctx) => FullscreenBodygraphViewer(chart: chart)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Nút phóng to toàn màn hình như xem ảnh
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (ctx) => FullscreenBodygraphViewer(chart: chart)),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F121C).withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.fullscreen, color: AppTheme.goldLight, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        isEn ? 'Fullscreen' : 'Phóng to ảnh',
                                        style: const TextStyle(color: AppTheme.goldLight, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.touch_app, size: 14, color: AppTheme.goldLight),
                          const SizedBox(width: 4),
                          Text(
                            isEn
                                ? 'Tap center to inspect • Tap "Fullscreen" to zoom freely'
                                : 'Chạm trung tâm để xem chi tiết • Bấm "Phóng to ảnh" để zoom tự do',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 3. HAI HÀNG THIẾT KẾ VÀ TÍNH CÁCH CHUYỂN XUỐNG PHÍA DƯỚI CÙNG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildConsolidatedPlanetCard(chart, isEn),
                ),

                const SizedBox(height: 16),

                // 4. THÔNG SỐ BẢN MỆNH NHÂN KHÍ (CHART DATA PROPERTIES)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2D324D)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'CHART DATA PROPERTIES' : 'THÔNG SỐ BẢN MỆNH NHÂN KHÍ',
                          style: const TextStyle(
                            color: AppTheme.goldLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCleanPropertyItem(
                          isEn ? 'Type' : 'Nhóm Năng Lượng',
                          isEn ? chart.typeNameEn : chart.typeName,
                          AppTheme.goldLight,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Aura' : 'Trường Hào Quang',
                          isEn ? chart.auraEn : chart.aura,
                          AppTheme.textPrimary,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Strategy' : 'Chiến Lược',
                          isEn ? chart.strategyNameEn : chart.strategyName,
                          AppTheme.textPrimary,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Authority' : 'Thẩm Quyền',
                          isEn ? chart.authorityNameEn : chart.authorityName,
                          AppTheme.goldLight,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Profile' : 'Hồ Sơ (Profile)',
                          isEn ? chart.profileNameEn : chart.profileName,
                          AppTheme.textPrimary,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Definition' : 'Định Nghĩa Liên Kết',
                          isEn ? chart.definitionNameEn : chart.definitionName,
                          AppTheme.textSecondary,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Signature' : 'Dấu Hiệu Thỏa Nguyện',
                          isEn ? chart.signatureEn : chart.signature,
                          AppTheme.emeraldActive,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Not-Self Theme' : 'Chủ Đề Phi Ngã',
                          isEn ? chart.notSelfEn : chart.notSelf,
                          AppTheme.redDesign,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Incarnation Cross' : 'Thánh Giá Hóa Thân',
                          isEn ? chart.crossNameEn : chart.crossName,
                          AppTheme.goldLight,
                        ),
                        _buildCleanPropertyItem(
                          isEn ? 'Variable' : 'Biến Nhận Thức (Variable)',
                          chart.variable,
                          AppTheme.cyanCosmic,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 5. DANH SÁCH CÁC KÊNH KÍCH HOẠT (DEFINED CHANNELS)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'DEFINED CHANNELS' : 'CÁC KÊNH NĂNG LƯỢNG KÍCH HOẠT',
                        style: const TextStyle(
                          color: AppTheme.goldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (chart.activeChannels.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isEn
                                ? 'No defined channels (Typical of Reflector or single-gate definitions).'
                                : 'Không có kênh nào được kích hoạt hoàn toàn (Đặc trưng của Nhóm Phản Chiếu hoặc người có nhiều cổng đơn lẻ).',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        )
                      else
                        ...chart.activeChannels.map((ch) {
                          final id = ch['id'] ?? '';
                          final name = isEn ? (ch['name_en'] ?? ch['name_vi'] ?? '') : (ch['name_vi'] ?? '');
                          final desc = isEn ? (ch['desc_en'] ?? ch['description'] ?? '') : (ch['desc_vi'] ?? ch['description'] ?? '');
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.gold.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Channel $id',
                                        style: const TextStyle(
                                          color: AppTheme.goldLight,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  desc,
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
    );
  }

  /// Bảng đối chiếu 13 hành tinh Thiết Kế (Đỏ) & Tính Cách (Đen/Vàng kim) nằm phía dưới BodyGraph
  Widget _buildConsolidatedPlanetCard(ChartData chart, bool isEn) {
    final dAct = chart.activations['design'] as Map<String, dynamic>? ?? {};
    final pAct = chart.activations['personality'] as Map<String, dynamic>? ?? {};

    final planets = [
      {'key': 'Sun', 'symbol': '☉', 'vi': 'Mặt Trời', 'en': 'Sun'},
      {'key': 'Earth', 'symbol': '⊕', 'vi': 'Trái Đất', 'en': 'Earth'},
      {'key': 'North_Node', 'symbol': '☊', 'vi': 'La Hầu (Bắc)', 'en': 'North Node'},
      {'key': 'South_Node', 'symbol': '☋', 'vi': 'Kế Đô (Nam)', 'en': 'South Node'},
      {'key': 'Moon', 'symbol': '☽', 'vi': 'Mặt Trăng', 'en': 'Moon'},
      {'key': 'Mercury', 'symbol': '☿', 'vi': 'Thủy Tinh', 'en': 'Mercury'},
      {'key': 'Venus', 'symbol': '♀', 'vi': 'Kim Tinh', 'en': 'Venus'},
      {'key': 'Mars', 'symbol': '♂', 'vi': 'Hỏa Tinh', 'en': 'Mars'},
      {'key': 'Jupiter', 'symbol': '♃', 'vi': 'Mộc Tinh', 'en': 'Jupiter'},
      {'key': 'Saturn', 'symbol': '♄', 'vi': 'Thổ Tinh', 'en': 'Saturn'},
      {'key': 'Uranus', 'symbol': '♅', 'vi': 'Thiên Vương', 'en': 'Uranus'},
      {'key': 'Neptune', 'symbol': '♆', 'vi': 'Hải Vương', 'en': 'Neptune'},
      {'key': 'Pluto', 'symbol': '♇', 'vi': 'Diêm Vương', 'en': 'Pluto'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D324D)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? 'DESIGN' : 'THIẾT KẾ',
                      style: const TextStyle(
                        color: AppTheme.redDesign,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      isEn ? '(Unconscious)' : '(Vô thức)',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    isEn ? 'PLANETS' : 'HÀNH TINH',
                    style: const TextStyle(
                      color: AppTheme.goldLight,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isEn ? 'PERSONALITY' : 'TÍNH CÁCH',
                      style: const TextStyle(
                        color: AppTheme.yellowPersonality,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      isEn ? '(Conscious)' : '(Ý thức)',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF252A40), height: 16),
          ...planets.map((p) {
            final key = p['key']!;
            final symbol = p['symbol']!;
            final name = isEn ? p['en']! : p['vi']!;

            final dObj = dAct[key] as Map<String, dynamic>?;
            final pObj = pAct[key] as Map<String, dynamic>?;

            final dGateLine = (dObj?['gate'] != null && dObj?['line'] != null)
                ? '${dObj!['gate']}.${dObj['line']}'
                : '--.-';
            final dFix = dObj?['fix_symbol'] ?? '';

            final pGateLine = (pObj?['gate'] != null && pObj?['line'] != null)
                ? '${pObj!['gate']}.${pObj['line']}'
                : '--.-';
            final pFix = pObj?['fix_symbol'] ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  // Cột Thiết Kế (Đỏ)
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Text(
                          dGateLine,
                          style: const TextStyle(
                            color: AppTheme.redDesign,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (dFix.isNotEmpty) ...[
                          const SizedBox(width: 3),
                          Text(
                            dFix,
                            style: TextStyle(
                              color: dFix == '▲' ? AppTheme.emeraldActive : AppTheme.redDesign,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Cột Hành Tinh (Biểu tượng + Tên)
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          symbol,
                          style: const TextStyle(
                            color: AppTheme.goldLight,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cột Tính Cách (Vàng kim / Đen)
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (pFix.isNotEmpty) ...[
                          Text(
                            pFix,
                            style: TextStyle(
                              color: pFix == '▲' ? AppTheme.emeraldActive : AppTheme.redDesign,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          pGateLine,
                          style: const TextStyle(
                            color: AppTheme.yellowPersonality,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCleanPropertyItem(String label, String value, Color valueColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF22273D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11.5, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
