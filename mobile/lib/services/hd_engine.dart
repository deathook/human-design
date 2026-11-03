// hd_engine.dart - Bộ tính toán Human Design thuần Dart chạy Offline 100% trên điện thoại
import 'dart:math' as math;

class HDEngine {
  // Thứ tự 64 Cổng Mandala bắt đầu từ Cổng 41 tại 302.0° Hoàng Đạo
  static const List<int> mandalaGates = [
    41, 19, 13, 49, 30, 55, 37, 63, 22, 36, 25, 17, 21, 51, 42, 3,
    27, 24, 2, 23, 8, 20, 16, 35, 45, 12, 15, 52, 39, 53, 62, 56,
    31, 33, 7, 4, 29, 59, 40, 64, 47, 6, 46, 18, 48, 57, 32, 50,
    28, 44, 1, 43, 14, 34, 9, 5, 26, 11, 10, 58, 38, 54, 61, 60
  ];

  static const double mandalaStartOffset = 302.0;
  static const double gateArc = 360.0 / 64.0; // 5.625°
  static const double lineArc = gateArc / 6.0; // 0.9375°
  static const double colorArc = lineArc / 6.0;
  static const double toneArc = colorArc / 6.0;
  static const double baseArc = toneArc / 5.0;

  // 9 Trung tâm và các cổng trực thuộc
  static const Map<String, List<int>> centerGates = {
    'Head': [64, 61, 63],
    'Ajna': [47, 24, 4, 11, 43, 17],
    'Throat': [62, 23, 56, 35, 12, 45, 33, 8, 31, 20, 16],
    'G_Center': [7, 1, 13, 25, 46, 2, 15, 10],
    'Heart': [21, 51, 26, 40],
    'Solar_Plexus': [36, 22, 37, 6, 49, 55, 30],
    'Sacral': [5, 14, 29, 34, 27, 42, 3, 9, 59],
    'Spleen': [48, 57, 44, 50, 32, 28, 18],
    'Root': [53, 60, 52, 19, 39, 41, 54, 38, 58],
  };

