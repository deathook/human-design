import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';
import '../services/profile_storage_service.dart';
import '../data/composite_content.dart';
import 'edit_profile_screen.dart';

class CompositeScreen extends StatefulWidget {
  const CompositeScreen({super.key});

  @override
  State<CompositeScreen> createState() => _CompositeScreenState();
}

class _CompositeScreenState extends State<CompositeScreen> {
  List<UserProfile> savedProfiles = [];
  UserProfile? _profileA;
  UserProfile? _profileB;

  bool isLoading = false;
  Map<String, dynamic>? compositeResult;

  @override
  void initState() {
    super.initState();
    _loadProfilesAndInit();
  }

  Future<void> _loadProfilesAndInit() async {
    final list = await ProfileStorageService.getProfiles();
    if (mounted) {
      setState(() {
        savedProfiles = list;
        if (list.isNotEmpty) {
          _profileA = list.first;
          if (list.length > 1) {
            _profileB = list[1];
          }
        }
      });

      // Nếu đã có đủ 2 người được chọn, tự động tính toán
      if (_profileA != null && _profileB != null) {
        _runComparison();
      }
    }
  }

  Future<void> _runComparison() async {
    if (_profileA == null || _profileB == null) return;

    setState(() {
      isLoading = true;
    });

    final res = await ApiService.calculateComposite(
      nameA: _profileA!.name,
      birthDateA: _profileA!.birthDate,
      birthTimeA: _profileA!.birthTime,
      nameB: _profileB!.name,
      birthDateB: _profileB!.birthDate,
      birthTimeB: _profileB!.birthTime,
    );

    if (mounted) {
      setState(() {
        compositeResult = res;
        isLoading = false;
      });
    }
  }

  void _swapProfiles() {
    if (_profileA == null || _profileB == null) return;
    setState(() {
      final temp = _profileA;
      _profileA = _profileB;
      _profileB = temp;
    });
    _runComparison();
  }

