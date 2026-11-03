// chart_data.dart - Mô hình dữ liệu lá số Human Design Song Ngữ
class ChartData {
  final Map<String, dynamic> raw;
  final String userName;
  final String birthDate;
  final String birthTime;
  final String typeName;
  final String typeNameEn;
  final String strategyName;
  final String strategyNameEn;
  final String strategyDesc;
  final String authorityName;
  final String authorityNameEn;
  final String profileKey;
  final String profileName;
  final String profileNameEn;
  final String definitionName;
  final String definitionNameEn;
  final String crossName;
  final String crossNameEn;
  final String signature;
  final String signatureEn;
  final String notSelf;
  final String notSelfEn;
  final String aura;
  final String auraEn;
  final String variable;
  final List<String> definedCenters;
  final List<String> undefinedCenters;
  final List<dynamic> activeChannels;
  final Map<String, dynamic> activeGates;
  final Map<String, dynamic> activations;
  final Map<String, dynamic> centers;

  ChartData({
    required this.raw,
    required this.userName,
    required this.birthDate,
    required this.birthTime,
    required this.typeName,
    required this.typeNameEn,
    required this.strategyName,
    required this.strategyNameEn,
    required this.strategyDesc,
    required this.authorityName,
    required this.authorityNameEn,
    required this.profileKey,
    required this.profileName,
    required this.profileNameEn,
    required this.definitionName,
    required this.definitionNameEn,
    required this.crossName,
    required this.crossNameEn,
    required this.signature,
    required this.signatureEn,
    required this.notSelf,
    required this.notSelfEn,
    required this.aura,
    required this.auraEn,
    required this.variable,
    required this.definedCenters,
    required this.undefinedCenters,
    required this.activeChannels,
    required this.activeGates,
    required this.activations,
    required this.centers,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    final rawChart = json.containsKey('raw_chart') ? json['raw_chart'] as Map<String, dynamic> : json;
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final overview = json['overview'] as Map<String, dynamic>? ?? {};
    final typeData = rawChart['type'] as Map<String, dynamic>? ?? {};
    final authData = rawChart['authority'] as Map<String, dynamic>? ?? {};
    final profData = rawChart['profile'] as Map<String, dynamic>? ?? {};
    final defData = rawChart['definition'] as Map<String, dynamic>? ?? {};
    final crossData = rawChart['incarnation_cross'] as Map<String, dynamic>? ?? {};
    final strategyData = typeData['strategy'] as Map<String, dynamic>? ?? {};

    return ChartData(
      raw: json,
      userName: user['name'] ?? 'Bản mệnh',
      birthDate: user['birth_date'] ?? '',
      birthTime: user['birth_time'] ?? '',
      typeName: overview['type'] ?? typeData['name_vi'] ?? 'Nhóm Vận Hành',
      typeNameEn: overview['type_en'] ?? typeData['name_en'] ?? 'Generator',
      strategyName: overview['strategy'] ?? strategyData['name'] ?? 'Đáp ứng',
      strategyNameEn: overview['strategy_en'] ?? 'Wait to Respond',
      strategyDesc: strategyData['description'] ?? '',
      authorityName: overview['authority'] ?? authData['name_vi'] ?? 'Quyền năng Nguồn sinh lực',
      authorityNameEn: overview['authority_en'] ?? 'Sacral Authority',
      profileKey: overview['profile'] ?? profData['profile'] ?? '1/3',
      profileName: overview['profile_name'] ?? profData['name_vi'] ?? 'Hồ sơ 1/3',
      profileNameEn: overview['profile_name_en'] ?? 'Profile 1/3',
      definitionName: overview['definition'] ?? defData['name_vi'] ?? 'Liên kết Đơn',
      definitionNameEn: overview['definition_en'] ?? 'Single Definition',
      crossName: overview['incarnation_cross'] ?? crossData['name'] ?? 'Thánh Giá Hóa Thân',
      crossNameEn: overview['incarnation_cross_en'] ?? 'Incarnation Cross',
      signature: overview['signature'] ?? 'Thỏa mãn',
      signatureEn: overview['signature_en'] ?? 'Satisfaction',
      notSelf: overview['not_self'] ?? 'Bất mãn',
      notSelfEn: overview['not_self_en'] ?? 'Frustration',
      aura: overview['aura'] ?? 'Rộng mở & Bao bọc',
      auraEn: overview['aura_en'] ?? 'Open & Enveloping',
      variable: overview['variable'] ?? 'PRL - DRR',
      definedCenters: List<String>.from(rawChart['defined_centers'] ?? []),
      undefinedCenters: List<String>.from(rawChart['undefined_centers'] ?? []),
      activeChannels: List<dynamic>.from(rawChart['active_channels'] ?? []),
      activeGates: (rawChart['active_gates'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)) ?? {},
      activations: rawChart['activations'] != null ? Map<String, dynamic>.from(rawChart['activations'] as Map) : {},
      centers: rawChart['centers'] != null ? Map<String, dynamic>.from(rawChart['centers'] as Map) : {},
    );
  }
}
