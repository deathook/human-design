import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';
import '../services/profile_storage_service.dart';
import '../services/lunar_calendar_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? editProfile;
  final Function(ChartData chart, UserProfile profile)? onSaved;

  const EditProfileScreen({
    super.key,
    this.editProfile,
    this.onSaved,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late String _gender; // 'Nam' | 'Nữ'
  late String _relationship;

  // Ngày sinh Dương lịch
  late int _day;
  late int _month;
  late int _year;

  // Giờ & Phút sinh
  late int _hour;
  late int _minute;

  late String _selectedPlace;
  late String _selectedPlaceCoords;

  bool _showCanhGioDropdown = false;
  bool _isSaving = false;

  final Map<String, String> _provincesData = {
    'Hà Nội': '105,85°Đ, 21,03°B • Múi giờ UTC+7',
    'TP. Hồ Chí Minh': '106,63°Đ, 10,82°B • Múi giờ UTC+7',
    'Đà Nẵng': '108,20°Đ, 16,05°B • Múi giờ UTC+7',
    'Hải Phòng': '106,68°Đ, 20,84°B • Múi giờ UTC+7',
    'Cần Thơ': '105,78°Đ, 10,04°B • Múi giờ UTC+7',
    'Vũng Tàu': '107,08°Đ, 10,35°B • Múi giờ UTC+7',
    'Bình Dương': '106,65°Đ, 10,98°B • Múi giờ UTC+7',
    'Đồng Nai': '106,82°Đ, 10,95°B • Múi giờ UTC+7',
    'Khánh Hòa (Nha Trang)': '109,19°Đ, 12,24°B • Múi giờ UTC+7',
    'Lâm Đồng (Đà Lạt)': '108,44°Đ, 11,94°B • Múi giờ UTC+7',
    'Thừa Thiên Huế': '107,58°Đ, 16,46°B • Múi giờ UTC+7',
    'Quảng Ninh (Hạ Long)': '107,07°Đ, 20,95°B • Múi giờ UTC+7',
    'Bắc Ninh': '106,05°Đ, 21,18°B • Múi giờ UTC+7',
    'Hải Dương': '106,31°Đ, 20,94°B • Múi giờ UTC+7',
    'Nam Định': '106,16°Đ, 20,42°B • Múi giờ UTC+7',
    'Thái Bình': '106,33°Đ, 20,45°B • Múi giờ UTC+7',
    'Nghệ An (Vinh)': '105,68°Đ, 18,67°B • Múi giờ UTC+7',
    'Thanh Hóa': '105,77°Đ, 19,80°B • Múi giờ UTC+7',
    'An Giang': '105,12°Đ, 10,38°B • Múi giờ UTC+7',
    'Đồng Tháp': '105,63°Đ, 10,46°B • Múi giờ UTC+7',
    'Khác / Quốc tế': '105,85°Đ, 21,03°B • Múi giờ UTC+7',
  };

  final List<Map<String, dynamic>> _canhGioList = [
    {'name': 'Giờ Tý (23:00 - 00:59)', 'hour': 0, 'min': 0},
    {'name': 'Giờ Sửu (01:00 - 02:59)', 'hour': 2, 'min': 0},
    {'name': 'Giờ Dần (03:00 - 04:59)', 'hour': 4, 'min': 0},
    {'name': 'Giờ Mão (05:00 - 06:59)', 'hour': 6, 'min': 0},
    {'name': 'Giờ Thìn (07:00 - 08:59)', 'hour': 8, 'min': 0},
    {'name': 'Giờ Tị (09:00 - 10:59)', 'hour': 10, 'min': 0},
    {'name': 'Giờ Ngọ (11:00 - 12:59)', 'hour': 12, 'min': 0},
    {'name': 'Giờ Mùi (13:00 - 14:59)', 'hour': 14, 'min': 0},
    {'name': 'Giờ Thân (15:00 - 16:59)', 'hour': 16, 'min': 0},
    {'name': 'Giờ Dậu (17:00 - 18:59)', 'hour': 18, 'min': 0},
    {'name': 'Giờ Tuất (19:00 - 20:59)', 'hour': 20, 'min': 0},
    {'name': 'Giờ Hợi (21:00 - 22:59)', 'hour': 22, 'min': 0},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.editProfile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _gender = p?.gender ?? 'Nam';
    _relationship = p?.relationship ?? 'Bản thân';

    if (p != null) {
      final dt = DateTime.tryParse(p.birthDate) ?? DateTime(1995, 8, 15);
      _day = dt.day;
      _month = dt.month;
      _year = dt.year;

      final timeParts = p.birthTime.split(':');
      _hour = int.tryParse(timeParts[0]) ?? 12;
      _minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;
      _selectedPlace = p.birthPlace.isNotEmpty ? p.birthPlace : 'Hà Nội';
    } else {
      _day = 15;
      _month = 8;
      _year = 1995;
      _hour = 12;
      _minute = 0;
      _selectedPlace = 'Hà Nội';
    }

    _selectedPlaceCoords = _provincesData[_selectedPlace] ?? '105,85°Đ, 21,03°B • Múi giờ UTC+7';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitAndCalculate() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : 'Hoàng Nhật Minh';

    final m = _month.toString().padLeft(2, '0');
    final d = _day.toString().padLeft(2, '0');
    final birthDateStr = '$_year-$m-$d';

    final h = _hour.toString().padLeft(2, '0');
    final min = _minute.toString().padLeft(2, '0');
    final birthTimeStr = '$h:$min';

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    // Tính toán lá số qua Offline Dart Engine
    final chart = await ApiService.calculateChart(
      name: name,
      birthDate: birthDateStr,
      birthTime: birthTimeStr,
      gender: _gender,
      isVip: true,
    );

    final newProfile = UserProfile(
      id: widget.editProfile?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      gender: _gender,
      relationship: _relationship,
      birthDate: birthDateStr,
      birthTime: birthTimeStr,
      birthPlace: _selectedPlace,
      typeName: chart.typeName,
      profileKey: chart.profileKey,
      isPrimary: widget.editProfile?.isPrimary ?? (_relationship == 'Bản thân'),
      createdAt: widget.editProfile?.createdAt ?? DateTime.now().toIso8601String(),
    );

    await ProfileStorageService.saveProfile(newProfile);
    widget.onSaved?.call(chart, newProfile);

    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã an sao và lưu lá số cho $name ($birthDateStr $birthTimeStr)!'),
        backgroundColor: AppTheme.emeraldActive,
      ),
    );

    nav.pop(newProfile);
  }

  void _showDatePickerModal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_year, _month, _day),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.gold,
              onPrimary: Colors.black,
              surface: Color(0xFF14192D),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _day = picked.day;
        _month = picked.month;
        _year = picked.year;
      });
    }
  }

  void _showPlacePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121626),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CHỌN NƠI SINH (TỈNH THÀNH / QUỐC TẾ)',
                  style: TextStyle(color: AppTheme.goldLight, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(color: Color(0xFF222842), height: 16),
            Expanded(
              child: ListView(
                children: _provincesData.entries.map((entry) {
                  final isSelected = entry.key == _selectedPlace;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.gold.withValues(alpha: 0.15) : const Color(0xFF161B30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.gold : const Color(0xFF242C48),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: isSelected ? AppTheme.goldLight : const Color(0xFF64748B),
                        size: 20,
                      ),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          color: isSelected ? AppTheme.goldLight : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        entry.value,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPlace = entry.key;
                          _selectedPlaceCoords = entry.value;
                        });
                        Navigator.pop(ctx);
                      },
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

  @override
  Widget build(BuildContext context) {
    final isEn = LanguageService.isEnglish;
    final lunarDate = LunarCalendarHelper.convertSolarToLunar(_day, _month, _year);
    final canhGioStr = LunarCalendarHelper.getCanhGioString(_hour);
    final timeDisplay = '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFF0C101F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.goldLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEn ? 'Enter Birth Details' : 'Nhập Thông Tin Bản Mệnh',
          style: const TextStyle(
            color: Color(0xFFF3C64F), // Vàng kim thanh lịch như ảnh mẫu
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF14192D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2B3556)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEn ? '🇬🇧 EN' : '🇻🇳 VI',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TIÊU ĐỀ: THÔNG TIN ĐƯƠNG SỐ
            Text(
              isEn ? 'NATIVE INFORMATION' : 'THÔNG TIN ĐƯƠNG SỐ',
              style: const TextStyle(
                color: Color(0xFFE5A93C), // Màu vàng cam ấm
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 14),

            // 1. HỌ VÀ TÊN
            const Text(
              'Họ và tên',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF12172B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E2640)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFFE5A93C), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: 'Ví dụ: Hoàng Nhật Minh',
                        hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. GIỚI TÍNH (Nam / Nữ kiểu 2 nút cạnh nhau)
            const Text(
              'Giới tính',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _gender = 'Nam'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _gender == 'Nam' ? const Color(0xFFE5A93C) : const Color(0xFF12172B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _gender == 'Nam' ? const Color(0xFFE5A93C) : const Color(0xFF1E2640),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Nam',
                        style: TextStyle(
                          color: _gender == 'Nam' ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _gender = 'Nữ'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _gender == 'Nữ' ? const Color(0xFFE5A93C) : const Color(0xFF12172B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _gender == 'Nữ' ? const Color(0xFFE5A93C) : const Color(0xFF1E2640),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Nữ',
                        style: TextStyle(
                          color: _gender == 'Nữ' ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. NGÀY SINH DƯƠNG LỊCH (3 ô Ngày - Tháng - Năm)
            const Text(
              'Ngày sinh Dương lịch',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _showDatePickerModal,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Ô Ngày
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12172B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2640)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_day',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Ô Tháng
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12172B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2640)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_month',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Ô Năm
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12172B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2640)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_year',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // BANNER ÂM LỊCH TỰ ĐỘNG
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF141A32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF222B4A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFFE5A93C), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Âm lịch: $lunarDate',
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4. NƠI SINH (TỈNH THÀNH / QUỐC TẾ)
            const Text(
              'NƠI SINH (TỈNH THÀNH / QUỐC TẾ)',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF12172B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2B385E)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFFE5A93C), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPlace,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedPlaceCoords,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _showPlacePickerModal,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A213D),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5A93C).withValues(alpha: 0.6)),
                      ),
                      child: const Text(
                        'Thay đổi',
                        style: TextStyle(color: Color(0xFFE5A93C), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 5. GIỜ & PHÚT SINH CHÍNH XÁC
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giờ & Phút sinh chính xác',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12172B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E2640)),
                  ),
                  child: Text(
                    timeDisplay,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // KHỐI STEPPER GIỜ & PHÚT
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF12172B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E2640)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // CỘT GIỜ (0 - 23)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Giờ (0 - 23)',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepperBtn(
                                  label: '-',
                                  onTap: () {
                                    setState(() {
                                      _hour = (_hour - 1 + 24) % 24;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 48,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A223E),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF28345C)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _hour.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Color(0xFFE5A93C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStepperBtn(
                                  label: '+',
                                  onTap: () {
                                    setState(() {
                                      _hour = (_hour + 1) % 24;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // DẤU HAI CHẤM
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          ':',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // CỘT PHÚT (0 - 59)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Phút (0 - 59)',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepperBtn(
                                  label: '-5',
                                  onTap: () {
                                    setState(() {
                                      _minute = (_minute - 5 + 60) % 60;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 48,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A223E),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF28345C)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _minute.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Color(0xFFE5A93C),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStepperBtn(
                                  label: '+5',
                                  onTap: () {
                                    setState(() {
                                      _minute = (_minute + 5) % 60;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // CANH GIỜ TƯƠNG ỨNG
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A213D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2B385E)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFE5A93C), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Canh giờ tương ứng: $canhGioStr',
                            style: const TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ACCORDION: CHỌN NHANH THEO 12 CANH GIỜ
                  InkWell(
                    onTap: () => setState(() => _showCanhGioDropdown = !_showCanhGioDropdown),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Chọn nhanh theo 12 Canh Giờ (Địa Chi)',
                            style: TextStyle(color: Color(0xFF64B5F6), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            _showCanhGioDropdown ? Icons.expand_less : Icons.expand_more,
                            color: const Color(0xFF64B5F6),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_showCanhGioDropdown) ...[
                    const Divider(color: Color(0xFF222B4A), height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _canhGioList.map((item) {
                        final name = item['name'] as String;
                        final h = item['hour'] as int;
                        final m = item['min'] as int;
                        final isSel = canhGioStr == name;

                        return ChoiceChip(
                          label: Text(name),
                          selected: isSel,
                          selectedColor: const Color(0xFFE5A93C).withValues(alpha: 0.25),
                          labelStyle: TextStyle(
                            color: isSel ? const Color(0xFFE5A93C) : const Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _hour = h;
                              _minute = m;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. VAI TRÒ / MỐI QUAN HỆ
            const Text(
              'Vai trò / Mối quan hệ',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Bản thân',
                'Bạn đời / Người yêu',
                'Con cái',
                'Bố mẹ',
                'Đối tác / Bạn bè',
              ].map((rel) {
                final isSel = _relationship == rel;
                return ChoiceChip(
                  label: Text(rel),
                  selected: isSel,
                  selectedColor: const Color(0xFFE5A93C).withValues(alpha: 0.25),
                  labelStyle: TextStyle(
                    color: isSel ? const Color(0xFFE5A93C) : const Color(0xFF94A3B8),
                    fontSize: 11.5,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _relationship = rel);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // NÚT LẬP LÁ SỐ BẢN MỆNH
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5A93C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                onPressed: _isSaving ? null : _submitAndCalculate,
                child: _isSaving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Color(0xFF0F172A), strokeWidth: 2.5))
                    : Text(
                        isEn ? 'CALCULATE BODYGRAPH CHART' : 'LẬP LÁ SỐ BẢN MỆNH',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1E284A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2F3E70)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
