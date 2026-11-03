import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';
import '../services/profile_storage_service.dart';
import 'edit_profile_screen.dart';

class ProfilesScreen extends StatefulWidget {
  final ChartData currentChart;
  final Function(ChartData newChart) onChartSelected;

  const ProfilesScreen({
    super.key,
    required this.currentChart,
    required this.onChartSelected,
  });

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  List<UserProfile> savedProfiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalProfiles();
  }

  Future<void> _loadLocalProfiles() async {
    final profiles = await ProfileStorageService.getProfiles();

    // Nếu bộ nhớ trống hoàn toàn, lưu lá số đang hoạt động làm hồ sơ đầu tiên
    if (profiles.isEmpty && widget.currentChart.userName.isNotEmpty) {
      final initial = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: widget.currentChart.userName,
        gender: 'Nam',
        relationship: 'Bản thân',
        birthDate: widget.currentChart.birthDate,
        birthTime: widget.currentChart.birthTime,
        birthPlace: 'Hà Nội',
        typeName: widget.currentChart.typeName,
        profileKey: widget.currentChart.profileKey,
        isPrimary: true,
        createdAt: DateTime.now().toIso8601String(),
      );
      await ProfileStorageService.saveProfile(initial);
      savedProfiles = [initial];
    } else {
      savedProfiles = profiles;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openEditProfileScreen([UserProfile? profile]) async {
    final res = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (ctx) => EditProfileScreen(
          editProfile: profile,
          onSaved: (chart, newProfile) {
            widget.onChartSelected(chart);
          },
        ),
      ),
    );

    if (res != null) {
      await _loadLocalProfiles();
    }
  }

  void _confirmDeleteProfile(UserProfile profile, bool isEn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(isEn ? 'Delete Chart' : 'Xóa Lá Số', style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
        content: Text(
          isEn
              ? 'Are you sure you want to delete "${profile.name}" from local storage?'
              : 'Bạn có chắc chắn muốn xóa lá số của "${profile.name}" khỏi bộ nhớ máy không?',
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : 'Hủy', style: const TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              await ProfileStorageService.deleteProfile(profile.id);
              await _loadLocalProfiles();
              messenger.showSnackBar(
                SnackBar(content: Text(isEn ? 'Deleted chart!' : 'Đã xóa lá số khỏi máy!')),
              );
            },
            child: Text(isEn ? 'Delete' : 'Xóa'),
          ),
        ],
      ),
    );
  }

  void _showKnowledgeModal(String title, String content, bool isEn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.goldLight, fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(color: Color(0xFF2D324D), height: 20),
              Text(content, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.5)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isEn ? 'Close' : 'Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        return Scaffold(
          appBar: AppBar(
            title: Text(isEn ? 'LOCAL PROFILES & ARCHIVE' : 'QUẢN LÝ LÁ SỐ ĐÃ LƯU'),
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
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DANH SÁCH LÁ SỐ ĐÃ LƯU TRONG BỘ NHỚ LOCAL CỦA MÁY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEn ? 'SAVED LOCAL CHARTS' : 'DANH SÁCH LÁ SỐ ĐÃ LƯU',
                      style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openEditProfileScreen(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.add, size: 15),
                      label: Text(isEn ? 'New Chart' : 'Lập lá số mới', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: AppTheme.gold)))
                else if (savedProfiles.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF282F4C)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle_outlined, size: 48, color: AppTheme.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          isEn
                              ? 'No saved charts yet.\nTap "+ New Chart" to create your personal chart!'
                              : 'Chưa có lá số nào được lưu trong máy.\nBấm "+ Lập lá số mới" để an sao bản mệnh cho bạn hoặc người thân!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () => _openEditProfileScreen(),
                          icon: const Icon(Icons.add),
                          label: Text(isEn ? 'Create First Chart' : 'Lập Lá Số Đầu Tiên'),
                        ),
                      ],
                    ),
                  )
                else
                  ...savedProfiles.map((p) {
                    final isCurrent = p.name == widget.currentChart.userName && p.birthDate == widget.currentChart.birthDate;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent ? AppTheme.gold : const Color(0xFF252A40),
                          width: isCurrent ? 1.8 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppTheme.gold.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (!isCurrent) {
                            final chart = await ApiService.calculateChart(
                              name: p.name,
                              birthDate: p.birthDate,
                              birthTime: p.birthTime,
                              gender: p.gender,
                            );
                            await ProfileStorageService.setActiveProfileId(p.id);
                            widget.onChartSelected(chart);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: p.gender == 'Nữ'
                                    ? Colors.pinkAccent.withValues(alpha: 0.2)
                                    : AppTheme.gold.withValues(alpha: 0.2),
                                child: Icon(
                                  p.gender == 'Nữ' ? Icons.female : Icons.male,
                                  color: p.gender == 'Nữ' ? Colors.pinkAccent : AppTheme.goldLight,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          p.name,
                                          style: TextStyle(
                                            color: isCurrent ? AppTheme.goldLight : AppTheme.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: AppTheme.gold.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            p.relationship,
                                            style: const TextStyle(color: AppTheme.goldLight, fontSize: 9.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (isCurrent) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: AppTheme.emeraldActive.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: AppTheme.emeraldActive, width: 0.8),
                                            ),
                                            child: Text(
                                              isEn ? 'ACTIVE' : 'ĐANG XEM',
                                              style: const TextStyle(color: AppTheme.emeraldActive, fontSize: 8.5, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${p.birthDate} ${p.birthTime} • ${p.birthPlace}',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                    ),
                                    if (p.typeName.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '${p.typeName} • Hồ sơ ${p.profileKey}',
                                        style: const TextStyle(color: AppTheme.cyanCosmic, fontSize: 10.5, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: AppTheme.goldLight, size: 19),
                                    tooltip: isEn ? 'Edit Chart' : 'Sửa lá số',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _openEditProfileScreen(p),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 19),
                                    tooltip: isEn ? 'Delete Chart' : 'Xóa lá số',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _confirmDeleteProfile(p, isEn),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 20),

                // BÁCH KHOA THƯ TRA CỨU
                Text(
                  isEn ? 'HUMAN DESIGN ENCYCLOPEDIA' : 'BÁCH KHOA THƯ HUMAN DESIGN',
                  style: const TextStyle(color: AppTheme.goldLight, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                _buildLibraryTile(
                  icon: Icons.groups,
                  title: isEn ? '5 Energy Types' : '5 Nhóm Năng Lượng (Energy Types)',
                  subtitle: isEn
                      ? 'Manifestor, Generator, Manifesting Generator, Projector, Reflector'
                      : 'Khởi Xướng, Vận Hành, Khởi Xướng Vận Hành, Khai Vấn, Phản Chiếu',
                  onTap: () => _showKnowledgeModal(
                    isEn ? '5 Energy Types' : '5 Nhóm Năng Lượng',
                    isEn
                        ? '1. Manifestor (8-9%): The initiator of change. Aura is closed and repelling. Signature: Peace. Not-Self: Anger. Strategy: Inform before acting.\n\n'
                          '2. Generator (34-35%): The steady life-force engine. Aura is open and enveloping. Signature: Satisfaction. Not-Self: Frustration. Strategy: Wait to respond.\n\n'
                          '3. Manifesting Generator (33%): The multi-tasking powerhouse. Signature: Satisfaction and Peace. Not-Self: Frustration and Anger. Strategy: Respond, envision, inform.\n\n'
                          '4. Projector (20%): The wise guide. Aura is focused and penetrating. Signature: Success. Not-Self: Bitterness. Strategy: Wait for invitation.\n\n'
                          '5. Reflector (1%): The lunar mirror. Aura is sampling and resistant. Signature: Surprise. Not-Self: Disappointment. Strategy: Wait 28.5-day Lunar Cycle.'
                        : '1. Nhóm Khởi Xướng (Manifestor, 8-9%): Người khởi xướng thay đổi. Chiến lược: Thông Báo.\n\n'
                          '2. Nhóm Vận Hành (Generator, 34-35%): Trái tim giữ nhịp sống. Chiến lược: Đáp Ứng từ Đan Điền.\n\n'
                          '3. Nhóm Khởi Xướng Vận Hành (Manifesting Generator, 33%): Đa nhiệm, hành động nhanh. Chiến lược: Đáp ứng & Thông báo.\n\n'
                          '4. Nhóm Khai Vấn (Projector, 20%): Người dẫn đường. Chiến lược: Chờ Đợi Lời Mời & Sự Công Nhận.\n\n'
                          '5. Nhóm Phản Chiếu (Reflector, 1%): Tấm gương của cộng đồng. Chiến lược: Chờ Đợi Chu Kỳ Mặt Trăng.',
                    isEn,
                  ),
                ),
                _buildLibraryTile(
                  icon: Icons.explore,
                  title: isEn ? '7 Inner Authorities' : '7 Quyền Năng Bên Trong (Authorities)',
                  subtitle: isEn
                      ? 'Solar Plexus, Sacral, Spleen, Ego, Self-Projected, Mental, Lunar'
                      : 'Thái Dương, Nguồn Sinh Lực, Sinh Giác, Bản Ngã, Danh Tính...',
                  onTap: () => _showKnowledgeModal(
                    isEn ? '7 Inner Authorities' : '7 Quyền Năng Bên Trong',
                    isEn
                        ? 'Priority hierarchy:\n1. Solar Plexus (Emotional)\n2. Sacral (Gut response)\n3. Splenic (Instant intuition)\n4. Ego / Heart (Willpower)\n5. Self-Projected (G-Center voice)\n6. Mental / Sounding Board\n7. Lunar (28.5 days)'
                        : '1. Quyền năng Cảm xúc (Thái Dương): Không có sự thật trong hiện tại, cần thời gian.\n2. Quyền năng Nguồn sinh lực (Đan Điền): Phản xạ âm thanh dạ dày "Ừ hứ / Ừ ừ".\n3. Quyền năng Nhận thức (Sinh Giác): Trực giác sinh tồn tức thời.\n4. Quyền năng Bản ngã (Tâm Ngã): Sức mạnh ý chí.\n5. Quyền năng Danh tính (Thượng Ngã): Giọng nói tự nhiên.\n6. Quyền năng Môi trường (Tuệ Nhãn).\n7. Quyền năng Chu kỳ Mặt Trăng.',
                    isEn,
                  ),
                ),

                const SizedBox(height: 20),

                // TÁC QUYỀN & XUẤT BẢN
                Center(
                  child: Column(
                    children: [
                      Text(
                        isEn ? 'HUMAN DESIGN ENERGY PLATFORM' : 'ỨNG DỤNG NHÂN KHÍ HUMAN DESIGN',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn
                            ? 'Based on "Human Design For Beginners"\nCompiled by TH Group - Tinh Hoa Bản Mệnh • Ngô Xuân Hội'
                            : 'Dựa trên cuốn sách "Human Design Cho Người Mới Bắt Đầu"\nBiên soạn: TH Group - Tinh Hoa Bản Mệnh • Ngô Xuân Hội',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF4B5563), fontSize: 10, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLibraryTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF23283E)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.goldLight, size: 22),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.textMuted, size: 14),
        onTap: onTap,
      ),
    );
  }
}
