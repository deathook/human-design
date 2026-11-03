import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chart_data.dart';
import '../widgets/bodygraph_view.dart';
import '../widgets/center_detail_sheet.dart';
import '../services/language_service.dart';

class FullscreenBodygraphViewer extends StatefulWidget {
  final ChartData chart;

  const FullscreenBodygraphViewer({super.key, required this.chart});

  @override
  State<FullscreenBodygraphViewer> createState() => _FullscreenBodygraphViewerState();
}

class _FullscreenBodygraphViewerState extends State<FullscreenBodygraphViewer> with SingleTickerProviderStateMixin {
  final TransformationController _transformController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _handleDoubleTap() {
    if (_transformController.value != Matrix4.identity()) {
      _resetZoom();
    } else {
      final position = _doubleTapDetails?.localPosition ?? const Offset(200, 300);
      _transformController.value = Matrix4(
        2.5, 0.0, 0.0, 0.0,
        0.0, 2.5, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        -position.dx * 1.5, -position.dy * 1.5, 0.0, 1.0,
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final chart = widget.chart;

    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.currentLang,
      builder: (context, lang, _) {
        final isEn = lang == 'en';

        return Scaffold(
          backgroundColor: const Color(0xFF0B0D14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F121C),
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppTheme.goldLight),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chart.userName,
                  style: const TextStyle(color: AppTheme.goldLight, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${isEn ? chart.typeNameEn : chart.typeName} • ${isEn ? "Profile" : "Hồ sơ"} ${chart.profileKey}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.crop_free, color: AppTheme.goldLight),
                tooltip: isEn ? 'Reset Zoom' : 'Đặt lại kích thước',
                onPressed: _resetZoom,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: AppTheme.goldLight),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEn ? 'Chart image ready to share!' : 'Đã sẵn sàng chia sẻ hình ảnh lá số!')),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // Khu vực phóng to tự do như xem ảnh
              Center(
                child: GestureDetector(
                  onDoubleTapDown: (details) => _doubleTapDetails = details,
                  onDoubleTap: _handleDoubleTap,
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    minScale: 0.8,
                    maxScale: 6.0,
                    boundaryMargin: const EdgeInsets.all(120),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: AspectRatio(
                        aspectRatio: 360 / 540,
                        child: BodygraphView(
                          definedCenters: chart.definedCenters,
                          activeChannels: chart.activeChannels,
                          activeGates: chart.activeGates,
                          variable: chart.variable,
                          onCenterTap: _showCenterDetail,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Thanh hướng dẫn góc dưới
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161A29).withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF282F4C)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.zoom_in, color: AppTheme.goldLight, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        isEn
                            ? 'Pinch to zoom (up to 6x) • Double-tap to quick zoom'
                            : 'Dùng 2 ngón tay phóng to (tới 6x) • Chạm 2 lần để zoom nhanh',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
