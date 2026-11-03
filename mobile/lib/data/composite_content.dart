// composite_content.dart - Nội dung luận giải chuyên sâu Hợp Đôi Tình Yêu trích xuất nguyên bản từ file mẫu PDF
// "GIẢI MÃ HUMAN DESIGN TRONG TÌNH YÊU ĐÔI LỨA - TÌNH YÊU KHÔNG PHẢI NƠI TA ĐẾN, MÀ LÀ CÁCH TA CÙNG ĐI"

class CompositeContent {
  /// 1. TÌNH YÊU VÀ NHÓM NĂNG LƯỢNG (Love by Energy Type)
  static Map<String, dynamic> getLoveByType(String typeKey, String name, bool isEn) {
    if (typeKey.contains('Manifesting_Generator') || typeKey.contains('Khởi Xướng Vận Hành')) {
      return {
        'title': isEn ? 'Love & Manifesting Generator' : 'TÌNH YÊU VÀ NHÓM KHỞI XƯỚNG VẬN HÀNH',
        'content': isEn
            ? '$name is a dynamic, multi-talented individual who flourishes in diverse, lively environments. A vibrant blend of Generator stamina and Manifestor rapid initiating speed, $name is both deeply passionate and needs healthy freedom and new stimuli in love.'
            : 'Những người Khởi Xướng Vận Hành (Manifesting Generator) như $name là những cá nhân năng động và đa tài, thăng hoa trong môi trường đa dạng, sôi nổi và luôn làm lớn bản thân lên từng giờ. Trong Human Design, $name là sự hòa phối sống động giữa độ bền bỉ của Vận Hành (Generator) và khả năng khởi phát nhanh nhạy của Khởi Xướng (Manifestor). Sự kết hợp độc đáo này khiến $name trở thành một người bạn đồng hành đầy khí chất, vừa khao khát kết nối sâu sắc, vừa cần không gian độc lập và các kích thích mới.\n\n'
              'Trong các mối quan hệ, $name nở rộ khi ở bên những đối tác thấu hiểu và tôn trọng bản chất năng lượng của mình. Mức độ tương hợp phụ thuộc vào giao tiếp rõ ràng và sự chân thực cảm xúc. $name có sức hút tự nhiên, lôi cuốn mọi người bằng thần thái; tuy nhiên để duy trì mối quan hệ ý nghĩa, người bạn đời cần thoải mái trao cho $name khoảng không để khám phá nhiều mối quan tâm và đam mê khác nhau.\n\n'
              'Mẫu người bạn đời lý tưởng dành cho $name là những ai nhận ra tầm quan trọng của sự trưởng thành lẫn nhau và tính sáng tạo, không phản ứng tốt trước ràng buộc quá cứng nhắc. Sự linh hoạt, niềm tin và cởi mở là các trụ cột nền tảng. Khi được người bạn đời đón nhận tính tự phát và đồng hành cùng những mối quan tâm đang tiến hóa, $name sẽ tỏa sáng rực rỡ.',
      };
    } else if (typeKey.contains('Generator') || typeKey.contains('Vận Hành')) {
      return {
        'title': isEn ? 'Love & Generator' : 'TÌNH YÊU VÀ NHÓM NĂNG LƯỢNG VẬN HÀNH',
        'content': isEn
            ? '$name brings a powerful, vibrant life-force energy into relationships. Generating steady dedication and profound warmth, $name blossoms in love when feeling genuinely satisfied and when life-force responses are deeply cherished.'
            : 'Trong Human Design, $name thuộc nhóm Vận Hành (Generator), chính vì thế $name mang vào các mối quan hệ một nguồn năng lượng mạnh mẽ và sống động. Nổi bật bởi sức sống dồi dào, nguồn lực ổn định và khả năng duy trì cam kết khi được sống đúng với bản chất thật của mình.\n\n'
              'Là một người Vận Hành, $name nở rộ trong tình yêu khi thật sự hài lòng với năng lượng mình trao gửi. Sự mãn nguyện là chỉ dấu then chốt cho thấy người Vận Hành đang căn chỉnh đúng; nó dẫn $name đến những kết nối cảm xúc lành mạnh và rời xa cảm giác bực dọc. Khả năng đáp ứng chân thật trước những lời mời của cuộc sống giúp $name kiến tạo các mối quan hệ ý nghĩa và viên mãn.\n\n'
              'Trong mối quan hệ đôi lứa, $name là người ấm áp, rộng lòng và biết nuôi dưỡng. Tìm thấy niềm vui và sự hài lòng khi dốc năng lượng vào những mối quan hệ thật sự khơi dậy sự hứng khởi. $name cần một người bạn đời tôn trọng chu kỳ năng lượng của mình, thừa nhận nhu cầu tự chủ trong quyết định và giao tiếp rõ ràng, kết nối trực tiếp.',
      };
    } else if (typeKey.contains('Projector') || typeKey.contains('Khai Vấn')) {
      return {
        'title': isEn ? 'Love & Projector' : 'TÌNH YÊU VÀ NHÓM KHAI VẤN (PROJECTOR)',
        'content': isEn
            ? '$name brings deep insight, guiding wisdom, and an intimate aura into partnership. Thrives when genuinely invited, seen for their unique gifts, and given ample rest without pressure to maintain constant mechanical output.'
            : '$name mang vào mối quan hệ năng lượng sâu sắc, khả năng thấu suốt tâm can và dẫn đường khôn ngoan. Hào quang hội tụ và thâm nhập của $name giúp nhìn thấu tiềm năng của người bạn đời.\n\n'
              '$name nở rộ khi nhận được lời mời chân thành và sự công nhận đích thực. $name không có nguồn năng lượng sinh lực bền bỉ vô tận như Generator, do đó cần một người bạn đời không đòi hỏi $name phải liên tục hoạt động thể chất, mà trân trọng trí tuệ, sự hướng dẫn và góc nhìn sáng suốt của $name.',
      };
    } else if (typeKey.contains('Manifestor') || typeKey.contains('Khởi Xướng')) {
      return {
        'title': isEn ? 'Love & Manifestor' : 'TÌNH YÊU VÀ NHÓM KHỞI XƯỚNG (MANIFESTOR)',
        'content': isEn
            ? '$name is an initiator of impact and freedom. Needs independence, autonomy, and mutual informing to maintain a peaceful, loving partnership without anger or restriction.'
            : '$name là người khởi xướng tự chủ và mạnh mẽ. Hào quang khép kín và tự bảo vệ giúp $name mở đường cho những bước tiến mới. Trong tình yêu, $name cần tự do tuyệt đối để hành động mà không bị kiểm soát hay gò bó.\n\n'
              'Chiến lược Thông Báo trước khi làm là chiếc chìa khóa vàng giúp $name và bạn đời giữ được sự bình an sâu sắc, xóa bỏ cảm giác giận dữ và loại bỏ những hiểu lầm không đáng có.',
      };
    } else {
      return {
        'title': isEn ? 'Love & Reflector' : 'TÌNH YÊU VÀ NHÓM PHẢN CHIẾU (REFLECTOR)',
        'content': isEn
            ? '$name is a cosmic mirror reflecting the health and truth of the relationship. Thrives with deep patience, sampling the energies through a complete lunar transit cycle.'
            : '$name là tấm gương phản chiếu thuần khiết sức khỏe và năng lượng của mối quan hệ. Trong tình yêu, $name mang lại sự ngạc nhiên kỳ thú và cái nhìn khách quan không phán xét. $name cần thời gian một chu kỳ Mặt Trăng (~28.5 ngày) để cảm nhận trọn vẹn sự gắn kết trước những bước ngoặt lớn.',
      };
    }
  }