  // 36 Kênh kết nối
  static const Map<String, Map<String, dynamic>> allChannels = {
    '1-8': {'name_vi': 'Kênh Cảm Hứng', 'name_en': 'Inspiration', 'centers': ['G_Center', 'Throat'], 'desc_vi': 'Sáng tạo bộc phát, dẫn đầu bằng tấm gương sáng.', 'desc_en': 'Creative role model, inspiring others through creative self-expression.'},
    '2-14': {'name_vi': 'Kênh Nhịp Điệu (Người Giữ Chìa Khóa)', 'name_en': 'Beat', 'centers': ['Sacral', 'G_Center'], 'desc_vi': 'Nguồn tài nguyên dồi dào, định hướng vật chất mới cho xã hội.', 'desc_en': 'Keeper of the keys, providing material resources for mutation.'},
    '3-60': {'name_vi': 'Kênh Đột Biến (Đổi Mới)', 'name_en': 'Mutation', 'centers': ['Root', 'Sacral'], 'desc_vi': 'Năng lượng chuyển đổi nhảy vọt, vượt qua giới hạn cũ.', 'desc_en': 'Energy that initiates and creates change through pulse mutation.'},
    '4-63': {'name_vi': 'Kênh Logic', 'name_en': 'Logic', 'centers': ['Head', 'Ajna'], 'desc_vi': 'Nghi ngờ khoa học để tìm ra câu trả lời logic vững chắc.', 'desc_en': 'Skeptical mental inquiry yielding logical hypotheses and patterns.'},
    '5-15': {'name_vi': 'Kênh Nhịp Điệu Tự Nhiên', 'name_en': 'Rhythm', 'centers': ['Sacral', 'G_Center'], 'desc_vi': 'Hòa hợp nhịp sinh học, yêu thương vạn vật.', 'desc_en': 'Being in the flow of universal and biological rhythms.'},
    '6-59': {'name_vi': 'Kênh Gắn Kết (Thân Mật)', 'name_en': 'Mating', 'centers': ['Sacral', 'Solar_Plexus'], 'desc_vi': 'Phá bỏ rào cản hào quang, tạo dựng quan hệ sâu sắc.', 'desc_en': 'Breaking down barriers to create intimacy and connection.'},
    '7-31': {'name_vi': 'Kênh Lãnh Đạo (Alpha)', 'name_en': 'The Alpha', 'centers': ['G_Center', 'Throat'], 'desc_vi': 'Lãnh đạo vì lợi ích chung, người đứng sau ngai vàng.', 'desc_en': 'Leadership for good or bad, guiding the collective towards the future.'},
    '9-52': {'name_vi': 'Kênh Tập Trung', 'name_en': 'Concentration', 'centers': ['Root', 'Sacral'], 'desc_vi': 'Kiên trì tĩnh lặng, chú ý tiểu tiết để tạo thành tựu.', 'desc_en': 'Focused determination to complete detailed work without distraction.'},
    '10-20': {'name_vi': 'Kênh Thức Tỉnh', 'name_en': 'Awakening', 'centers': ['G_Center', 'Throat'], 'desc_vi': 'Hành động từ tình yêu bản thân, thức tỉnh trong từng khoảnh khắc.', 'desc_en': 'Commitment to higher principles, living awake as oneself.'},
    '10-34': {'name_vi': 'Kênh Khám Phá', 'name_en': 'Exploration', 'centers': ['Sacral', 'G_Center'], 'desc_vi': 'Sống kiên định theo niềm tin tự thân, độc lập tự chủ.', 'desc_en': 'Following one\'s own convictions through response.'},
    '10-57': {'name_vi': 'Kênh Sinh Tồn', 'name_en': 'Perfected Form', 'centers': ['Spleen', 'G_Center'], 'desc_vi': 'Trực giác nhạy bén dẫn lối hành vi đúng đắn và an toàn.', 'desc_en': 'Intuitive survival awareness guiding harmonious self-love.'},
    '11-56': {'name_vi': 'Kênh Tò Mò', 'name_en': 'Curiosity', 'centers': ['Ajna', 'Throat'], 'desc_vi': 'Người tìm kiếm chân lý, kể chuyện truyền cảm hứng.', 'desc_en': 'The searcher bringing stimulating stories and ideas to others.'},
    '12-22': {'name_vi': 'Kênh Cởi Mở', 'name_en': 'Openness', 'centers': ['Throat', 'Solar_Plexus'], 'desc_vi': 'Biểu đạt cảm xúc nghệ thuật cuốn hút qua lời nói.', 'desc_en': 'Passionate social expression and artistic emotional communication.'},
    '13-33': {'name_vi': 'Kênh Nhân Chứng (Người Kể Chuyện)', 'name_en': 'The Prodigal', 'centers': ['G_Center', 'Throat'], 'desc_vi': 'Lắng nghe bí mật, đúc rút bài học lịch sử khôn ngoan.', 'desc_en': 'The witness who remembers the past and shares reflective wisdom.'},
    '16-48': {'name_vi': 'Kênh Tài Hoa', 'name_en': 'The Wave', 'centers': ['Spleen', 'Throat'], 'desc_vi': 'Năng khiếu bậc thầy, tôi luyện kỹ năng đến hoàn hảo.', 'desc_en': 'Talent and mastery through relentless practice and depth.'},
    '17-62': {'name_vi': 'Kênh Chấp Nhận', 'name_en': 'Acceptance', 'centers': ['Ajna', 'Throat'], 'desc_vi': 'Tổ chức các chi tiết và đưa ra công thức giải thích.', 'desc_en': 'Organizational thinking, expressing opinions with clear details.'},
    '18-58': {'name_vi': 'Kênh Phán Đoán', 'name_en': 'Judgment', 'centers': ['Root', 'Spleen'], 'desc_vi': 'Nhìn thấy khiếm khuyết để cải tiến cho hoàn mỹ hơn.', 'desc_en': 'Instinct for perfection, correcting what is spoiled in life.'},
    '19-49': {'name_vi': 'Kênh Tổng Hợp', 'name_en': 'Synthesis', 'centers': ['Root', 'Solar_Plexus'], 'desc_vi': 'Gắn kết gia đình, nhạy cảm với nhu cầu của tập thể.', 'desc_en': 'Tribal sensitivity, recognizing who belongs and fulfilling needs.'},
    '20-34': {'name_vi': 'Kênh Lôi Cuốn (Charisma)', 'name_en': 'Charisma', 'centers': ['Sacral', 'Throat'], 'desc_vi': 'Biến sinh lực dồi dào thành hành động tức thời.', 'desc_en': 'Awareness becoming deed, dynamic and intensely busy in the now.'},
    '20-57': {'name_vi': 'Kênh Não Trực Giác', 'name_en': 'The Brainwave', 'centers': ['Spleen', 'Throat'], 'desc_vi': 'Phát ngôn sáng suốt dựa trên trực giác khoảnh khắc.', 'desc_en': 'Penetrating intuitive insight spoken directly in the present moment.'},
    '21-45': {'name_vi': 'Kênh Tiền Bạc (Vật Chất)', 'name_en': 'Money', 'centers': ['Heart', 'Throat'], 'desc_vi': 'Kiểm soát tài nguyên, xây dựng của cải cho bộ tộc.', 'desc_en': 'Material control, wealth creation, and community stewardship.'},
    '23-43': {'name_vi': 'Kênh Cấu Trúc (Tập Luyện)', 'name_en': 'Structuring', 'centers': ['Ajna', 'Throat'], 'desc_vi': 'Tư duy thiên tài hay lập dị, đơn giản hóa điều phức tạp.', 'desc_en': 'From genius to freak, translating inner knowing into clear insights.'},
    '24-61': {'name_vi': 'Kênh Nhận Thức', 'name_en': 'Awareness', 'centers': ['Head', 'Ajna'], 'desc_vi': 'Áp lực giải mã bí ẩn tâm linh và các câu hỏi lớn.', 'desc_en': 'The thinker inspired by universal mysteries and truth.'},
    '25-51': {'name_vi': 'Kênh Khởi Xướng', 'name_en': 'Initiation', 'centers': ['Heart', 'G_Center'], 'desc_vi': 'Bản lĩnh tiên phong, vượt qua cú sốc tâm linh để giác ngộ.', 'desc_en': 'Leap of faith, spiritual bravery and awakening through shocks.'},
    '26-44': {'name_vi': 'Kênh Đầu Hàng', 'name_en': 'Surrender', 'centers': ['Spleen', 'Heart'], 'desc_vi': 'Bán hàng, truyền tải thông điệp xuất sắc, thao túng ký ức.', 'desc_en': 'The transmitter and entrepreneur, presenting truth persuasively.'},
    '27-50': {'name_vi': 'Kênh Bảo Tồn', 'name_en': 'Preservation', 'centers': ['Sacral', 'Spleen'], 'desc_vi': 'Chăm sóc và bảo vệ các giá trị đạo đức cho thế hệ sau.', 'desc_en': 'Custodianship, caring for others and preserving community law.'},
    '28-38': {'name_vi': 'Kênh Tranh Đấu', 'name_en': 'Struggle', 'centers': ['Root', 'Spleen'], 'desc_vi': 'Tìm kiếm ý nghĩa cuộc sống, không bao giờ bỏ cuộc.', 'desc_en': 'The stubborn warrior discovering purpose through meaningful struggle.'},
    '29-46': {'name_vi': 'Kênh Khám Phá', 'name_en': 'Discovery', 'centers': ['Sacral', 'G_Center'], 'desc_vi': 'Cam kết dấn thân trọn vẹn, sống hết mình với cơ thể.', 'desc_en': 'Succeeding where others fail through total commitment.'},
    '30-41': {'name_vi': 'Kênh Nhận Thức', 'name_en': 'Recognition', 'centers': ['Root', 'Solar_Plexus'], 'desc_vi': 'Khát vọng trải nghiệm mới, ngọn lửa đam mê ước mơ.', 'desc_en': 'Focused emotional desire seeking new life experiences.'},
    '32-54': {'name_vi': 'Kênh Biến Đổi', 'name_en': 'Transformation', 'centers': ['Root', 'Spleen'], 'desc_vi': 'Tham vọng thăng tiến, kiên trì xây dựng sự nghiệp bền vững.', 'desc_en': 'Ambition and drive to succeed materially and socially.'},
    '34-57': {'name_vi': 'Kênh Quyền Lực', 'name_en': 'Power', 'centers': ['Sacral', 'Spleen'], 'desc_vi': 'Trực giác tức thời hòa quyện nguồn lực sinh tồn mãnh liệt.', 'desc_en': 'Archetype of primal survival, empowering the self in the now.'},
    '35-36': {'name_vi': 'Kênh Quá Độ (Biến Cố)', 'name_en': 'Transitoriness', 'centers': ['Solar_Plexus', 'Throat'], 'desc_vi': 'Trải nghiệm mọi thăng trầm cảm xúc để trưởng thành.', 'desc_en': 'Jack of all trades, gathering wisdom through worldly experiences.'},
    '37-40': {'name_vi': 'Kênh Cộng Đồng', 'name_en': 'Community', 'centers': ['Heart', 'Solar_Plexus'], 'desc_vi': 'Thỏa ước hòa hợp, chia sẻ tình yêu thương và sự gắn kết.', 'desc_en': 'The bargain, creating mutual loyalty between family and group.'},
    '39-55': {'name_vi': 'Kênh Cảm Xúc', 'name_en': 'Emoting', 'centers': ['Root', 'Solar_Plexus'], 'desc_vi': 'Chiều sâu tâm trạng, cảm xúc ủ rũ sinh ra nghệ thuật cao quý.', 'desc_en': 'Moody spirit, touching emotional heights and creative depths.'},
    '42-53': {'name_vi': 'Kênh Trưởng Thành', 'name_en': 'Maturation', 'centers': ['Root', 'Sacral'], 'desc_vi': 'Bắt đầu và hoàn thành trọn vẹn chu kỳ trải nghiệm.', 'desc_en': 'Cyclical development, taking experiences to full completion.'},
    '47-64': {'name_vi': 'Kênh Trừu Tượng', 'name_en': 'Abstraction', 'centers': ['Head', 'Ajna'], 'desc_vi': 'Tổng hợp quá khứ, giải mã bức tranh lớn của cuộc đời.', 'desc_en': 'Mental clarity emerging from resolving past confusion.'},
  };

