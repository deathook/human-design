import 'dart:math' as math;

class LunarDate {
  final int day;
  final int month;
  final int year;
  final bool isLeap;
  final String canChiYear;
  final String napAm;

  LunarDate({
    required this.day,
    required this.month,
    required this.year,
    required this.isLeap,
    required this.canChiYear,
    required this.napAm,
  });

  @override
  String toString() {
    final leapStr = isLeap ? ' (nhuận)' : '';
    return 'Ngày $day/$month$leapStr năm $canChiYear ($napAm)';
  }
}

class LunarCalendarHelper {
  static const List<String> can = ['Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'];
  static const List<String> chi = ['Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tị', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'];

  static const Map<String, String> napAmMap = {
    'Giáp Tý': 'Hải Trung Kim', 'Ất Sửu': 'Hải Trung Kim',
    'Bính Dần': 'Lư Trung Hỏa', 'Đinh Mão': 'Lư Trung Hỏa',
    'Mậu Thìn': 'Đại Lâm Mộc', 'Kỷ Tị': 'Đại Lâm Mộc',
    'Canh Ngọ': 'Lộ Bàng Thổ', 'Tân Mùi': 'Lộ Bàng Thổ',
    'Nhâm Thân': 'Kiếm Phong Kim', 'Quý Dậu': 'Kiếm Phong Kim',
    'Giáp Tuất': 'Sơn Đầu Hỏa', 'Ất Hợi': 'Sơn Đầu Hỏa',
    'Bính Tý': 'Giản Hạ Thủy', 'Đinh Sửu': 'Giản Hạ Thủy',
    'Mậu Dần': 'Thành Đầu Thổ', 'Kỷ Mão': 'Thành Đầu Thổ',
    'Canh Thìn': 'Bạch Lạp Kim', 'Tân Tị': 'Bạch Lạp Kim',
    'Nhâm Ngọ': 'Dương Liễu Mộc', 'Quý Mùi': 'Dương Liễu Mộc',
    'Giáp Thân': 'Tuyền Trung Thủy', 'Ất Dậu': 'Tuyền Trung Thủy',
    'Bính Tuất': 'Ốc Thượng Thổ', 'Đinh Hợi': 'Ốc Thượng Thổ',
    'Mậu Tý': 'Tích Lịch Hỏa', 'Kỷ Sửu': 'Tích Lịch Hỏa',
    'Canh Dần': 'Tùng Bách Mộc', 'Tân Mão': 'Tùng Bách Mộc',
    'Nhâm Thìn': 'Trường Lưu Thủy', 'Quý Tị': 'Trường Lưu Thủy',
    'Giáp Ngọ': 'Sa Trung Kim', 'Ất Mùi': 'Sa Trung Kim',
    'Bính Thân': 'Sơn Hạ Hỏa', 'Đinh Dậu': 'Sơn Hạ Hỏa',
    'Mậu Tuất': 'Bình Địa Mộc', 'Kỷ Hợi': 'Bình Địa Mộc',
    'Canh Tý': 'Bích Thượng Thổ', 'Tân Sửu': 'Bích Thượng Thổ',
    'Nhâm Dần': 'Kim Bạch Kim', 'Quý Mão': 'Kim Bạch Kim',
    'Giáp Thìn': 'Phúc Đăng Hỏa', 'Ất Tị': 'Phúc Đăng Hỏa',
    'Bính Ngọ': 'Thiên Hà Thủy', 'Đinh Mùi': 'Thiên Hà Thủy',
    'Mậu Thân': 'Đại Trạch Thổ', 'Kỷ Dậu': 'Đại Trạch Thổ',
    'Canh Tuất': 'Thoa Xuyến Kim', 'Tân Hợi': 'Thoa Xuyến Kim',
    'Nhâm Tý': 'Tang Đố Mộc', 'Quý Sửu': 'Tang Đố Mộc',
    'Giáp Dần': 'Đại Khê Thủy', 'Ất Mão': 'Đại Khê Thủy',
    'Bính Thìn': 'Sa Trung Thổ', 'Đinh Tị': 'Sa Trung Thổ',
    'Mậu Ngọ': 'Thiên Thượng Hỏa', 'Kỷ Mùi': 'Thiên Thượng Hỏa',
    'Canh Thân': 'Thạch Lựu Mộc', 'Tân Dậu': 'Thạch Lựu Mộc',
    'Nhâm Tuất': 'Đại Hải Thủy', 'Quý Hợi': 'Đại Hải Thủy',
  };

  static String getCanChiYear(int year) {
    final c = can[(year + 6) % 10];
    final ch = chi[(year + 8) % 12];
    return '$c $ch';
  }

  static String getNapAm(String canChi) {
    return napAmMap[canChi] ?? 'Bản Mệnh';
  }

  static int jdFromDate(int dd, int mm, int yy) {
    final a = (14 - mm) ~/ 12;
    final y = yy + 4800 - a;
    final m = mm + 12 * a - 3;
    var jd = dd + ((153 * m + 2) ~/ 5) + 365 * y + (y ~/ 4) - (y ~/ 100) + (y ~/ 400) - 32045;
    if (jd < 2299161) {
      jd = dd + ((153 * m + 2) ~/ 5) + 365 * y + (y ~/ 4) - 32083;
    }
    return jd;
  }

  static int getNewMoonDay(int k, double timeZone) {
    final t = k / 1236.85;
    final t2 = t * t;
    final t3 = t2 * t;
    final dr = math.pi / 180.0;
    var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
    jd1 += 0.00033 * math.sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);
    final m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
    final mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
    final f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
    var c1 = (0.1734 - 0.000393 * t) * math.sin(m * dr) + 0.0021 * math.sin(2 * m * dr);
    c1 -= 0.4068 * math.sin(mpr * dr) + 0.0161 * math.sin(2 * mpr * dr);
    c1 -= 0.0004 * math.sin(3 * mpr * dr);
    c1 += 0.0104 * math.sin(2 * f * dr) - 0.0051 * math.sin((m + mpr) * dr);
    c1 -= 0.0074 * math.sin((m - mpr) * dr) + 0.0004 * math.sin((2 * f + m) * dr);
    c1 -= 0.0004 * math.sin((2 * f - m) * dr) - 0.0006 * math.sin((2 * f + mpr) * dr);
    c1 += 0.0010 * math.sin((2 * f - mpr) * dr) + 0.0005 * math.sin((m + 2 * mpr) * dr);
    final deltat = t < -4 ? 0.0 : (t < 0 ? (0.5 * (t + 4)) : 20.0);
    final jdNew = jd1 + c1 - deltat / 86400.0;
    return (jdNew + 0.5 + timeZone / 24.0).floor();
  }