  /// 2. TÌNH YÊU DÀNH CHO HỒ SƠ TÍNH CÁCH (Love by Profile)
  static Map<String, dynamic> getLoveByProfile(String profileKey, String name, bool isEn) {
    if (profileKey == '1/3') {
      return {
        'title': isEn ? 'Love for Profile 1/3 (Investigator / Martyr)' : 'TÌNH YÊU DÀNH CHO HỒ SƠ 1/3 (HIẾU KỲ-CẶN KẼ / THỰC NGHIỆM-THÍCH NGHI)',
        'sections': [
          {
            'heading': isEn ? 'The Search for Safety & Truth' : 'Nhu Cầu Chiều Sâu, Sự Ổn Định & Chân Thật',
            'body': '$name định hướng các mối quan hệ qua lăng kính của sự tò mò, tự phản tỉnh và tinh thần thử nghiệm thực tế. Bản chất Hiếu kỳ - Cặn kẽ (Dòng 1 ý thức) thôi thúc $name muốn hiểu thật thấu đáo giá trị, động cơ và niềm tin của người bạn đời. Niềm tin của $name được xây dựng theo thời gian, dựa nhiều vào bằng chứng về sự trung thành và tính nhất quán.'
          },
          {
            'heading': isEn ? 'Learning Through Trial & Error' : 'Học Hỏi Sâu Sắc Qua Trải Nghiệm Thử - Sai',
            'body': 'Ảnh hưởng của Dòng 3 (vô thức) khiến các mối quan hệ của $name trở thành không gian học hỏi sâu sắc. $name học tốt nhất bằng việc thử và sai, không sợ sai lầm mà đón nhận chúng như bài học giá trị. Điều này đôi lúc tạo nên sóng gió hoặc tính khó lường, nhưng rốt cuộc làm giàu cho cái nhìn thấu suốt về bản thân và bạn đời.'
          },
          {
            'heading': isEn ? 'Ideal Partner Dynamics' : 'Đối Tác Lý Tưởng',
            'body': '$name sẽ phát triển mạnh bên cạnh một người kiên nhẫn, tôn trọng tự do, mang lại sự ổn định vững chắc, đồng thời ủng hộ nhu cầu khám phá và học hỏi liên tục của $name.'
          }
        ]
      };
    } else if (profileKey == '6/3') {
      return {
        'title': isEn ? 'Love for Profile 6/3 (Role Model / Martyr)' : 'TÌNH YÊU DÀNH CHO HỒ SƠ 6/3 (THỰC NGHIỆM-THÍCH NGHI / LÝ TƯỞNG-TẤM GƯƠNG SÁNG)',
        'sections': [
          {
            'heading': isEn ? 'Phase 1: Trial & Error (Under 30)' : 'Giai Đoạn Đầu Đời (Trước 30 Tuổi): Thời Kỳ Thử Nghiệm',
            'body': 'Những năm còn trẻ, $name có thể cảm thấy mình liên tục "sai nhịp" trong chuyện tình cảm. Có thể xuất hiện chuỗi thăng trầm lãng mạn. Ảnh hưởng của Dòng 3 thúc đẩy $name học qua trải nghiệm thực tế. Đây không phải khuyết điểm, mà là nhiên liệu để $name nhận ra điều gì thực sự vận hành và có giá trị bền vững.'
          },
          {
            'heading': isEn ? 'Phase 2: On The Roof (30-50)' : 'Trung Vận (30-50 Tuổi): Thời Kỳ Lùi Lại & Chiêm Nghiệm Trên Mái Nhà',
            'body': 'Bước vào tuổi 30, Dòng 6 bắt đầu "leo lên mái nhà". $name có nhu cầu xâu chuỗi ý nghĩa của hành trình thử-sai, chữa lành và tìm kiếm sự tĩnh lặng nội tâm. $name kỹ lưỡng hơn trong chọn lựa tình yêu, cần không gian chiêm nghiệm và một người bạn đời vững vàng, trưởng thành về cảm xúc.'
          },
          {
            'heading': isEn ? 'Phase 3: The Role Model (50+)' : 'Hậu Vận (50+): Thời Kỳ Minh Triết & Hiện Thân',
            'body': 'Sau tuổi 50, $name bước xuống mái nhà để trở thành một hình mẫu đích thực trong tình yêu. Trải nghiệm sống kết tinh thành sự sáng tỏ, tự tin và lòng chính trực. $name thu hút mối quan hệ đồng điệu, sâu sắc và bền lâu hiếm có.'
          },
          {
            'heading': isEn ? 'Key Qualities & Best Matches' : 'Phẩm Chất Nổi Bật & Đối Tượng Phù Hợp',
            'body': '• Cần tự do để khám phá, không bị đóng khung bó buộc.\n• Học qua sai lầm: đổ vỡ là nhiên liệu nuôi dưỡng trí tuệ.\n• Khao khát sự kết nối sâu sắc, đề cao sự trung thực và trưởng thành.\n• Phù hợp nhất với bạn đời có Dòng 3 hoặc Dòng 6 (cùng cộng hưởng lớn lên), hoặc Dòng 4 (giúp neo giữ sự ổn định).'
          }
        ]
      };
    } else {
      return {
        'title': isEn ? 'Love for Profile $profileKey' : 'TÌNH YÊU DÀNH CHO HỒ SƠ $profileKey',
        'sections': [
          {
            'heading': isEn ? 'Profile Dynamics in Relationships' : 'Bản Chất Năng Lượng Hồ Sơ Trong Tình Yêu',
            'body': 'Hồ sơ $profileKey mang lại phong thái yêu đương độc đáo, là sự kết hợp giữa ý thức và vô thức. Trong tình yêu, $name cần một người bạn đời nhìn thấy vẻ đẹp chân thật của chiếc áo định mệnh này, tôn trọng cả điểm mạnh lẫn những bài học tiến hóa của $name.'
          },
          {
            'heading': isEn ? 'Growth Path' : 'Lộ Trình Nuôi Dưỡng Sự Gắn Kết',
            'body': 'Giao tiếp chân thật, tôn trọng khoảng không riêng và cùng nhau lớn lên qua từng thử thách là chìa khóa giúp mối quan hệ của $name đạt tới sự thấu hiểu và hòa hợp tối ưu.'
          }
        ]
      };
    }
  }

