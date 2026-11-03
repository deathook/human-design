import 'dart:math' as math;
import 'package:flutter/material.dart';

class BodygraphView extends StatelessWidget {
  final List<String> definedCenters;
  final List<dynamic> activeChannels;
  final Map<String, dynamic> activeGates;
  final String variable;
  final Function(String centerId)? onCenterTap;
  final VoidCallback? onDoubleTapOrExpand;

  const BodygraphView({
    super.key,
    required this.definedCenters,
    required this.activeChannels,
    required this.activeGates,
    this.variable = 'PRL - DRR',
    this.onCenterTap,
    this.onDoubleTapOrExpand,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Tỷ lệ chuẩn mực 360 x 540 (Bodygraph mở rộng tối đa chiều ngang)
        final height = constraints.maxHeight.isFinite ? constraints.maxHeight : width * (540.0 / 360.0);

        return GestureDetector(
          onTapUp: (details) {
            final centerId = _detectCenterTap(details.localPosition, width, height);
            if (centerId != null) {
              onCenterTap?.call(centerId);
            } else {
              onDoubleTapOrExpand?.call();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEFF6FF), // Xanh trời nhạt tinh tế
                  Color(0xFFF8FAFC), // Trắng ngà thanh lịch
                  Color(0xFFFAF7F0), // Giấy điệp truyền thống
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                size: Size(width, height),
                painter: BodygraphPainter(
                  definedCenters: definedCenters,
                  activeChannels: activeChannels,
                  activeGates: activeGates,
                  variable: variable,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _detectCenterTap(Offset pos, double w, double h) {
    final scaleX = w / 360.0;
    final scaleY = h / 540.0;
    final scale = math.min(scaleX, scaleY);
    final offsetX = (w - 360.0 * scale) / 2;
    final offsetY = (h - 540.0 * scale) / 2;

    final canonicalX = (pos.dx - offsetX) / scale;
    final canonicalY = (pos.dy - offsetY) / scale;
    final canonicalPos = Offset(canonicalX, canonicalY);

    final centersPos = {
      'Head': const Offset(180, 46),
      'Ajna': const Offset(180, 128),
      'Throat': const Offset(180, 215),
      'G_Center': const Offset(180, 314),
      'Heart': const Offset(255, 335),
      'Sacral': const Offset(180, 412),
      'Spleen': const Offset(48, 412),
      'Solar_Plexus': const Offset(312, 412),
      'Root': const Offset(180, 502),
    };

    const tapRadius = 42.0;
    for (final entry in centersPos.entries) {
      if ((canonicalPos - entry.value).distance <= tapRadius) {
        return entry.key;
      }
    }
    return null;
  }
}

class BodygraphPainter extends CustomPainter {
  final List<String> definedCenters;
  final List<dynamic> activeChannels;
  final Map<String, dynamic> activeGates;
  final String variable;

  BodygraphPainter({
    required this.definedCenters,
    required this.activeChannels,
    required this.activeGates,
    this.variable = 'PRL - DRR',
  });

  // Màu sắc chuẩn mực IHDS của 9 Trung tâm khi Xác định (Defined)
  static const centerColors = {
    'Head': Color(0xFFFACC15), // Vàng chanh
    'Ajna': Color(0xFF22C55E), // Xanh lá lục bảo
    'Throat': Color(0xFF9A6B43), // Nâu đất / Tan
    'G_Center': Color(0xFFEAB308), // Vàng hoàng gia
    'Heart': Color(0xFFEF4444), // Đỏ tươi
    'Solar_Plexus': Color(0xFF9A6B43), // Nâu đất / Tan
    'Sacral': Color(0xFFDC2626), // Đỏ cam sinh lực
    'Spleen': Color(0xFF9A6B43), // Nâu đất / Tan
    'Root': Color(0xFF9A6B43), // Nâu đất / Tan
  };

  @override
  void paint(Canvas canvas, Size size) {
    // 1. TỶ LỆ VÀNG CHUẨN HOÁ TRÊN KHUNG 360 x 540
    final scaleX = size.width / 360.0;
    final scaleY = size.height / 540.0;
    final scale = math.min(scaleX, scaleY);
    final offsetX = (size.width - 360.0 * scale) / 2;
    final offsetY = (size.height - 540.0 * scale) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    // 2. TỌA ĐỘ VỊ TRÍ 64 CỔNG CHUẨN XÁC NẰM 100% BÊN TRONG CÁC HÌNH
    final ports = _getCanonicalGatePorts();

    // 3. VẼ HỆ THỐNG 36 ĐƯỜNG KÊNH: 3 TRỤC GIỮA THẲNG SONG SONG TUYỆT ĐỐI, CÒN LẠI LÀ ĐƯỜNG CONG TRÒN MỀM MẠI
    _drawAllChannelTubes(canvas, ports);

    // 4. VẼ 9 TRUNG TÂM HÌNH HỌC (ĐÈ LÊN CÁC ĐẦU ỐNG ĐỂ TẠO VIỀN SẮC NÉT)
    _drawHeadCenter(canvas);
    _drawAjnaCenter(canvas);
    _drawThroatCenter(canvas);
    _drawGCenter(canvas);
    _drawHeartCenter(canvas);
    _drawSpleenCenter(canvas);
    _drawSolarPlexusCenter(canvas);
    _drawSacralCenter(canvas);
    _drawRootCenter(canvas);

    // 5. VẼ 64 SỐ CỔNG: NẰM 100% TRONG HÌNH, KÍCH THƯỚC ĐỒNG NHẤT, ĐỐI XỨNG CÂN BẰNG
    _drawGateBadges(canvas, ports);

    // 6. VẼ 4 MŨI TÊN BIẾN SỐ (VARIABLES) QUANH ĐỈNH TRÍ HUỆ
    _drawVariableArrows(canvas, const Offset(180, 46));

    canvas.restore();
  }

  /// Tọa độ 64 cổng: BẮT BUỘC NẰM 100% BÊN TRONG CÁC HÌNH, ĐỐI XỨNG TUYỆT ĐỐI, 3 TRỤC GIỮA THẲNG HÀNG
  Map<int, Offset> _getCanonicalGatePorts() {
    return {
      // 1. Head (Tam giác đỉnh 180, 18; đáy 140-220, 74)
      64: const Offset(164, 62),
      61: const Offset(180, 62),
      63: const Offset(196, 62),

      // 2. Ajna (Tam giác ngược đỉnh trên 136-224, 96; apex dưới 180, 160)
      47: const Offset(164, 108),
      24: const Offset(180, 108),
      4: const Offset(196, 108),
      17: const Offset(164, 126),
      43: const Offset(180, 145),
      11: const Offset(196, 126),

      // 3. Throat (Hình vuông 68x68 từ x: 146-214, y: 181-249)
      62: const Offset(164, 193),
      23: const Offset(180, 193),
      56: const Offset(196, 193),
      16: const Offset(158, 207),
      20: const Offset(158, 220),
      35: const Offset(202, 207),
      12: const Offset(202, 220),
      45: const Offset(202, 233),
      31: const Offset(164, 237),
      8: const Offset(180, 237),
      33: const Offset(196, 237),

      // 4. G-Center (Hình thoi 88x88: đỉnh 180, 270; đáy 180, 358; trái 136, phải 224)
      1: const Offset(180, 286),
      7: const Offset(164, 300),
      13: const Offset(196, 300),
      10: const Offset(152, 314),
      25: const Offset(208, 314),
      15: const Offset(164, 328),
      46: const Offset(196, 328),
      2: const Offset(180, 342),

      // 5. Heart (Tam giác đỉnh 262, 316; đáy trái 216, 354; đáy phải 288, 354)
      21: const Offset(262, 328),
      51: const Offset(246, 340),
      40: const Offset(276, 347),
      26: const Offset(228, 347),

      // 6. Spleen (Tam giác nhỏ gọn thanh tú: đỉnh trái 26, 368 & 26, 456; apex phải 92, 412)
      48: const Offset(35, 380),
      57: const Offset(49, 392),
      44: const Offset(64, 403),
      50: const Offset(78, 412),
      32: const Offset(64, 421),
      28: const Offset(49, 432),
      18: const Offset(35, 444),

      // 7. Solar Plexus (Tam giác đối xứng gương 100% với Spleen: đỉnh phải 334, 368 & 334, 456; apex trái 268, 412)
      36: const Offset(325, 380),
      22: const Offset(311, 392),
      37: const Offset(296, 403),
      6: const Offset(282, 412),
      49: const Offset(296, 421),
      55: const Offset(311, 432),
      30: const Offset(325, 444),

      // 8. Sacral (Hình tròn tâm 180, 412; bán kính 40.0) -> Giãn đều, 27 và 42 cách nhau an toàn
      5: const Offset(164, 388),
      14: const Offset(180, 384),
      29: const Offset(196, 388),
      34: const Offset(152, 410),
      59: const Offset(208, 412),
      27: const Offset(154, 422),
      42: const Offset(166, 434),
      3: const Offset(180, 436),
      9: const Offset(196, 434),

      // 9. Root (Hình vuông 68x68 từ x: 146-214, y: 468-536)
      53: const Offset(164, 478),
      60: const Offset(180, 478),
      52: const Offset(196, 478),
      54: const Offset(156, 496),
      19: const Offset(204, 496),
      38: const Offset(156, 512),
      39: const Offset(204, 512),
      58: const Offset(156, 526),
      41: const Offset(204, 526),
    };
  }

  /// Vẽ 36 đường kênh kết nối: 3 trục giữa thẳng song song hoàn toàn, các đường còn lại cong tròn mềm mại
  void _drawAllChannelTubes(Canvas canvas, Map<int, Offset> p) {
    final channelDefs = [
      // === 3 TRỤC DỌC Ở GIỮA: HOÀN TOÀN SONG SONG THẲNG HÀNG (null = đường thẳng) ===
      // 1. Trục Dọc Head - Ajna
      [64, 47, null],
      [61, 24, null],
      [63, 4, null],

      // 2. Trục Dọc Ajna - Throat
      [17, 62, null],
      [43, 23, null],
      [11, 56, null],

      // 3. Trục Dọc Throat - G
      [31, 7, null],
      [8, 1, null],
      [33, 13, null],

      // 4. Trục Dọc G - Sacral
      [15, 5, null],
      [2, 14, null],
      [46, 29, null],

      // 5. Trục Dọc Sacral - Root
      [42, 53, null],
      [3, 60, null],
      [9, 52, null],

      // === CÁC ĐƯỜNG KÊNH CÒN LẠI: TẤT CẢ ĐỀU LÀ ĐƯỜNG CONG TRÒN MỀM MẠI ===
      // 6. Cung tròn sườn ngoài Trái: Throat -> Spleen (Bo tròn mềm mại đồng tâm)
      [
        16,
        48,
        [const Offset(95, 230), const Offset(30, 305)],
      ],
      [
        20,
        57,
        [const Offset(115, 250), const Offset(48, 325)],
      ],

      // 7. Cung tròn sườn ngoài Phải: Throat -> Solar Plexus (Uốn vòng qua ngoài Heart, bo tròn đồng tâm)
      [
        35,
        36,
        [const Offset(265, 230), const Offset(330, 305)],
      ],
      [
        12,
        22,
        [const Offset(245, 250), const Offset(312, 325)],
      ],

      // 8. Kênh kết nối Heart (Tâm ngã)
      [45, 21, const Offset(245, 265)],
      [25, 51, null],
      [40, 37, const Offset(290, 375)],
      [
        26,
        44,
        [const Offset(170, 365), const Offset(110, 385)],
      ],

      // 9. Kênh kết nối từ Throat & G sang Sacral & Spleen
      [20, 34, const Offset(130, 315)],
      [20, 10, const Offset(142, 265)],
      [10, 57, const Offset(95, 345)],
      [10, 34, const Offset(142, 360)],

      // 10. Kênh cầu nối giữa Sacral với Spleen & Solar Plexus (cong nhẹ mềm mại)
      [34, 57, const Offset(105, 395)],
      [27, 50, const Offset(115, 418)],
      [59, 6, const Offset(245, 412)],

      // 11. Các cung tròn đáy sườn Trái: Spleen -> Root (Uốn cong tròn mềm mại theo dạng Cubic Bézier, không bẹt)
      [
        32,
        54,
        [const Offset(75, 465), const Offset(115, 495)],
      ],
      [
        28,
        38,
        [const Offset(50, 485), const Offset(100, 525)],
      ],
      [
        18,
        58,
        [const Offset(25, 505), const Offset(85, 550)],
      ],

      // 12. Các cung tròn đáy sườn Phải: Solar Plexus -> Root (Đối xứng gương, bo tròn mềm mại)
      [
        49,
        19,
        [const Offset(285, 465), const Offset(245, 495)],
      ],
      [
        55,
        39,
        [const Offset(310, 485), const Offset(260, 525)],
      ],
      [
        30,
        41,
        [const Offset(335, 505), const Offset(275, 550)],
      ],
    ];

    const tubeWidth = 6.8;

    final basePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = tubeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = tubeWidth + 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final renderedChannels = <Map<String, dynamic>>[];

    // === LƯỢT 1: VẼ TẤT CẢ 36 ĐƯỜNG KÊNH NỀN TRẮNG VÀ VIỀN XÁM ===
    for (final def in channelDefs) {
      final gA = def[0] as int;
      final gB = def[1] as int;
      final ctrl = def[2];

      final pA = p[gA] ?? Offset.zero;
      final pB = p[gB] ?? Offset.zero;

      final fullPath = Path();
      fullPath.moveTo(pA.dx, pA.dy);
      if (ctrl == null) {
        fullPath.lineTo(pB.dx, pB.dy);
      } else if (ctrl is Offset) {
        fullPath.quadraticBezierTo(ctrl.dx, ctrl.dy, pB.dx, pB.dy);
      } else if (ctrl is List<Offset> && ctrl.length == 2) {
        fullPath.cubicTo(ctrl[0].dx, ctrl[0].dy, ctrl[1].dx, ctrl[1].dy, pB.dx, pB.dy);
      }

      canvas.drawPath(fullPath, borderPaint);
      canvas.drawPath(fullPath, basePaint);

      renderedChannels.add({
        'gA': gA,
        'gB': gB,
        'fullPath': fullPath,
      });
    }

    // === LƯỢT 2: VẼ CÁC ĐOẠN MÀU KÍCH HOẠT ĐÈ HOÀN TOÀN LÊN TRÊN ĐƯỜNG TRẮNG ===
    // Dùng metric.extractPath trích xuất chính xác 100% hình học từ fullPath, tuyệt đối không lệch sai số
    for (final item in renderedChannels) {
      final gA = item['gA'] as int;
      final gB = item['gB'] as int;
      final fullPath = item['fullPath'] as Path;

      final isActA = activeGates.containsKey(gA.toString());
      final isActB = activeGates.containsKey(gB.toString());
      if (!isActA && !isActB) continue;

      final metrics = fullPath.computeMetrics().toList();
      if (metrics.isEmpty) continue;
      final metric = metrics.first;
      final halfLength = metric.length / 2;

      if (isActA) {
        final pathA = metric.extractPath(0, halfLength);
        _fillChannelHalf(canvas, pathA, gA, tubeWidth);
      }
      if (isActB) {
        final pathB = metric.extractPath(halfLength, metric.length);
        _fillChannelHalf(canvas, pathB, gB, tubeWidth);
      }
    }
  }

  void _fillChannelHalf(Canvas canvas, Path path, int gate, double width) {
    final actKey = gate.toString();
    final act = activeGates[actKey];
    if (act == null) return;

    final type = act['activation_type'] as String? ?? '';
    final redColor = const Color(0xFFDC2626); // Đỏ Vô thức (Design)
    final blackColor = const Color(0xFF0F172A); // Đen Ý thức (Personality)

    // Đặt strokeWidth = width + 0.25 (7.05px) để phủ kín hoàn toàn lòng ống trắng, không để lọt vệt trắng mép
    final fillStrokeWidth = width + 0.25;

    if (type == 'both') {
      final p1 = Paint()
        ..color = redColor
        ..strokeWidth = fillStrokeWidth
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, p1);

      final p2 = Paint()
        ..color = blackColor
        ..strokeWidth = fillStrokeWidth
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke;
      _drawDashedPath(canvas, path, p2, 5.0, 5.0);
    } else if (type == 'design') {
      final paint = Paint()
        ..color = redColor
        ..strokeWidth = fillStrokeWidth
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    } else if (type == 'personality') {
      final paint = Paint()
        ..color = blackColor
        ..strokeWidth = fillStrokeWidth
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        if (distance + length > metric.length) {
          if (draw) {
            canvas.drawPath(metric.extractPath(distance, metric.length), paint);
          }
          break;
        }
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        }
        distance += length;
        draw = !draw;
      }
    }
  }

  // --- VẼ 9 TRUNG TÂM HÌNH HỌC (CHUẨN KÍCH THƯỚC ĐỐI XỨNG CÂN BẰNG) ---
  void _drawHeadCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Head');
    final fill = isDef ? centerColors['Head']! : Colors.white;
    final path = Path()
      ..moveTo(180, 18)
      ..lineTo(220, 74)
      ..lineTo(140, 74)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawAjnaCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Ajna');
    final fill = isDef ? centerColors['Ajna']! : Colors.white;
    final path = Path()
      ..moveTo(136, 96)
      ..lineTo(224, 96)
      ..lineTo(180, 160)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawThroatCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Throat');
    final fill = isDef ? centerColors['Throat']! : Colors.white;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(180, 215), width: 68, height: 68),
      const Radius.circular(3),
    );
    _renderCenterShape(canvas, Path()..addRRect(rrect), fill);
  }

  void _drawGCenter(Canvas canvas) {
    final isDef = definedCenters.contains('G_Center');
    final fill = isDef ? centerColors['G_Center']! : Colors.white;
    final path = Path()
      ..moveTo(180, 270)
      ..lineTo(224, 314)
      ..lineTo(180, 358)
      ..lineTo(136, 314)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawHeartCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Heart');
    final fill = isDef ? centerColors['Heart']! : Colors.white;
    final path = Path()
      ..moveTo(262, 316)
      ..lineTo(288, 354)
      ..lineTo(216, 354)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawSpleenCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Spleen');
    final fill = isDef ? centerColors['Spleen']! : Colors.white;
    final path = Path()
      ..moveTo(26, 368)
      ..lineTo(92, 412)
      ..lineTo(26, 456)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawSolarPlexusCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Solar_Plexus');
    final fill = isDef ? centerColors['Solar_Plexus']! : Colors.white;
    final path = Path()
      ..moveTo(334, 368)
      ..lineTo(268, 412)
      ..lineTo(334, 456)
      ..close();
    _renderCenterShape(canvas, path, fill);
  }

  void _drawSacralCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Sacral');
    final fill = isDef ? centerColors['Sacral']! : Colors.white;
    final path = Path()..addOval(Rect.fromCircle(center: const Offset(180, 412), radius: 40.0));
    _renderCenterShape(canvas, path, fill);
  }

  void _drawRootCenter(Canvas canvas) {
    final isDef = definedCenters.contains('Root');
    final fill = isDef ? centerColors['Root']! : Colors.white;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(180, 502), width: 68, height: 68),
      const Radius.circular(3),
    );
    _renderCenterShape(canvas, Path()..addRRect(rrect), fill);
  }

  void _renderCenterShape(Canvas canvas, Path path, Color fill) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(path, shadowPaint);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFF1E293B);
    canvas.drawPath(path, borderPaint);
  }

  /// Vẽ 64 Số Cổng: TẤT CẢ NẰM 100% BÊN TRONG CÁC HÌNH, KÍCH THƯỚC BẰNG NHAU, ĐỐI XỨNG CÂN BẰNG
  void _drawGateBadges(Canvas canvas, Map<int, Offset> ports) {
    const badgeRadius = 6.8;
    const uniformFontSize = 7.6; // Kích thước chữ đồng nhất tuyệt đối cho tất cả các con số

    for (final entry in ports.entries) {
      final gate = entry.key;
      final pos = entry.value;

      final isAct = activeGates.containsKey(gate.toString());

      if (isAct) {
        // CỔNG KÍCH HOẠT: Huy hiệu tròn màu xanh dương hoàng gia viền trắng sáng
        final shadowPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.20)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
        canvas.drawCircle(Offset(pos.dx, pos.dy + 0.6), badgeRadius, shadowPaint);

        final badgePaint = Paint()
          ..color = const Color(0xFF1D4ED8) // Xanh dương hoàng gia
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, badgeRadius, badgePaint);

        final badgeBorder = Paint()
          ..color = Colors.white
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(pos, badgeRadius, badgeBorder);

        final span = TextSpan(
          text: '$gate',
          style: const TextStyle(
            color: Colors.white,
            fontSize: uniformFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        );
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
      } else {
        // CỔNG CHƯA KÍCH HOẠT: Số màu xám slate đậm, kích thước tỷ lệ bằng hệt như số kích hoạt
        final span = TextSpan(
          text: '$gate',
          style: const TextStyle(
            color: Color(0xFF475569), // Slate xám đậm rõ ràng
            fontSize: uniformFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        );
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
      }
    }
  }

  /// Vẽ 4 Mũi tên Biến số (Variables / PRL - DRR) quanh đỉnh Head
  void _drawVariableArrows(Canvas canvas, Offset head) {
    final isLeft0 = variable.contains('L') && !variable.startsWith('R');
    final isLeft1 = variable.length > 1 && variable[1] == 'L';
    final isLeft2 = variable.contains('-') && variable.split('-')[1].contains('L');
    final isLeft3 = variable.endsWith('L');

    _drawArrowPill(canvas, Offset(head.dx - 40, head.dy - 26), isLeft0);
    _drawArrowPill(canvas, Offset(head.dx - 40, head.dy - 10), isLeft1);
    _drawArrowPill(canvas, Offset(head.dx + 40, head.dy - 26), !isLeft2);
    _drawArrowPill(canvas, Offset(head.dx + 40, head.dy - 10), !isLeft3);
  }

  void _drawArrowPill(Canvas canvas, Offset pos, bool pointLeft) {
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: pos, width: 20, height: 14),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(rrect, bgPaint);
    canvas.drawRRect(rrect, borderPaint);

    final arrow = pointLeft ? '◀' : '▶';
    final span = TextSpan(
      text: arrow,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 7.5,
        fontWeight: FontWeight.bold,
      ),
    );
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant BodygraphPainter oldDelegate) {
    return oldDelegate.definedCenters != definedCenters ||
        oldDelegate.activeChannels != activeChannels ||
        oldDelegate.activeGates != activeGates ||
        oldDelegate.variable != variable;
  }
}