  static int getSunLongitude(int dayNumber, double timeZone) {
    final t = (dayNumber - 0.5 - timeZone / 24.0 - 2451545.0) / 36525.0;
    final t2 = t * t;
    final dr = math.pi / 180.0;
    final l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
    final m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
    final c = (1.914600 - 0.004817 * t - 0.000014 * t2) * math.sin(m * dr) +
        (0.019993 - 0.000101 * t) * math.sin(2 * m * dr) +
        0.000290 * math.sin(3 * m * dr);
    var theta = (l0 + c) * dr;
    theta = theta - 2 * math.pi * (theta / (2 * math.pi)).floor();
    return (theta / (math.pi / 6)).floor();
  }

  static int getLunarMonth11(int yy, double timeZone) {
    final off = jdFromDate(31, 12, yy) - 2415021;
    final k = (off / 29.530588853).floor();
    var nm = getNewMoonDay(k, timeZone);
    final sunLong = getSunLongitude(nm, timeZone);
    if (sunLong >= 9) {
      nm = getNewMoonDay(k - 1, timeZone);
    }
    return nm;
  }

  static LunarDate convertSolarToLunar(int dd, int mm, int yy, [double timeZone = 7.0]) {
    final dayNumber = jdFromDate(dd, mm, yy);
    final k = ((dayNumber - 2415021.076998695) / 29.530588853).floor();
    var monthStart = getNewMoonDay(k + 1, timeZone);
    if (monthStart > dayNumber) {
      monthStart = getNewMoonDay(k, timeZone);
    }

    var a11 = getLunarMonth11(yy, timeZone);
    var b11 = a11;
    var lunarYear = yy;

    if (a11 >= monthStart) {
      lunarYear = yy;
      a11 = getLunarMonth11(yy - 1, timeZone);
    } else {
      lunarYear = yy + 1;
      b11 = getLunarMonth11(yy + 1, timeZone);
    }

    final lunarDay = dayNumber - monthStart + 1;
    final diff = ((monthStart - a11) / 29).floor();
    var lunarMonth = diff + 11;
    bool isLeap = false;

    if (b11 - a11 > 365) {
      // Tìm tháng nhuận
      final leapOff = _getLeapMonthOffset(a11, timeZone);
      if (diff >= leapOff) {
        lunarMonth = diff + 10;
        if (diff == leapOff) {
          isLeap = true;
        }
      }
    }

    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }

    final canChi = getCanChiYear(lunarYear);
    final napAm = getNapAm(canChi);

    return LunarDate(
      day: lunarDay,
      month: lunarMonth,
      year: lunarYear,
      isLeap: isLeap,
      canChiYear: canChi,
      napAm: napAm,
    );
  }

  static int _getLeapMonthOffset(int a11, double timeZone) {
    final k = ((a11 - 2415021.076998695) / 29.530588853).floor();
    var last = 0;
    var i = 1;
    var arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
    do {
      last = arc;
      i++;
      arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
    } while (arc != last && i < 14);
    return i - 1;
  }

  /// Trả về chuỗi đại chi tương ứng với giờ sinh
  static String getCanhGioString(int hour) {
    if (hour == 23 || hour == 0) return 'Giờ Tý (23:00 - 00:59)';
    if (hour >= 1 && hour < 3) return 'Giờ Sửu (01:00 - 02:59)';
    if (hour >= 3 && hour < 5) return 'Giờ Dần (03:00 - 04:59)';
    if (hour >= 5 && hour < 7) return 'Giờ Mão (05:00 - 06:59)';
    if (hour >= 7 && hour < 9) return 'Giờ Thìn (07:00 - 08:59)';
    if (hour >= 9 && hour < 11) return 'Giờ Tị (09:00 - 10:59)';
    if (hour >= 11 && hour < 13) return 'Giờ Ngọ (11:00 - 12:59)';
    if (hour >= 13 && hour < 15) return 'Giờ Mùi (13:00 - 14:59)';
    if (hour >= 15 && hour < 17) return 'Giờ Thân (15:00 - 16:59)';
    if (hour >= 17 && hour < 19) return 'Giờ Dậu (17:00 - 18:59)';
    if (hour >= 19 && hour < 21) return 'Giờ Tuất (19:00 - 20:59)';
    return 'Giờ Hợi (21:00 - 22:59)';
  }
}