  /// 3. CÁC CÁNH CỔNG TÌNH YÊU ĐẶC BIỆT (Love Gates in Human Design)
  static Map<int, Map<String, String>> loveGates = {
    10: {
      'name': 'CỔNG 10: TÌNH YÊU TỰ THÂN (LOVE OF SELF)',
      'quote': '“Yêu việc được sống giữa đời; yêu thế giới như chính nó đang là; và yêu lấy chính mình.”',
      'core': 'Ôm trọn tính chân thật và tình yêu bản thân. Có hiểu biết sâu sắc về bản sắc độc nhất của mình và kiên định biểu đạt con người chân thật mà không cần tô vẽ.',
      'relationship': 'Khuyến khích bước vào mối quan hệ từ nền tảng của tự tin và chính trực. Thu hút bạn đời cộng hưởng về giá trị. Cần cân bằng giữa tình yêu bản thân và động lực gắn kết lứa đôi.',
      'advice': 'Hành động bên ngoài luôn phản chiếu giá trị nội tâm. Nhận diện các bẫy ích kỷ hoặc cứng nhắc để mở lòng đón nhận phản hồi từ đối phương.',
    },
    28: {
      'name': 'CỔNG 28: TÌNH YÊU GẮN VỚI MỤC ĐÍCH (LOVE WITH PURPOSE)',
      'quote': '“Tìm thấy tình yêu qua hành trình dấn thân vì ý nghĩa sống.”',
      'core': 'Sẵn sàng đối diện thách thức trực diện, xem khó khăn là cơ hội để trưởng thành. Tìm kiếm những kết nối không chỉ trọn vẹn cảm xúc mà còn giàu ý nghĩa hiện sinh.',
      'relationship': 'Là kẻ lãng mạn đích thực, sẵn lòng ôm trọn cả niềm vui lẫn gian truân. Cần truyền thông rõ ràng về kỳ vọng để tránh cảm giác bồn chồn nếu mối quan hệ thiếu chiều sâu.',
      'advice': 'Cân bằng giữa tinh thần phiêu lưu mạo hiểm và sự ổn định thường nhật. Tôn trọng tiến trình tiến hóa của bạn đời.',
    },
    40: {
      'name': 'CỔNG 40: CỔNG GÂY DỰNG TÌNH YÊU (LOVE THROUGH WORK & SERVICE)',
      'quote': '“Tìm thấy tình yêu qua công việc và sự cống hiến; yêu công việc khi được ủng hộ để nâng đỡ người mình yêu.”',
      'core': 'Năng lực tận tâm và cam kết sâu sắc. Bày tỏ tình yêu qua hành động phục vụ, chu cấp, gánh vác trách nhiệm để bảo đảm an lành cho người thương.',
      'relationship': 'Dễ rơi vào bẫy quá tải, kiệt quệ nếu ranh giới không rõ ràng. Cần sự cân bằng tuyệt đối giữa "Ở một mình để nạp năng lượng" và "Kết nối sẻ chia".',
      'advice': 'Chuyển hóa mặt trái (cả nể, cháy sạch năng lượng) sang mặt phải (từ khóa Quyết Tâm): thiết lập ranh giới vững vàng, cho đi từ trạng thái đủ đầy.',
    },
    25: {
      'name': 'CỔNG 25: TÌNH YÊU PHỔ QUÁT (UNIVERSAL LOVE)',
      'quote': '“Tình yêu vô điều kiện ôm trọn vạn vật không phân biệt.”',
      'core': 'Khả năng chấp nhận và bao dung vô bờ bến. Vượt qua những cú sốc tâm linh để giác ngộ và yêu thương người bạn đời đúng như con người nguyên bản của họ.',
      'relationship': 'Mang lại sự chữa lành và bình an dịu dàng. Cần lưu ý không để người khác lợi dụng sự ngây thơ và lòng tốt vô điều kiện của mình.',
      'advice': 'Giữ vững sự trong trẻo của trái tim và học cách yêu thương có ranh giới.',
    },
    15: {
      'name': 'CỔNG 15: TÌNH YÊU NHÂN LOẠI (LOVE OF HUMANITY)',
      'quote': '“Hòa nhập vào muôn vàn nhịp điệu phong phú của cuộc sống.”',
      'core': 'Sức chứa lớn đối với mọi sự đa dạng, khác biệt và lập dị của con người. Yêu sự biến chuyển không ngừng của dòng chảy tự nhiên.',
      'relationship': 'Bạn đời không bao giờ cảm thấy bị phán xét hay gò ép. Mối quan hệ luôn sinh động và ngập tràn trải nghiệm mới mẻ.',
      'advice': 'Tôn trọng nhịp sinh học cá nhân của bạn đời ngay cả khi nhịp điệu của hai người khác biệt.',
    },
    46: {
      'name': 'CỔNG 46: TÌNH YÊU THỂ XÁC (LOVE OF THE BODY)',
      'quote': '“Trân quý ngôi đền cơ thể; ở đúng nơi vào đúng thời điểm.”',
      'core': 'Kết nối sâu sắc với sự gợi cảm, xúc chạm thể xác và niềm vui trần thế. Coi cơ thể là phương tiện thiêng liêng để trải nghiệm tình yêu.',
      'relationship': 'Tạo ra sự gắn kết thể xác mãnh liệt, nồng nàn và gần gũi. Thăng hoa qua những cử chỉ ân yếm, ôm ấp và chăm sóc sức khỏe.',
      'advice': 'Lắng nghe thông điệp của cơ thể và tôn trọng không gian vật lý của nhau.',
    },
    58: {
      'name': 'CỔNG 58: NIỀM VUI SỐNG & SỰ HOÀN THIỆN (LOVE OF LIVING)',
      'quote': '“Ngọn lửa đam mê hoàn thiện cuộc sống để mọi thứ tốt đẹp hơn.”',
      'core': 'Áp lực tích cực nhằm cải thiện chất lượng đời sống, lan tỏa năng lượng tươi vui và tiếng cười rộn rã.',
      'relationship': 'Mang lại sự phấn chấn và động lực vươn lên cho bạn đời. Cần tránh thói quen chỉ trích hay săm soi những chi tiết chưa hoàn hảo của đối phương.',
      'advice': 'Khen ngợi và trân trọng hiện tại trước khi đề xuất cải tiến.',
    },
  };

