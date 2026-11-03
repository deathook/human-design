import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CenterDetailSheet extends StatelessWidget {
  final String centerId;
  final bool isDefined;
  final Map<String, dynamic>? centerData;

  const CenterDetailSheet({
    super.key,
    required this.centerId,
    required this.isDefined,
    this.centerData,
  });

  static const Map<String, Map<String, String>> centerBookData = {
    'Head': {
      'name_vi': 'Trung tâm Trí Huệ (Crown)',
      'bio': 'Tuyến tùng (Pineal Gland)',
      'role': 'Áp lực tư duy & Cảm hứng',
      'defined': 'Nguồn cảm hứng bền bỉ từ bên trong, áp lực giải quyết các câu hỏi lớn của cuộc đời.',
      'undefined': 'Mở đón nhận cảm hứng từ muôn nơi, linh hoạt nhưng dễ bị áp lực giải quyết vấn đề của người khác.',
      'question': 'Tôi có đang cố gắng trả lời những câu hỏi không phải của mình không?'
    },
    'Ajna': {
      'name_vi': 'Trung tâm Tuệ Nhãn (Ajna)',
      'bio': 'Tuyến yên (Pituitary Gland)',
      'role': 'Nhận thức tinh thần & Xử lý thông tin',
      'defined': 'Tư duy kiên định, có cấu trúc phân tích nhất quán, quan điểm vững chãi nhưng có thể bảo thủ.',
      'undefined': 'Tư duy mở, dễ nhìn nhận đa chiều không phán xét, không cần tỏ ra luôn chắc chắn.',
      'question': 'Tôi có đang cố thuyết phục mọi người rằng tôi luôn luôn chắc chắn không?'
    },
    'Throat': {
      'name_vi': 'Trung tâm Tuệ Ngôn (Throat)',
      'bio': 'Tuyến giáp & Cận giáp',
      'role': 'Biểu hiện & Hiện thực hóa',
      'defined': 'Giọng nói nhất quán, khả năng biến ý tưởng và năng lượng thành hành động thực tế.',
      'undefined': 'Giao tiếp linh hoạt tùy đối tượng, nói chuyện có trọng lượng khi được mời phát biểu.',
      'question': 'Tôi có đang cố gắng thu hút sự chú ý bằng cách nói quá nhiều không?'
    },
    'G_Center': {
      'name_vi': 'Trung tâm Thượng Ngã (G-Center)',
      'bio': 'Gan & Tuần hoàn máu',
      'role': 'Bản sắc, Tình yêu & Hướng đi cuộc đời',
      'defined': 'Bản sắc vững chãi như một chiếc la bàn nội tâm, định hướng cuộc đời ổn định và kiên định.',
      'undefined': 'Bản sắc linh hoạt, đổi mới theo môi trường và người đồng hành, trải nghiệm nhiều con đường.',
      'question': 'Tôi có đang ám ảnh tìm kiếm xem tôi là ai và tôi đang đi về đâu không?'
    },
    'Heart': {
      'name_vi': 'Trung tâm Tâm Ngã / Ý Chí (Heart/Ego)',
      'bio': 'Tim, Tuyến ức, Túi mật, Dạ dày',
      'role': 'Động cơ Ý chí & Giá trị bản thân',
      'defined': 'Ý chí sắt đá, quyết tâm cao, khả năng thực hiện cam kết và quản lý tài nguyên vật chất.',
      'undefined': 'Giá trị bản thân là vốn có không cần chứng minh; không nên hứa hẹn ràng buộc ý chí.',
      'question': 'Tôi có đang cảm thấy mình phải nỗ lực chứng minh giá trị bản thân với ai đó không?'
    },
    'Solar_Plexus': {
      'name_vi': 'Trung tâm Thái Dương (Solar Plexus)',
      'bio': 'Thận, Hệ thần kinh',
      'role': 'Động cơ & Nhận thức Cảm xúc',
      'defined': 'Phát ra những làn sóng cảm xúc tự nhiên; cần kiên nhẫn chờ cảm xúc lắng đọng để sáng suốt.',
      'undefined': 'Khuếch đại cảm xúc từ người khác; là tấm gương thấu cảm nhưng cần giữ ranh giới cảm xúc an toàn.',
      'question': 'Tôi có đang né tránh sự thật và đối đầu vì sợ làm người khác buồn không?'
    },
    'Sacral': {
      'name_vi': 'Trung tâm Sinh Khí / Đan Điền (Sacral)',
      'bio': 'Cơ quan sinh sản',
      'role': 'Động cơ Lực sống bền bỉ',
      'defined': 'Nguồn pin làm việc vô tận khi được làm điều mình thích; phản hồi qua âm thanh dạ dày (Ừ hứ/Ừ ừ).',
      'undefined': 'Không có nguồn năng lượng liên tục; cần biết điểm dừng để nghỉ ngơi nạp lại, tránh kiệt sức.',
      'question': 'Tôi có biết khi nào là đủ để dừng lại và nghỉ ngơi không?'
    },
    'Spleen': {
      'name_vi': 'Trung tâm Sinh Giác / Lách (Spleen)',
      'bio': 'Hệ miễn dịch, Hệ bạch huyết, Lách',
      'role': 'Nhận thức Trực giác Sinh tồn',
      'defined': 'Trực giác nhạy bén trong khoảnh khắc tức thời, sức đề kháng tốt, cảnh báo nguy hiểm nhanh chóng.',
      'undefined': 'Nhạy cảm với sức khỏe người khác; dễ bám víu vào mối quan hệ độc hại vì cảm giác an toàn quen thuộc.',
      'question': 'Tôi có đang níu giữ điều gì không còn lành mạnh chỉ vì sợ hãi không?'
    },
    'Root': {
      'name_vi': 'Trung tâm Gốc (Root)',
      'bio': 'Tuyến thượng thận (Adrenaline)',
      'role': 'Áp lực & Động cơ Sinh tồn',
      'defined': 'Chịu đựng căng thẳng tốt, biến áp lực cuộc sống thành động lực hành động ổn định.',
      'undefined': 'Dễ bị cuốn theo áp lực và sự gấp gáp của người khác; cần học cách thả lỏng thư thái.',
      'question': 'Tôi có đang vội vã làm mọi việc chỉ để giải phóng áp lực không?'
    },
  };

  @override
  Widget build(BuildContext context) {
    final info = centerBookData[centerId] ?? {
      'name_vi': centerId,
      'bio': 'Hệ sinh học',
      'role': 'Năng lượng',
      'defined': 'Năng lượng xác định ổn định.',
      'undefined': 'Năng lượng mở linh hoạt.',
      'question': 'Hãy quan sát bản thân trong tĩnh lặng.'
    };

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo trên đỉnh
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tiêu đề & Badge trạng thái
          Row(
            children: [
              Expanded(
                child: Text(
                  info['name_vi']!,
                  style: const TextStyle(
                    color: AppTheme.goldLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDefined ? AppTheme.gold.withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDefined ? AppTheme.gold : AppTheme.textMuted,
                    width: 1,
                  ),
                ),
                child: Text(
                  isDefined ? 'XÁC ĐỊNH (ĐẬM)' : 'MỞ (TRẮNG)',
                  style: TextStyle(
                    color: isDefined ? AppTheme.goldLight : AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Cơ quan sinh học & Chức năng
          Row(
            children: [
              const Icon(Icons.biotech, size: 16, color: AppTheme.cyanCosmic),
              const SizedBox(width: 6),
              Text(
                'Sinh học: ${info['bio']}',
                style: const TextStyle(color: AppTheme.cyanCosmic, fontSize: 12),
              ),
            ],
          ),
          const Divider(color: Color(0xFF2D324D), height: 24),

          // Luận giải từ sách
          Text(
            isDefined ? 'ĐẶC TÍNH NĂNG LƯỢNG BẨM SINH' : 'TIỀM NĂNG TRÍ TUỆ & VÙNG ĐIỀU KIỆN HÓA',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isDefined ? info['defined']! : info['undefined']!,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),

          // Câu hỏi chiêm nghiệm gỡ bỏ điều kiện hóa (Deconditioning)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2238),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.psychology, color: AppTheme.goldLight, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CÂU HỎI THÁO GỠ ĐIỀU KIỆN HÓA',
                        style: TextStyle(color: AppTheme.goldLight, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '“${info['question']}”',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nút đóng
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Đóng'),
            ),
          ),
        ],
      ),
    );
  }
}