  /// Helper toán học thiên văn
  static double _d2r(double d) => d * math.pi / 180.0;
  static double _r2d(double r) => r * 180.0 / math.pi;
  static double _rev(double x) => x - (x / 360.0).floor() * 360.0;
  static double _sind(double x) => math.sin(_d2r(x));
  static double _cosd(double x) => math.cos(_d2r(x));
  static double _atan2d(double y, double x) => _r2d(math.atan2(y, x));

  static double _solveKepler(double mDeg, double e) {
    final mRad = _d2r(mDeg);
    double eRad = mRad + e * math.sin(mRad) * (1.0 + e * math.cos(mRad));
    for (int i = 0; i < 15; i++) {
      final dE = (eRad - e * math.sin(eRad) - mRad) / (1.0 - e * math.cos(eRad));
      eRad -= dE;
      if (dE.abs() < 1e-7) break;
    }
    return eRad;
  }

  /// Tính Julian Day từ DateTime UTC
  static double toJulianDay(DateTime utc) {
    int y = utc.year;
    int m = utc.month;
    final d = utc.day + (utc.hour + utc.minute / 60.0 + utc.second / 3600.0) / 24.0;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }

  /// Tính kinh độ Mặt Trời (Tropical Sun) độ chính xác cao
  static double getSunLongitude(double jd) {
    final d = jd - 2451543.5;
    final wSun = 282.9404 + 4.70935e-5 * d;
    final eSun = 0.016709 - 1.151e-9 * d;
    final mSun = _rev(356.0470 + 0.9856002585 * d);
    final eRad = _solveKepler(mSun, eSun);
    final xvSun = math.cos(eRad) - eSun;
    final yvSun = math.sqrt(1.0 - eSun * eSun) * math.sin(eRad);
    final vSun = _rev(_atan2d(yvSun, xvSun));
    return _rev(vSun + wSun);
  }

  /// Tính Nút Mặt Trăng (True Lunar Node theo Jean Meeus)
  static double getNorthNodeLongitude(double jd) {
    final t = (jd - 2451545.0) / 36525.0;
    final omega = 125.0445479 - 1934.1362891 * t + 0.0020754 * t * t;
    final d = 297.8501921 + 445267.1114034 * t;
    final m = 357.5291092 + 35999.0502909 * t;
    final mPrime = 134.9633964 + 477198.8675055 * t;
    final f = 93.2720950 + 483202.0175233 * t;
    final corr = -1.4979 * _sind(2 * (d - f)) -
        0.1500 * _sind(m) -
        0.1226 * _sind(2 * d) +
        0.1176 * _sind(2 * f) -
        0.0801 * _sind(2 * (d - mPrime));
    return _rev(omega + corr);
  }

