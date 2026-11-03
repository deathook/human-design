import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_data.dart';
import 'hd_engine.dart';

class ApiService {
  static String baseUrl = 'http://127.0.0.1:8000';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  /// Tính toán lá số: Thử kết nối Server trước, nếu không được (offline/chạy trên điện thoại) thì tính toán ngay bằng Engine Dart cục bộ!
  static Future<ChartData> calculateChart({
    required String name,
    required String birthDate,
    required String birthTime,
    String timezone = 'Asia/Ho_Chi_Minh',
    String gender = 'Nam',
    bool isVip = false,
  }) async {
    final url = Uri.parse('$baseUrl/api/chart/calculate');
    final body = jsonEncode({
      'name': name,
      'birth_date': birthDate,
      'birth_time': birthTime,
      'timezone': timezone,
      'gender': gender,
      'is_vip': isVip,
    });

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body,
      ).timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(res.bodyBytes));
        return ChartData.fromJson(decoded);
      }
    } catch (_) {
      // Khi không kết nối được server (ví dụ trên điện thoại Android độc lập), tính toán ngay bằng Engine cục bộ!
    }

    final localChartDict = HDEngine.calculateFullChart(
      name: name,
      birthDate: birthDate,
      birthTime: birthTime,
      timezone: timezone,
    );
    return ChartData.fromJson(localChartDict);
  }

  /// Lấy thời tiết năng lượng hôm nay (Daily Transit)
  static Future<Map<String, dynamic>> getDailyTransit() async {
    final now = DateTime.now();
    final pBodies = HDEngine.calculate13Bodies(now.toUtc());
    final sunAct = pBodies['Sun']!;

    return {
      'date': '${now.day}/${now.month}/${now.year}',
      'sun_transit': {
        'gate': sunAct['gate'],
        'line': sunAct['line'],
        'name_vi': 'Cổng ${sunAct['gate']}.${sunAct['line']} (${sunAct['fix_symbol']})',
        'name_en': 'Gate ${sunAct['gate']}.${sunAct['line']} (${sunAct['fix_symbol']})',
        'high_frequency': 'Sự tỉnh thức, sống đúng chiến lược và thấu cảm tự nhiên.',
        'low_frequency': 'Áp lực tâm trí, lo âu tương lai, vội vã hành động.',
        'message': 'Mặt Trời hôm nay soi sáng Cổng ${sunAct['gate']}.${sunAct['line']}. Năng lượng hướng về sự kết nối chân thực và kiên định với bản sắc của bạn.'
      }
    };
  }

  /// Tính toán Hợp Đôi (Composite Chart) hoàn toàn offline trên điện thoại
  static Future<Map<String, dynamic>> calculateComposite({
    required String nameA,
    required String birthDateA,
    required String birthTimeA,
    required String nameB,
    required String birthDateB,
    required String birthTimeB,
  }) async {
    final chartA = HDEngine.calculateFullChart(name: nameA, birthDate: birthDateA, birthTime: birthTimeA);
    final chartB = HDEngine.calculateFullChart(name: nameB, birthDate: birthDateB, birthTime: birthTimeB);

    final gatesA = (chartA['active_gates'] as Map).keys.toSet();
    final gatesB = (chartB['active_gates'] as Map).keys.toSet();

    final electro = <Map<String, dynamic>>[];
    final comp = <Map<String, dynamic>>[];

    for (final entry in HDEngine.allChannels.entries) {
      final parts = entry.key.split('-');
      final g1 = int.parse(parts[0]);
      final g2 = int.parse(parts[1]);

      final hasFullA = gatesA.contains(g1) && gatesA.contains(g2);
      final hasFullB = gatesB.contains(g1) && gatesB.contains(g2);

      if (hasFullA && hasFullB) {
        comp.add({
          'id': entry.key,
          'name_vi': entry.value['name_vi'],
          'name_en': entry.value['name_en'],
          'description': 'Cả hai cùng sở hữu trọn vẹn kênh này, tạo nên sự đồng điệu tự nhiên không cần giải thích.'
        });
      } else if (!hasFullA && !hasFullB) {
        if ((gatesA.contains(g1) && gatesB.contains(g2)) || (gatesA.contains(g2) && gatesB.contains(g1))) {
          electro.add({
            'id': entry.key,
            'name_vi': entry.value['name_vi'],
            'name_en': entry.value['name_en'],
            'description': '$nameA giữ một cổng, $nameB giữ một cổng. Khi ở cạnh nhau, hai bạn tạo thành kênh hoàn chỉnh như nam châm hút nhau.'
          });
        }
      }
    }

    int score = 70 + electro.length * 6 + comp.length * 4;
    if (score > 98) score = 98;

    return {
      'person_a': {'name': nameA, 'type': chartA['overview']['type'], 'profile': chartA['overview']['profile']},
      'person_b': {'name': nameB, 'type': chartB['overview']['type'], 'profile': chartB['overview']['profile']},
      'compatibility_score': score,
      'center_dynamic': {
        'ratio': '8-1',
        'title': '8 - 1: Cửa Sổ Trải Nghiệm Lý Tưởng (Have Some Fun)',
        'summary': 'Hai bạn có sự gắn kết vững chãi nhưng vẫn có một khoảng mở để cùng học hỏi và đổi mới.',
        'advice': 'Tận dụng trung tâm mở để cùng nhau khám phá thế giới bên ngoài mà không làm mất đi bản sắc cá nhân.'
      },
      'channels': {
        'electromagnetic': electro,
        'companionship': comp,
        'dominance': {'${nameA}_dominant': [], '${nameB}_dominant': []},
        'compromise': {'${nameA}_compromised': [], '${nameB}_compromised': []}
      }
    };
  }
}