  void _showSelectProfileModal(bool isPersonA) {
    if (savedProfiles.isEmpty) {
      _openCreateProfile();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPersonA ? 'CHỌN LÁ SỐ NGƯỜI THỨ NHẤT' : 'CHỌN LÁ SỐ NGƯỜI THỨ HAI',
                  style: const TextStyle(color: AppTheme.goldLight, fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openCreateProfile();
                  },
                  icon: const Icon(Icons.add, size: 15, color: AppTheme.cyanCosmic),
                  label: const Text('Thêm mới', style: TextStyle(color: AppTheme.cyanCosmic, fontSize: 12)),
                ),
              ],
            ),
            const Divider(color: Color(0xFF282E47), height: 16),
            ...savedProfiles.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141724),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isPersonA ? _profileA?.id == p.id : _profileB?.id == p.id)
                          ? AppTheme.gold
                          : const Color(0xFF23283E),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: p.gender == 'Nữ'
                          ? Colors.pinkAccent.withValues(alpha: 0.2)
                          : AppTheme.gold.withValues(alpha: 0.2),
                      child: Icon(
                        p.gender == 'Nữ' ? Icons.female : Icons.male,
                        color: p.gender == 'Nữ' ? Colors.pinkAccent : AppTheme.goldLight,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(p.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(p.relationship, style: const TextStyle(color: AppTheme.goldLight, fontSize: 9)),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${p.birthDate} ${p.birthTime} • ${p.birthPlace} • ${p.typeName}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        if (isPersonA) {
                          _profileA = p;
                        } else {
                          _profileB = p;
                        }
                      });
                      if (_profileA != null && _profileB != null) {
                        _runComparison();
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateProfile() async {
    final res = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (ctx) => const EditProfileScreen()),
    );
    if (res != null) {
      await _loadProfilesAndInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        return Scaffold(
          appBar: AppBar(
            title: Text(isEn ? 'RELATIONSHIP COMPOSITE' : 'GIẢI MÃ TÌNH YÊU ĐÔI LỨA'),
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
                icon: const Icon(Icons.share, color: AppTheme.goldLight),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEn ? 'Composite Report ready to share!' : 'Bản luận giải tình yêu đôi lứa đã sẵn sàng chia sẻ!')),
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
                // 1. THẺ CHỌN 2 HỒ SƠ TỪ BỘ NHỚ LOCAL (HOÀN TOÀN KHÔNG TỰ ĐIỀN ẢO)
                _buildCoupleSelectorCard(isEn),
                const SizedBox(height: 14),

                if (_profileA != null && _profileB != null)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _runComparison,
                      icon: const Icon(Icons.favorite, size: 20, color: Color(0xFF0F1017)),
                      label: Text(
                        isEn ? 'RE-ANALYZE LOVE COMPOSITE' : '⚡ GIẢI MÃ TƯƠNG THÍCH ĐÔI LỨA',
                        style: const TextStyle(
                          color: Color(0xFF0F1017),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF282E47)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isEn
                              ? 'Please select both profiles to generate the love compatibility report'
                              : 'Vui lòng chọn đủ 2 lá số từ danh sách hồ sơ đã lưu để xem bản luận giải hợp đôi',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _openCreateProfile,
                          icon: const Icon(Icons.add),
                          label: Text(isEn ? 'Create Second Profile' : '+ Thêm Hồ Sơ Người Thứ Hai'),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppTheme.gold),
                    ),
                  )
                else if (compositeResult != null && _profileA != null && _profileB != null)
                  _buildDeepCompositeReport(compositeResult!, isEn),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Thẻ chọn 2 người từ hồ sơ đã lưu
  Widget _buildCoupleSelectorCard(bool isEn) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2B314B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // NGƯỜI THỨ NHẤT
          _buildPersonSelectorRow(
            label: isEn ? 'PERSON 1' : 'NGƯỜI THỨ NHẤT (ĐƯƠNG SỐ)',
            profile: _profileA,
            color: AppTheme.goldLight,
            icon: Icons.person,
            onSelect: () => _showSelectProfileModal(true),
            isEn: isEn,
          ),

          // NÚT HOÁN ĐỔI ⇄
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _swapProfiles,
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF141724),
                      border: Border.all(color: AppTheme.gold.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(Icons.swap_vert, color: AppTheme.goldLight, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // NGƯỜI THỨ HAI
          _buildPersonSelectorRow(
            label: isEn ? 'PERSON 2' : 'NGƯỜI THỨ HAI (BẠN ĐỜI / ĐỐI TÁC)',
            profile: _profileB,
            color: Colors.pinkAccent,
            icon: Icons.favorite,
            onSelect: () => _showSelectProfileModal(false),
            isEn: isEn,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSelectorRow({
    required String label,
    required UserProfile? profile,
    required Color color,
    required IconData icon,
    required VoidCallback onSelect,
    required bool isEn,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
                ],
              ),
              InkWell(
                onTap: onSelect,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder_shared, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(
                        profile == null ? (isEn ? 'Select' : 'Chọn lá số') : (isEn ? 'Change' : 'Đổi lá số'),
                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (profile != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: profile.gender == 'Nữ' ? Colors.pinkAccent.withValues(alpha: 0.2) : AppTheme.gold.withValues(alpha: 0.2),
                  child: Icon(profile.gender == 'Nữ' ? Icons.female : Icons.male, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(profile.name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(profile.relationship, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.birthDate} ${profile.birthTime} • ${profile.birthPlace}',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                      if (profile.typeName.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          '${profile.typeName} • Hồ sơ ${profile.profileKey}',
                          style: const TextStyle(color: AppTheme.cyanCosmic, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            InkWell(
              onTap: onSelect,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline, color: color, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        isEn ? 'Click to select profile from saved list' : 'Chạm để chọn từ danh sách lá số đã lưu',
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Báo cáo Hợp Đôi Chuyên Sâu chuẩn mẫu 14 trang PDF
  Widget _buildDeepCompositeReport(Map<String, dynamic> data, bool isEn) {
    final personA = data['person_a'] as Map<String, dynamic>? ?? {};
    final personB = data['person_b'] as Map<String, dynamic>? ?? {};
    final composite = data['composite'] as Map<String, dynamic>? ?? {};

    final nameA = _profileA!.name;
    final nameB = _profileB!.name;

    final typeA = personA['type'] as String? ?? (_profileA!.typeName.isNotEmpty ? _profileA!.typeName : 'Khởi Xướng Vận Hành');
    final profileA = personA['profile'] as String? ?? (_profileA!.profileKey.isNotEmpty ? _profileA!.profileKey : '1/3');
    final typeB = personB['type'] as String? ?? (_profileB!.typeName.isNotEmpty ? _profileB!.typeName : 'Vận Hành');
    final profileB = personB['profile'] as String? ?? (_profileB!.profileKey.isNotEmpty ? _profileB!.profileKey : '6/3');

    final definedCentersCount = (composite['defined_centers'] as List?)?.length ?? 8;
    final connTheme = CompositeContent.getConnectionTheme(definedCentersCount, isEn);

    final loveTypeA = CompositeContent.getLoveByType(typeA, nameA, isEn);
    final loveProfileA = CompositeContent.getLoveByProfile(profileA, nameA, isEn);
    final loveTypeB = CompositeContent.getLoveByType(typeB, nameB, isEn);
    final loveProfileB = CompositeContent.getLoveByProfile(profileB, nameB, isEn);

    final compromiseDetail = CompositeContent.getCompromiseChannelDetail('20-34', nameA, nameB, isEn);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BÌA BÁO CÁO HỢP ĐÔI (TRANG 1 PDF)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B38), Color(0xFF15192E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withValues(alpha: 0.15),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.gold, width: 1),
                ),
                child: const Text(
                  'TINH HOA BẢN MỆNH • HUMAN DESIGN POWER',
                  style: TextStyle(color: AppTheme.goldLight, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isEn ? 'DECODING HUMAN DESIGN IN LOVE' : 'GIẢI MÃ HUMAN DESIGN TRONG TÌNH YÊU ĐÔI LỨA',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.goldLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '“Tình yêu không phải nơi ta đến, mà là cách ta cùng đi”',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
              ),
              const Divider(color: Color(0xFF2C324E), height: 24),

              // Tên và thông số hai người
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(nameA, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('${_profileA!.gender} • ${_profileA!.birthDate} • ${_profileA!.birthPlace}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5)),
                        const SizedBox(height: 2),
                        Text('$typeA\nHồ sơ $profileA', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.goldLight, fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.pinkAccent),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(nameB, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('${_profileB!.gender} • ${_profileB!.birthDate} • ${_profileB!.birthPlace}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5)),
                        const SizedBox(height: 2),
                        Text('$typeB\nHồ sơ $profileB', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.goldLight, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ĐIỂM TƯƠNG THÍCH VÀ ĐỊNH DẠNG TƯƠNG TÁC (TRANG 12 PDF)
        _buildSectionCard(
          title: isEn ? 'COMPATIBILITY SCORE & THEME' : 'KHẢ NĂNG HÒA HỢP CẶP ĐÔI',
          icon: Icons.star_rate_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildScoreBadge(
                      title: isEn ? 'Energy Type' : 'Nhóm Năng Lượng',
                      score: '4/5 Tốt',
                      icon: Icons.energy_savings_leaf,
                      color: AppTheme.emeraldActive,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildScoreBadge(
                      title: isEn ? 'Profile Match' : 'Hồ Sơ Tính Cách',
                      score: '4/5 Tốt',
                      icon: Icons.psychology,
                      color: AppTheme.goldLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141724),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF282E47)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connTheme['theme']!,
                      style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      connTheme['desc']!,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // PHẦN 1 & 2: TÌNH YÊU & NHÓM NĂNG LƯỢNG / HỒ SƠ NGƯỜI THỨ NHẤT (TRANG 2-3 PDF)
        _buildSectionCard(
          title: '${isEn ? "PART 1: " : "PHẦN 1: "}$nameA',
          subtitle: '$typeA • Hồ sơ $profileA',
          icon: Icons.person,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loveTypeA['title']!,
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                loveTypeA['content']!,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, height: 1.5),
              ),
              const Divider(color: Color(0xFF282E47), height: 24),
              Text(
                loveProfileA['title']!,
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(loveProfileA['sections'] as List).map((sec) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sec['heading']!, style: const TextStyle(color: AppTheme.cyanCosmic, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(sec['body']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.45)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // CÁNH CỔNG TÌNH YÊU CỦA NGƯỜI THỨ NHẤT (TRANG 4-5 PDF: CỔNG 10)
        _buildLoveGateCard(10, nameA),
        const SizedBox(height: 16),

        // PHẦN 3 & 4: TÌNH YÊU & NHÓM NĂNG LƯỢNG / HỒ SƠ NGƯỜI THỨ HAI (TRANG 6-8 PDF)
        _buildSectionCard(
          title: '${isEn ? "PART 2: " : "PHẦN 2: "}$nameB',
          subtitle: '$typeB • Hồ sơ $profileB',
          icon: Icons.person_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loveTypeB['title']!,
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                loveTypeB['content']!,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, height: 1.5),
              ),
              const Divider(color: Color(0xFF282E47), height: 24),
              Text(
                loveProfileB['title']!,
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(loveProfileB['sections'] as List).map((sec) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sec['heading']!, style: const TextStyle(color: AppTheme.cyanCosmic, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(sec['body']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.45)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // CÁNH CỔNG TÌNH YÊU CỦA NGƯỜI THỨ HAI (TRANG 9-11 PDF: CỔNG 28 & CỔNG 40)
        _buildLoveGateCard(28, nameB),
        const SizedBox(height: 12),
        _buildLoveGateCard(40, nameB),
        const SizedBox(height: 16),

        // PHẦN 5: XUNG ĐỘT & CÁC DÒNG KÊNH THỎA HIỆP (TRANG 12-14 PDF)
        _buildSectionCard(
          title: isEn ? 'CONFLICTS & COMPROMISE CHANNELS' : 'XUNG ĐỘT & CÁC DÒNG KÊNH THỎA HIỆP',
          subtitle: 'Kênh 20-34: Kênh Của Sự Lôi Cuốn',
          icon: Icons.compare_arrows,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Đây là những điểm chạm mong manh nhất trong mối quan hệ của bạn, nơi rất dễ nảy sinh oán giận và căng thẳng. Hãy nhận diện và chủ động điều hướng để nuôi dưỡng tình yêu lành mạnh và bền lâu.',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 12, height: 1.4),
                ),
              ),
              const SizedBox(height: 14),

              // ĐỘNG LỰC ĐÔI BÊN
              Text(
                'ĐỘNG LỰC DÒNG KÊNH CỦA $nameA:',
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...(compromiseDetail['personADynamics'] as List).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('▪ ', style: TextStyle(color: AppTheme.goldLight)),
                        Expanded(child: Text(item, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.4))),
                      ],
                    ),
                  )),

              const SizedBox(height: 10),
              Text(
                'TRẢI NGHIỆM TƯƠNG TÁC NƠI $nameB:',
                style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...(compromiseDetail['personBDynamics'] as List).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('▪ ', style: TextStyle(color: Colors.pinkAccent)),
                        Expanded(child: Text(item, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.4))),
                      ],
                    ),
                  )),

              const Divider(color: Color(0xFF282E47), height: 24),

              // NHỮNG KHÓ KHĂN TIỀM ẨN
              const Text(
                'NHỮNG KHÓ KHĂN TIỀM ẨN TRONG MỐI QUAN HỆ:',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(compromiseDetail['challenges'] as List).map((ch) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                        Expanded(child: Text(ch, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4))),
                      ],
                    ),
                  )),

              const Divider(color: Color(0xFF282E47), height: 24),

              // CÁCH VƯỢT QUA NHỮNG KHÓ KHĂN NÀY (TRANG 13-14 PDF)
              const Text(
                'CÁCH VƯỢT QUA & THỰC HÀNH NUÔI DƯỠNG:',
                style: TextStyle(color: AppTheme.emeraldActive, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(compromiseDetail['solutions'] as List).map((sol) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppTheme.emeraldActive, size: 15),
                        const SizedBox(width: 8),
                        Expanded(child: Text(sol, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.45))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B314B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.goldLight, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppTheme.goldLight, fontSize: 13.5, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF282E47), height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildLoveGateCard(int gateNumber, String personName) {
    final gate = CompositeContent.loveGates[gateNumber];
    if (gate == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161A2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.pinkAccent),
                ),
                child: Text('CỔNG $gateNumber', style: const TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'CÁNH CỔNG TÌNH YÊU NƠI $personName',
                  style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(gate['quote']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11.5, fontStyle: FontStyle.italic)),
          const Divider(color: Color(0xFF252A40), height: 16),
          Text('Bản chất:', style: const TextStyle(color: AppTheme.goldLight, fontSize: 11.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(gate['core']!, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.4)),
          const SizedBox(height: 8),
          Text('Tác động lên mối quan hệ:', style: const TextStyle(color: AppTheme.goldLight, fontSize: 11.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(gate['relationship']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
          const SizedBox(height: 8),
          Text('Chiến lược hòa hợp:', style: const TextStyle(color: AppTheme.emeraldActive, fontSize: 11.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(gate['advice']!, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildScoreBadge({
    required String title,
    required String score,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF282E47)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5)),
                const SizedBox(height: 2),
                Text(score, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