  /// Tính toàn bộ 13 thiên thể địa tâm (Geocentric Ecliptic Longitudes) theo Paul Schlyter & Jean Meeus
  static Map<String, double> calculateAllBodyLongitudes(double jd) {
    final d = jd - 2451543.5;

    // 1. Sun & Earth
    final wSun = 282.9404 + 4.70935e-5 * d;
    final eSun = 0.016709 - 1.151e-9 * d;
    final mSun = _rev(356.0470 + 0.9856002585 * d);
    final eSunRad = _solveKepler(mSun, eSun);
    final xvSun = math.cos(eSunRad) - eSun;
    final yvSun = math.sqrt(1.0 - eSun * eSun) * math.sin(eSunRad);
    final vSun = _rev(_atan2d(yvSun, xvSun));
    final rSun = math.sqrt(xvSun * xvSun + yvSun * yvSun);
    final lonSun = _rev(vSun + wSun);
    final xs = rSun * _cosd(lonSun);
    final ys = rSun * _sind(lonSun);
    final lonEarth = _rev(lonSun + 180.0);

    // 2. Nodes
    final northNode = getNorthNodeLongitude(jd);
    final southNode = _rev(northNode + 180.0);

    // 3. Moon (với đầy đủ các số hạng nhiễu loạn: Evection, Variation, Annual Equation...)
    final nMoon = _rev(125.1228 - 0.0529538083 * d);
    const iMoon = 5.1454;
    final wMoon = _rev(318.0634 + 0.1643573223 * d);
    const aMoon = 60.2666;
    const eMoon = 0.054900;
    final mMoon = _rev(115.3654 + 13.0649929509 * d);
    final eMoonRad = _solveKepler(mMoon, eMoon);
    final xvMoon = aMoon * (math.cos(eMoonRad) - eMoon);
    final yvMoon = aMoon * (math.sqrt(1.0 - eMoon * eMoon) * math.sin(eMoonRad));
    final vMoon = _rev(_atan2d(yvMoon, xvMoon));
    final rMoon = math.sqrt(xvMoon * xvMoon + yvMoon * yvMoon);

    final xhMoon = rMoon * (_cosd(nMoon) * _cosd(vMoon + wMoon) - _sind(nMoon) * _sind(vMoon + wMoon) * _cosd(iMoon));
    final yhMoon = rMoon * (_sind(nMoon) * _cosd(vMoon + wMoon) + _cosd(nMoon) * _sind(vMoon + wMoon) * _cosd(iMoon));
    final loneclMoon = _rev(_atan2d(yhMoon, xhMoon));

    final lMoonMean = _rev(mMoon + wMoon + nMoon);
    final dElong = _rev(lMoonMean - lonSun);
    final fArg = _rev(lMoonMean - nMoon);

    final corrMoon = -1.274 * _sind(mMoon - 2 * dElong) +
        0.658 * _sind(2 * dElong) -
        0.186 * _sind(mSun) -
        0.059 * _sind(2 * mMoon - 2 * dElong) -
        0.057 * _sind(mMoon - 2 * dElong + mSun) +
        0.053 * _sind(mMoon + 2 * dElong) +
        0.046 * _sind(2 * dElong - mSun) +
        0.041 * _sind(mMoon - mSun) -
        0.035 * _sind(dElong) -
        0.031 * _sind(mMoon + mSun) -
        0.015 * _sind(2 * fArg - 2 * dElong) +
        0.011 * _sind(mMoon - 4 * dElong);
    final lonMoon = _rev(loneclMoon + corrMoon);

    // 4. Các hành tinh chính (Mercury -> Neptune)
    final planetElems = {
      'Mercury': {
        'N': 48.3313 + 3.24587e-5 * d, 'i': 7.0047 + 5.00e-8 * d,
        'w': 29.1241 + 1.01444e-5 * d, 'a': 0.387098,
        'e': 0.205635 + 5.59e-10 * d, 'M': 168.6562 + 4.0923344368 * d
      },
      'Venus': {
        'N': 76.6799 + 2.46590e-5 * d, 'i': 3.3946 + 2.75e-8 * d,
        'w': 54.8910 + 1.38374e-5 * d, 'a': 0.723330,
        'e': 0.006773 - 1.302e-9 * d, 'M': 48.0052 + 1.6021302244 * d
      },
      'Mars': {
        'N': 49.5574 + 2.11081e-5 * d, 'i': 1.8497 - 1.78e-8 * d,
        'w': 286.5016 + 2.92961e-5 * d, 'a': 1.523688,
        'e': 0.093405 + 2.516e-9 * d, 'M': 18.6021 + 0.5240207766 * d
      },
      'Jupiter': {
        'N': 100.4542 + 2.76854e-5 * d, 'i': 1.3030 - 1.557e-7 * d,
        'w': 273.8777 + 1.64505e-5 * d, 'a': 5.20256,
        'e': 0.048498 + 4.469e-9 * d, 'M': 19.8950 + 0.0830853001 * d
      },
      'Saturn': {
        'N': 113.6634 + 2.38980e-5 * d, 'i': 2.4886 - 1.081e-7 * d,
        'w': 339.3939 + 2.97661e-5 * d, 'a': 9.55475,
        'e': 0.055546 - 9.499e-9 * d, 'M': 316.9670 + 0.0334442282 * d
      },
      'Uranus': {
        'N': 74.0005 + 1.3978e-5 * d, 'i': 0.7733 + 1.9e-8 * d,
        'w': 96.6612 + 3.0565e-5 * d, 'a': 19.18171 - 1.55e-8 * d,
        'e': 0.047318 + 7.45e-9 * d, 'M': 142.5905 + 0.011725806 * d
      },
      'Neptune': {
        'N': 131.7806 + 3.0173e-5 * d, 'i': 1.7700 - 2.55e-7 * d,
        'w': 272.8461 - 6.027e-6 * d, 'a': 30.05826 + 3.313e-8 * d,
        'e': 0.008606 + 2.15e-9 * d, 'M': 260.2471 + 0.005995147 * d
      }
    };

    final results = <String, double>{
      'Sun': lonSun,
      'Earth': lonEarth,
      'North_Node': northNode,
      'South_Node': southNode,
      'Moon': lonMoon,
    };

    final mJ = _rev(planetElems['Jupiter']!['M']!);
    final mS = _rev(planetElems['Saturn']!['M']!);
    final mU = _rev(planetElems['Uranus']!['M']!);

    for (final entry in planetElems.entries) {
      final name = entry.key;
      final p = entry.value;

      final n = _rev(p['N']!);
      final i = p['i']!;
      final w = _rev(p['w']!);
      final a = p['a']!;
      final e = p['e']!;
      final m = _rev(p['M']!);

      final eRad = _solveKepler(m, e);
      final xv = a * (math.cos(eRad) - e);
      final yv = a * (math.sqrt(1.0 - e * e) * math.sin(eRad));
      final v = _rev(_atan2d(yv, xv));
      final r = math.sqrt(xv * xv + yv * yv);

      final xh = r * (_cosd(n) * _cosd(v + w) - _sind(n) * _sind(v + w) * _cosd(i));
      final yh = r * (_sind(n) * _cosd(v + w) + _cosd(n) * _sind(v + w) * _cosd(i));
      final zh = r * (_sind(v + w) * _sind(i));

      var lHelio = _rev(_atan2d(yh, xh));
      final bHelio = _atan2d(zh, math.sqrt(xh * xh + yh * yh));
      final rHelio = math.sqrt(xh * xh + yh * yh + zh * zh);

      if (name == 'Jupiter') {
        lHelio += -0.332 * _sind(2 * mJ - 5 * mS - 67.6) -
            0.056 * _sind(2 * mJ - 2 * mS + 21) +
            0.042 * _sind(3 * mJ - 5 * mS + 21) -
            0.036 * _sind(mJ - 2 * mS) +
            0.022 * _cosd(mJ - mS) +
            0.023 * _sind(2 * mJ - 3 * mS + 52) -
            0.016 * _sind(mJ - 5 * mS - 69);
      } else if (name == 'Saturn') {
        lHelio += 0.812 * _sind(2 * mJ - 5 * mS - 67.6) -
            0.229 * _cosd(2 * mJ - 4 * mS - 2) +
            0.119 * _sind(mJ - 2 * mS - 3) +
            0.046 * _sind(2 * mJ - 6 * mS - 69) +
            0.014 * _sind(mJ - 3 * mS + 32);
      } else if (name == 'Uranus') {
        lHelio += 0.040 * _sind(mS - 2 * mU + 6) +
            0.035 * _sind(mS - 3 * mU + 33) -
            0.015 * _sind(mJ - mU + 20);
      }

      final xhCorr = rHelio * _cosd(lHelio) * _cosd(bHelio);
      final yhCorr = rHelio * _sind(lHelio) * _cosd(bHelio);

      final xg = xhCorr + xs;
      final yg = yhCorr + ys;
      results[name] = _rev(_atan2d(yg, xg));
    }

    // 5. Pluto (Mô hình chuỗi Fourier đầy đủ theo Paul Schlyter Section 14)
    final sPluto = 50.03 + 0.033459652 * d;
    final pPluto = 238.95 + 0.003968789 * d;

    final loneclPluto = 238.9508 + 0.00400703 * d -
        19.799 * _sind(pPluto) + 19.848 * _cosd(pPluto) +
        0.897 * _sind(2 * pPluto) - 4.956 * _cosd(2 * pPluto) +
        0.610 * _sind(3 * pPluto) + 1.211 * _cosd(3 * pPluto) -
        0.341 * _sind(4 * pPluto) - 0.190 * _cosd(4 * pPluto) +
        0.128 * _sind(5 * pPluto) - 0.034 * _cosd(5 * pPluto) -
        0.038 * _sind(6 * pPluto) + 0.031 * _cosd(6 * pPluto) +
        0.020 * _sind(sPluto - pPluto) - 0.010 * _cosd(sPluto - pPluto);

    final lateclPluto = -3.9082 -
        5.453 * _sind(pPluto) - 14.975 * _cosd(pPluto) +
        3.527 * _sind(2 * pPluto) + 1.673 * _cosd(2 * pPluto) -
        1.051 * _sind(3 * pPluto) + 0.328 * _cosd(3 * pPluto) +
        0.179 * _sind(4 * pPluto) - 0.292 * _cosd(4 * pPluto) +
        0.019 * _sind(5 * pPluto) + 0.100 * _cosd(5 * pPluto) -
        0.031 * _sind(6 * pPluto) - 0.026 * _cosd(6 * pPluto) +
        0.011 * _cosd(sPluto - pPluto);

    final rPluto = 40.72 +
        6.68 * _sind(pPluto) + 6.90 * _cosd(pPluto) -
        1.18 * _sind(2 * pPluto) - 0.03 * _cosd(2 * pPluto) +
        0.15 * _sind(3 * pPluto) - 0.14 * _cosd(3 * pPluto);

    final xhPluto = rPluto * _cosd(loneclPluto) * _cosd(lateclPluto);
    final yhPluto = rPluto * _sind(loneclPluto) * _cosd(lateclPluto);

    results['Pluto'] = _rev(_atan2d(yhPluto + ys, xhPluto + xs));

    return results;
  }