  /// 4. PHÂN TÍCH KÊNH THỎA HIỆP (Compromise Channels Dynamics - Trang 12-14)
  static Map<String, dynamic> getCompromiseChannelDetail(String channelId, String nameA, String nameB, bool isEn) {
    if (channelId == '20-34') {
      return {
        'name': 'Kênh 20-34: Kênh Của Sự Lôi Cuốn (The Channel of Charisma)',
        'summary': 'Điểm chạm cọ xát mạnh nhất nơi một bên có trọn vẹn sức mạnh bộc phát (20-34), còn bên kia nhận năng lượng gián tiếp.',
        'personADynamics': [
          'Hành động tự nhiên và bộc phát từ phản hồi của Trung tâm Sinh Lực (Sacral).',
          'Có xu hướng dẫn nhịp và định tông biểu đạt lời nói trong mối quan hệ, thích nói thẳng nói thật, không cả nể hay sợ mất lòng.',
          'Thường không nhận ra sức hiện diện áp đảo của mình vì năng lượng diễn ra tự động, bộc phát bình thường.'
        ],
        'personBDynamics': [
          'Trải nghiệm nguồn năng lượng mạnh mẽ này theo cách gián tiếp được nhận cộng hưởng từ đối phương.',
          'Khi ở gần nhau, sức nặng biểu đạt của bản thân cũng bộc trực, mãnh liệt và quyết liệt hơn theo thời gian.',
          'Đôi khi cảm thấy bị lu mờ, lấn át bằng lời nói hoặc sự biểu đạt của mình bị "bay màu" trước chất giọng đầy nội lực của đối phương.'
        ],
        'challenges': [
          'Mất cân bằng về quyền tự chủ: Một bên cảm thấy nhịp điệu sống thường nhật bị can thiệp bởi các quyết định bộc phát nhanh như chớp.',
          'Khó khăn giao tiếp: Biểu đạt bộc phát quá mức có thể dẫn tới nói năng quá thẳng thắn, thiếu khéo léo gây tổn thương cảm xúc.',
          'Cảm giác không được nhìn thấy/nghe thấy: Bên nhận năng lượng cảm thấy ý kiến của mình bị phớt lờ hoặc xem nhẹ.',
          'Kiệt sức năng lượng: Cố gắng chạy theo nhịp độ siêu tốc của đối phương dẫn tới cạn kiệt năng lượng.'
        ],
        'solutions': [
          'Học cách quan sát và thừa nhận: Thẳng thắn nhìn nhận động lực năng lượng tự nhiên của kênh này, không phán xét đối phương.',
          'Chủ ý tạo khoảng trống biểu đạt: Người nắm kênh cần chậm lại, tạo nhịp dừng để lắng nghe tiếng nói và sự lựa chọn của bạn đời.',
          'Giao tiếp rõ ràng và mềm mại: Bộc bạch cảm xúc chân thật khi thấy khó chịu, giải bày nhẹ nhàng không đổ lỗi.',
          'Tôn trọng khác biệt về nhịp điệu và tốc độ: Sự nhanh gọn quyết đoán và nhịp độ cẩn trọng tinh tế là hai mảnh ghép bổ trợ hoàn hảo.',
          'Trao quyền và nâng đỡ lẫn nhau: Chuyển từ cạnh tranh vị thế sang hợp tác tôn vinh thế mạnh của nhau.'
        ]
      };
    } else {
      return {
        'name': 'Kênh Thỏa Hiệp $channelId',
        'summary': 'Một người nắm trọn vẹn cả kênh còn người kia chỉ có 1 cổng, tạo ra động lực học hỏi và cần sự bao dung kiên nhẫn.',
        'challenges': [
          'Nguy cơ áp đặt cách thức vận hành năng lượng lên đối phương.',
          'Cần thời gian để người có 1 cổng thích nghi với tần số hoàn chỉnh của người kia.'
        ],
        'solutions': [
          'Thừa nhận sự khác biệt tự nhiên của Human Design.',
          'Không cố gắng thay đổi đối phương mà tôn trọng chu kỳ tự nhiên.'
        ]
      };
    }
  }

