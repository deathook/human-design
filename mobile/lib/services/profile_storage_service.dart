import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String id;
  final String name;
  final String gender; // 'Nam' | 'Nữ'
  final String relationship; // 'Bản thân' | 'Bạn đời / Người yêu' | 'Con cái' | 'Bố mẹ' | 'Đối tác / Bạn bè'
  final String birthDate; // 'YYYY-MM-DD'
  final String birthTime; // 'HH:MM'
  final String birthPlace; // e.g. 'Hà Nội', 'TP. Hồ Chí Minh'
  final String typeName;
  final String profileKey;
  final bool isPrimary;
  final String createdAt;

  UserProfile({
    required this.id,
    required this.name,
    this.gender = 'Nam',
    this.relationship = 'Bản thân',
    required this.birthDate,
    required this.birthTime,
    this.birthPlace = 'Hà Nội',
    this.typeName = '',
    this.profileKey = '',
    this.isPrimary = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender,
    'relationship': relationship,
    'birthDate': birthDate,
    'birthTime': birthTime,
    'birthPlace': birthPlace,
    'typeName': typeName,
    'profileKey': profileKey,
    'isPrimary': isPrimary,
    'createdAt': createdAt,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: json['name'] as String? ?? 'Chưa đặt tên',
    gender: json['gender'] as String? ?? 'Nam',
    relationship: json['relationship'] as String? ?? 'Bản thân',
    birthDate: json['birthDate'] as String? ?? '1995-10-25',
    birthTime: json['birthTime'] as String? ?? '14:30',
    birthPlace: json['birthPlace'] as String? ?? 'Hà Nội',
    typeName: json['typeName'] as String? ?? '',
    profileKey: json['profileKey'] as String? ?? '',
    isPrimary: json['isPrimary'] as bool? ?? false,
    createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
  );

  UserProfile copyWith({
    String? id,
    String? name,
    String? gender,
    String? relationship,
    String? birthDate,
    String? birthTime,
    String? birthPlace,
    String? typeName,
    String? profileKey,
    bool? isPrimary,
    String? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      relationship: relationship ?? this.relationship,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      typeName: typeName ?? this.typeName,
      profileKey: profileKey ?? this.profileKey,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProfileStorageService {
  static const String _profilesKey = 'hd_user_profiles_v2';
  static const String _activeIdKey = 'hd_active_profile_id_v2';

  /// Lấy toàn bộ danh sách hồ sơ đã lưu trong máy
  static Future<List<UserProfile>> getProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_profilesKey);
    if (rawList == null || rawList.isEmpty) {
      return [];
    }

    try {
      return rawList
          .map((str) => UserProfile.fromJson(jsonDecode(str) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Lấy hồ sơ đang được kích hoạt hiện tại
  static Future<UserProfile?> getActiveProfile() async {
    final profiles = await getProfiles();
    if (profiles.isEmpty) return null;

    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString(_activeIdKey);

    if (activeId != null) {
      final found = profiles.where((p) => p.id == activeId).toList();
      if (found.isNotEmpty) return found.first;
    }

    final primary = profiles.where((p) => p.isPrimary).toList();
    return primary.isNotEmpty ? primary.first : profiles.first;
  }

  /// Lưu hoặc cập nhật một hồ sơ vào bộ nhớ máy
  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = await getProfiles();

    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      profiles[index] = profile;
    } else {
      if (profiles.isEmpty) {
        profiles.add(profile.copyWith(isPrimary: true));
      } else {
        profiles.add(profile);
      }
    }

    final rawList = profiles.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_profilesKey, rawList);
    await prefs.setString(_activeIdKey, profile.id);
  }

  /// Đặt một hồ sơ làm hồ sơ đang kích hoạt
  static Future<void> setActiveProfileId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeIdKey, id);
  }

  /// Xóa một hồ sơ khỏi bộ nhớ máy
  static Future<void> deleteProfile(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == id);

    final rawList = profiles.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_profilesKey, rawList);

    final currentActive = prefs.getString(_activeIdKey);
    if (currentActive == id && profiles.isNotEmpty) {
      await prefs.setString(_activeIdKey, profiles.first.id);
    }
  }
}