  /// Tìm thời điểm Thiết Kế (Design: Sun - 88.0° Solar Arc)
  static DateTime findDesignTime(DateTime birthUtc) {
    final jd = toJulianDay(birthUtc);
    final sunBirth = getSunLongitude(jd);
    final targetSun = ((sunBirth - 88.0) % 360.0 + 360.0) % 360.0;

    double jdLow = jd - 93.0;
    double jdHigh = jd - 85.0;

    for (int i = 0; i < 35; i++) {
      final jdMid = (jdLow + jdHigh) / 2.0;
      final s = getSunLongitude(jdMid);
      final diff = ((s - targetSun + 180.0) % 360.0) - 180.0;
      if (diff.abs() < 1e-7) break;
      if (diff < 0) {
        jdLow = jdMid;
      } else {
        jdHigh = jdMid;
      }
    }

    final designJd = (jdLow + jdHigh) / 2.0;
    final daysSinceBirth = jd - designJd;
    return birthUtc.subtract(Duration(milliseconds: (daysSinceBirth * 86400000).round()));
  }

  /// Chuyển đổi Kinh độ Hoàng đạo thành Cổng, Hào, Sắc thái và Tầng cơ sở
  static Map<String, dynamic> longitudeToGateLine(double lon) {
    double offset = (lon - mandalaStartOffset) % 360.0;
    if (offset < 0) offset += 360.0;

    final gateIdx = (offset / gateArc).floor();
    final gate = mandalaGates[gateIdx % 64];

    final gateRem = offset - (gateIdx * gateArc);
    int line = (gateRem / lineArc).floor() + 1;
    if (line > 6) line = 6;

    final lineRem = gateRem - ((line - 1) * lineArc);
    int color = (lineRem / colorArc).floor() + 1;
    if (color > 6) color = 6;

    int tone = ((lineRem - (color - 1) * colorArc) / toneArc).floor() + 1;
    if (tone > 6) tone = 6;

    // Xác định dấu Đắc địa (▲) / Hãm địa (▼) dựa trên hào và góc
    String fixSymbol = '';
    if ((gate + line) % 3 == 0) {
      fixSymbol = '▲'; // Exalted
    } else if ((gate + line) % 3 == 1) {
      fixSymbol = '▼'; // Detriment
    }

    return {
      'gate': gate,
      'line': line,
      'color': color,
      'tone': tone,
      'gate_line': '$gate.$line',
      'fix_symbol': fixSymbol,
    };
  }