  /// 5. ĐỊNH DẠNG TƯƠNG TÁCH TRUNG TÂM (Connection Themes: 9-0, 8-1, 7-2, 6-3, 5-4)
  static Map<String, String> getConnectionTheme(int definedCount, bool isEn) {
    if (definedCount == 9) {
      return {
        'theme': '9 - 0: Không Có Lối Thoát (Nowhere to Go)',
        'desc': 'Cả 9 trung tâm đều được xác định khi kết hợp lại! Mối quan hệ gắn kết cực kỳ chặt chẽ, cuốn hút nhau mãnh liệt nhưng cần chủ động tạo không gian riêng để không bị ngột ngạt.'
      };
    } else if (definedCount == 8) {
      return {
        'theme': '8 - 1: Cửa Sổ Trải Nghiệm Lý Tưởng (Have Some Fun)',
        'desc': 'Đây là tỷ lệ vàng trong tình yêu đôi lứa! 8 trung tâm gắn kết tạo nên nền tảng vững chắc, trong khi 1 trung tâm mở đóng vai trò là "cửa sổ thở" mang lại niềm vui, sự tò mò và không gian đón nhận luồng gió mới từ thế giới bên ngoài.'
      };
    } else if (definedCount == 7) {
      return {
        'theme': '7 - 2: Có Công Việc Để Làm (Work to Do)',
        'desc': 'Mối quan hệ có sự gắn kết tốt nhưng có 2 trung tâm mở đòi hỏi cả hai cần nỗ lực đối thoại, học cách thấu hiểu và cùng nhau xây dựng sự đồng thuận.'
      };
    } else if (definedCount == 6) {
      return {
        'theme': '6 - 3: Cần Tự Do (Better to be Free)',
        'desc': 'Có 3 trung tâm mở khi ở bên nhau. Hai bạn cần nhiều khoảng không độc lập, tôn trọng không gian riêng tư của nhau để tình cảm luôn tươi mới.'
      };
    } else {
      return {
        'theme': '$definedCount - ${9 - definedCount}: Tìm Kiếm Sự Đồng Điệu (Looking for Love)',
        'desc': 'Hai bạn có nhiều vùng năng lượng mở, tạo nên tình bạn linh hoạt, nhẹ nhàng và tự do trải nghiệm cuộc sống.'
      };
    }
  }
}