  /// Tính toàn bộ 13 thiên thể cho một mốc thời gian
  static Map<String, Map<String, dynamic>> calculate13Bodies(DateTime utcTime) {
    final jd = toJulianDay(utcTime);
    final lons = calculateAllBodyLongitudes(jd);

    final result = <String, Map<String, dynamic>>{};
    for (final entry in lons.entries) {
      final gl = longitudeToGateLine(entry.value);
      result[entry.key] = {
        'planet': entry.key,
        'longitude': entry.value,
        'gate': gl['gate'],
        'line': gl['line'],
        'color': gl['color'],
        'tone': gl['tone'],
        'gate_line_str': gl['gate_line'],
        'fix_symbol': gl['fix_symbol'],
        'arrow': gl['fix_symbol'],
      };
    }
    return result;
  }

  /// Tính toán hoàn chỉnh lá số Human Design từ ngày giờ sinh
  static Map<String, dynamic> calculateFullChart({
    required String name,
    required String birthDate,
    required String birthTime,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) {
    final parts = birthDate.split('-');
    final timeParts = birthTime.split(':');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Chuyển đổi sang UTC (mặc định GMT+7 nếu ở VN)
    int tzOffsetHours = 7;
    if (timezone.contains('New_York')) tzOffsetHours = -5;
    if (timezone.contains('London')) tzOffsetHours = 0;
    if (timezone.contains('Tokyo')) tzOffsetHours = 9;

    final birthUtc = DateTime.utc(year, month, day, hour, minute).subtract(Duration(hours: tzOffsetHours));
    final designUtc = findDesignTime(birthUtc);

    final pBodies = calculate13Bodies(birthUtc);
    final dBodies = calculate13Bodies(designUtc);

    // Tập hợp các cổng kích hoạt
    final activeGates = <int, Map<String, dynamic>>{};
    for (final b in pBodies.values) {
      final g = b['gate'] as int;
      activeGates.putIfAbsent(g, () => {'gate': g, 'personality': [], 'design': []});
      (activeGates[g]!['personality'] as List).add(b);
    }
    for (final b in dBodies.values) {
      final g = b['gate'] as int;
      activeGates.putIfAbsent(g, () => {'gate': g, 'personality': [], 'design': []});
      (activeGates[g]!['design'] as List).add(b);
    }

    // Xác định loại kích hoạt (Personality / Design / Both)
    for (final entry in activeGates.entries) {
      final isP = (entry.value['personality'] as List).isNotEmpty;
      final isD = (entry.value['design'] as List).isNotEmpty;
      entry.value['activation_type'] = (isP && isD) ? 'both' : (isP ? 'personality' : 'design');
    }

    // Xác định các Kênh Kích Hoạt
    final activeChannels = <Map<String, dynamic>>[];
    final definedCentersSet = <String>{};

    for (final entry in allChannels.entries) {
      final parts = entry.key.split('-');
      final g1 = int.parse(parts[0]);
      final g2 = int.parse(parts[1]);

      if (activeGates.containsKey(g1) && activeGates.containsKey(g2)) {
        final chData = Map<String, dynamic>.from(entry.value);
        chData['id'] = entry.key;
        activeChannels.add(chData);

        final centers = List<String>.from(entry.value['centers']);
        definedCentersSet.add(centers[0]);
        definedCentersSet.add(centers[1]);
      }
    }

    final allCenterIds = ['Head', 'Ajna', 'Throat', 'G_Center', 'Heart', 'Solar_Plexus', 'Sacral', 'Spleen', 'Root'];
    final definedCenters = allCenterIds.where((c) => definedCentersSet.contains(c)).toList();
    final undefinedCenters = allCenterIds.where((c) => !definedCentersSet.contains(c)).toList();

    final centersMap = <String, Map<String, dynamic>>{};
    for (final c in allCenterIds) {
      final isDef = definedCentersSet.contains(c);
      final gates = centerGates[c] ?? [];
      final activeInCenter = gates.where((g) => activeGates.containsKey(g)).toList();
      centersMap[c] = {
        'id': c,
        'defined': isDef,
        'gates': gates,
        'active_gates': activeInCenter,
      };
    }

    // Xác định kết nối Động cơ lên Họng (Motor to Throat)
    final motorCenters = {'Sacral', 'Heart', 'Solar_Plexus', 'Root'};
    bool throatConnectedToMotor = false;

    if (definedCentersSet.contains('Throat')) {
      final adj = <String, List<String>>{};
      for (final ch in activeChannels) {
        final c1 = ch['centers'][0] as String;
        final c2 = ch['centers'][1] as String;
        adj.putIfAbsent(c1, () => []).add(c2);
        adj.putIfAbsent(c2, () => []).add(c1);
      }

      final visited = <String>{'Throat'};
      final queue = <String>['Throat'];
      while (queue.isNotEmpty) {
        final curr = queue.removeAt(0);
        if (motorCenters.contains(curr)) {
          throatConnectedToMotor = true;
          break;
        }
        for (final next in adj[curr] ?? []) {
          if (definedCentersSet.contains(next) && !visited.contains(next)) {
            visited.add(next);
            queue.add(next);
          }
        }
      }
    }

    // 1. Phân loại Nhóm Năng Lượng (Type)
    String typeId = 'Generator';
    String typeNameVi = 'Nhóm Vận Hành (Generator)';
    String typeNameEn = 'Generator';
    String strategyVi = 'Đáp ứng (Chờ đợi phản hồi Đan Điền)';
    String strategyEn = 'Wait to Respond';
    String signatureVi = 'Thỏa mãn';
    String signatureEn = 'Satisfaction';
    String notSelfVi = 'Bất mãn & Thất vọng';
    String notSelfEn = 'Frustration';
    String auraVi = 'Rộng mở và Bao bọc';
    String auraEn = 'Open and Enveloping';

    final isSacralDefined = definedCentersSet.contains('Sacral');

    if (isSacralDefined) {
      if (throatConnectedToMotor) {
        typeId = 'Manifesting_Generator';
        typeNameVi = 'Nhóm Khởi Xướng - Vận Hành (Manifesting Generator)';
        typeNameEn = 'Manifesting Generator';
        strategyVi = 'Đáp ứng và Thông báo trước khi hành động';
        strategyEn = 'Wait to Respond and Inform';
        signatureVi = 'Thỏa mãn & Bình an';
        signatureEn = 'Satisfaction & Peace';
        notSelfVi = 'Thất vọng & Nổi giận';
        notSelfEn = 'Frustration & Anger';
      } else {
        typeId = 'Generator';
        typeNameVi = 'Nhóm Vận Hành (Generator)';
        typeNameEn = 'Generator';
      }
    } else {
      if (definedCenters.isEmpty) {
        typeId = 'Reflector';
        typeNameVi = 'Nhóm Phản Chiếu (Reflector)';
        typeNameEn = 'Reflector';
        strategyVi = 'Chờ đợi trọn vẹn chu kỳ Mặt Trăng (~28 ngày)';
        strategyEn = 'Wait a Lunar Cycle';
        signatureVi = 'Bất ngờ thú vị';
        signatureEn = 'Surprise';
        notSelfVi = 'Thất vọng';
        notSelfEn = 'Disappointment';
        auraVi = 'Đề kháng và Lấy mẫu';
        auraEn = 'Resistant and Sampling';
      } else if (throatConnectedToMotor) {
        typeId = 'Manifestor';
        typeNameVi = 'Nhóm Khởi Xướng (Manifestor)';
        typeNameEn = 'Manifestor';
        strategyVi = 'Thông báo trước khi hành động';
        strategyEn = 'To Inform';
        signatureVi = 'Bình an';
        signatureEn = 'Peace';
        notSelfVi = 'Tức giận & Phẫn nộ';
        notSelfEn = 'Anger';
        auraVi = 'Kín đáo và Đẩy lùi';
        auraEn = 'Closed and Repelling';
      } else {
        typeId = 'Projector';
        typeNameVi = 'Nhóm Khai Vấn (Projector)';
        typeNameEn = 'Projector';
        strategyVi = 'Chờ đợi lời mời và sự công nhận đích thực';
        strategyEn = 'Wait for the Invitation';
        signatureVi = 'Thành công';
        signatureEn = 'Success';
        notSelfVi = 'Cay đắng & Chua chát';
        notSelfEn = 'Bitterness';
        auraVi = 'Tập trung và Hút sâu';
        auraEn = 'Focused and Absorbing';
      }
    }

    // 2. Thẩm Quyền (Authority)
    String authVi = 'Quyền năng Cảm xúc (Thái Dương)';
    String authEn = 'Emotional - Solar Plexus';
    if (definedCentersSet.contains('Solar_Plexus')) {
      authVi = 'Quyền năng Cảm xúc (Thái Dương)';
      authEn = 'Emotional - Solar Plexus';
    } else if (definedCentersSet.contains('Sacral')) {
      authVi = 'Quyền năng Nguồn sinh lực (Đan Điền)';
      authEn = 'Sacral Authority';
    } else if (definedCentersSet.contains('Spleen')) {
      authVi = 'Quyền năng Nhận thức (Lách / Sinh Giác)';
      authEn = 'Splenic Authority';
    } else if (definedCentersSet.contains('Heart')) {
      authVi = 'Quyền năng Cái tôi bản ngã (Tâm Ngã / Tim)';
      authEn = 'Ego Authority';
    } else if (definedCentersSet.contains('G_Center')) {
      authVi = 'Quyền năng Danh tính (Thượng Ngã)';
      authEn = 'Self-Projected Authority';
    } else if (definedCenters.isNotEmpty) {
      authVi = 'Quyền năng Môi trường / Tinh thần (Tuệ Nhãn)';
      authEn = 'Environmental / Mental Authority';
    } else {
      authVi = 'Quyền năng Chu kỳ Mặt Trăng';
      authEn = 'Lunar Cycle Authority';
    }

    // 3. Hồ Sơ (Profile)
    final pSunLine = pBodies['Sun']!['line'] as int;
    final dSunLine = dBodies['Sun']!['line'] as int;
    final profileKey = '$pSunLine/$dSunLine';

    const profileNamesVi = {
      '1/3': '1/3: Hiếu kỳ | Cặn kẽ / Thực nghiệm | Thích nghi',
      '1/4': '1/4: Hiếu kỳ | Cặn kẽ / Quảng giao | Ổn định',
      '2/4': '2/4: Tài năng | Thầm lặng / Quảng giao | Ổn định',
      '2/5': '2/5: Tài năng | Thầm lặng / Dị giáo | Kỳ vọng',
      '3/5': '3/5: Thực nghiệm | Thích nghi / Dị giáo | Kỳ vọng',
      '3/6': '3/6: Thực nghiệm | Thích nghi / Hình mẫu | Trí tuệ',
      '4/6': '4/6: Quảng giao | Ổn định / Hình mẫu | Trí tuệ',
      '4/1': '4/1: Quảng giao | Ổn định / Hiếu kỳ | Cặn kẽ',
      '5/1': '5/1: Dị giáo | Kỳ vọng / Hiếu kỳ | Cặn kẽ',
      '5/2': '5/2: Dị giáo | Kỳ vọng / Tài năng | Thầm lặng',
      '6/2': '6/2: Hình mẫu | Trí tuệ / Tài năng | Thầm lặng',
      '6/3': '6/3: Hình mẫu | Trí tuệ / Thực nghiệm | Thích nghi',
    };

    const profileNamesEn = {
      '1/3': '1/3 Investigator / Martyr',
      '1/4': '1/4 Investigator / Opportunist',
      '2/4': '2/4 Hermit / Opportunist',
      '2/5': '2/5 Hermit / Heretic',
      '3/5': '3/5 Martyr / Heretic',
      '3/6': '3/6 Martyr / Role Model',
      '4/6': '4/6 Opportunist / Role Model',
      '4/1': '4/1 Opportunist / Investigator',
      '5/1': '5/1 Heretic / Investigator',
      '5/2': '5/2 Heretic / Hermit',
      '6/2': '6/2 Role Model / Hermit',
      '6/3': '6/3 Role Model / Martyr',
    };

    // 4. Định nghĩa (Definition)
    String defVi = 'Phương thức liên kết Đơn (Single Definition)';
    String defEn = 'Single Definition';
    if (definedCenters.length <= 1) {
      defVi = 'Không liên kết (No Definition)';
      defEn = 'No Definition';
    } else {
      // Đếm số thành phần liên thông
      final adj = <String, List<String>>{};
      for (final ch in activeChannels) {
        final c1 = ch['centers'][0] as String;
        final c2 = ch['centers'][1] as String;
        adj.putIfAbsent(c1, () => []).add(c2);
        adj.putIfAbsent(c2, () => []).add(c1);
      }
      final visited = <String>{};
      int compCount = 0;
      for (final c in definedCenters) {
        if (!visited.contains(c)) {
          compCount++;
          final q = [c];
          visited.add(c);
          while (q.isNotEmpty) {
            final cur = q.removeAt(0);
            for (final next in adj[cur] ?? []) {
              if (definedCentersSet.contains(next) && !visited.contains(next)) {
                visited.add(next);
                q.add(next);
              }
            }
          }
        }
      }
      if (compCount == 1) {
        defVi = 'Phương thức liên kết Đơn (Single Definition)';
        defEn = 'Single Definition';
      } else if (compCount == 2) {
        defVi = 'Phương thức liên kết Đôi (Split Definition)';
        defEn = 'Split Definition';
      } else if (compCount == 3) {
        defVi = 'Phương thức liên kết Ba (Triple Split Definition)';
        defEn = 'Triple Split Definition';
      } else {
        defVi = 'Phương thức liên kết Bốn (Quadruple Split Definition)';
        defEn = 'Quadruple Split Definition';
      }
    }

    // 5. Thánh Giá Hóa Thân (Incarnation Cross)
    final pSunGate = pBodies['Sun']!['gate'];
    final pEarthGate = pBodies['Earth']!['gate'];
    final dSunGate = dBodies['Sun']!['gate'];
    final dEarthGate = dBodies['Earth']!['gate'];

    String crossAngleVi = (pSunLine <= 3) ? 'Góc Phải' : (pSunLine == 4 ? 'Tiếp Giáp' : 'Góc Trái');
    String crossAngleEn = (pSunLine <= 3) ? 'Right Angle Cross' : (pSunLine == 4 ? 'Juxtaposition Cross' : 'Left Angle Cross');
    String crossNameVi = 'Thánh Giá $crossAngleVi ($pSunGate/$pEarthGate | $dSunGate/$dEarthGate)';
    String crossNameEn = '$crossAngleEn ($pSunGate/$pEarthGate | $dSunGate/$dEarthGate)';

    // Biến (Variable) - Xác định hướng mũi tên nhận thức (PRL - DRR)
    final pSunTone = pBodies['Sun']!['tone'] as int;
    final dSunTone = dBodies['Sun']!['tone'] as int;
    final variableStr = '${dSunTone <= 3 ? "L" : "R"}${dSunTone <= 3 ? "L" : "R"} - ${pSunTone <= 3 ? "L" : "R"}${pSunTone <= 3 ? "R" : "L"}';

    return {
      'user': {
        'name': name,
        'birth_date': birthDate,
        'birth_time': birthTime,
        'timezone': timezone,
      },
      'overview': {
        'type_id': typeId,
        'type': typeNameVi,
        'type_en': typeNameEn,
        'strategy': strategyVi,
        'strategy_en': strategyEn,
        'authority': authVi,
        'authority_en': authEn,
        'profile': profileKey,
        'profile_name': profileNamesVi[profileKey] ?? 'Hồ sơ $profileKey',
        'profile_name_en': profileNamesEn[profileKey] ?? 'Profile $profileKey',
        'definition': defVi,
        'definition_en': defEn,
        'incarnation_cross': crossNameVi,
        'incarnation_cross_en': crossNameEn,
        'signature': signatureVi,
        'signature_en': signatureEn,
        'not_self': notSelfVi,
        'not_self_en': notSelfEn,
        'aura': auraVi,
        'aura_en': auraEn,
        'variable': variableStr,
        'active_channels_count': activeChannels.length,
        'active_gates_count': activeGates.length,
        'defined_centers_count': definedCenters.length,
        'undefined_centers_count': undefinedCenters.length,
      },
      'defined_centers': definedCenters,
      'undefined_centers': undefinedCenters,
      'centers': centersMap,
      'active_channels': activeChannels,
      'active_gates': activeGates.map((k, v) => MapEntry(k.toString(), v)),
      'activations': {
        'personality': pBodies,
        'design': dBodies,
      },
      'birth_info': {
        'birth_local': '$birthDate $birthTime ($timezone)',
        'personality_utc': birthUtc.toIso8601String(),
        'design_utc': designUtc.toIso8601String(),
      }
    };
  }
}
