// reading_content.dart - Cơ sở dữ liệu luận giải 10 chương chuyên sâu Song Ngữ (Tiếng Việt & English)
// Trích xuất trực tiếp từ sách "Human Design Cho Người Mới Bắt Đầu" (TH Group) và cấu trúc chuẩn IHDS

class ReadingContent {
  // CHAPTER 1: INTRODUCTION
  static Map<String, dynamic> getChapter1(bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 1: Introduction',
        'subtitle': 'The Life Transforming Experiment of Living as Yourself and Claiming your Uniqueness',
        'paragraphs': [
          'The Human Design System is the Science of Differentiation. It shows each of us that we have a unique design and a specific purpose to fulfill while on Earth. Endless possibilities for individual uniqueness lie within our genetic matrix. There are millions of variations of human beings, yet each of us has a specific and unique Human Design configuration with a clear Strategy that effortlessly aligns us to our uniqueness.',
          'Human Design does not ask you to believe anything. It invites you to participate in a potentially life-transforming living experiment, and provides you with the practical tools and information needed to live life as yourself. Without this individualized living experiment, Human Design is just a complex system of fascinating information to entertain the mind. In looking at thousands of charts, one thing stands out: no two are exactly alike.',
          'A Human Design Chart or BodyGraph is a precise map and user guide that gives you access to how we are genetically designed to engage with the world, and how our unique inner guidance system operates. The conscious (Personality) and unconscious (Design) parts of ourselves show what no one can take away from us, as well as the aspects that we have been taught or conditioned to believe are us, but are not.',
          'As the founder, Ra Uru Hu has often said: "What you can rely on you’ve never relied on in your life. What you can’t trust you’ve been trying to trust all your life. What you’ve been trusting has never been you. What you’ve been ignoring has always been you. Try to trust what’s really you and see what happens."',
          'The Deconditioning Process is a process of letting go of what we are not. It is a slow and deep journey. When we re-claim our Authority, changing how we make decisions, we actually change the way our cells function within our body. Life moves in seven-year cycles, as it takes approximately seven years for all the cells in our body to be renewed. Seven years later we emerge closer to the person we were born to be.',
          'The Signposts of Resistance alert us when we make decisions from our thinking minds rather than our Strategy and Authority. The not-self themes of Anger (Manifestor), Frustration (Generator / Manifesting Generator), Bitterness (Projector), and Disappointment (Reflector) are clear guideposts that remind us to return to our authentic self.'
        ]
      };
    } else {
      return {
        'title': 'Chương 1: Khái Quát Về Human Design',
        'subtitle': 'Cuộc Thử Nghiệm Biến Đổi Cuộc Đời: Sống Là Chính Mình & Khẳng Định Sự Độc Đáo',
        'paragraphs': [
          'Human Design (Nhân Khí Học) là Khoa học về sự Khác biệt (The Science of Differentiation). Hệ thống này cho thấy mỗi chúng ta đều sở hữu một bản thiết kế di truyền độc nhất vô nhị và mang một sứ mệnh cụ thể khi bước vào trần thế. Vô số tiềm năng cá nhân nằm sâu bên trong ma trận gen của bạn, và chiến lược sống chính là chiếc la bàn giúp bạn tự nhiên đồng điệu với bản chất thật của mình.',
          'Human Design không đòi hỏi bạn phải tin vào bất kỳ giáo điều hay tín ngưỡng nào. Đây là một lời mời gọi tham gia vào một "cuộc thử nghiệm sống" có khả năng chuyển hóa toàn bộ cuộc đời bạn. Nếu thiếu đi sự thực nghiệm này, Human Design sẽ chỉ là một tập hợp thông tin lý thuyết hấp dẫn để làm thỏa mãn trí tò mò của tâm trí. Khi chiêm ngưỡng hàng vạn lá số, một sự thật hiển nhiên hiện lên: Không có hai con người nào hoàn toàn giống nhau.',
          'Biểu đồ BodyGraph là một bản đồ hoa tiêu chính xác giúp bạn nhận biết phần Ý thức (Tính cách - Personality - màu Vàng/Đen) mà bạn nhận diện được, và phần Vô thức (Thiết kế - Design - màu Đỏ) thuộc về trí tuệ thể xác mà người khác nhìn thấy rõ hơn bạn. Đồng thời, nó phân định ranh giới rõ ràng giữa những gì vốn là của bạn và những áp lực bạn bị điều kiện hóa (Conditioning) từ môi trường xã hội.',
          'Người sáng lập Ra Uru Hu từng chia sẻ: "Những gì bạn thực sự có thể nương tựa thì cả đời bạn chưa từng dựa vào. Những gì bạn không thể tin tưởng thì bạn lại luôn cố bám víu. Hãy thử tin tưởng vào bản chất chân thật của mình và quan sát điều kỳ diệu xảy ra."',
          'Tiến trình Tháo Gỡ Điều Kiện Hóa (Deconditioning) là hành trình buông bỏ những kỳ vọng, giáo điều không thuộc về bản thể của bạn. Quá trình này diễn ra theo chu kỳ 7 năm sinh học – khoảng thời gian cần thiết để hầu hết các tế bào trong cơ thể người được thay mới hoàn toàn dưới sự dẫn dắt của Chiến lược và Thẩm quyền đúng đắn.',
          'Các Dấu Hiệu Kháng Cự (Signposts of Resistance) xuất hiện khi bạn để tâm trí lý trí đưa ra quyết định thay cho cơ thể: Nỗi Phẫn nộ (Khởi Xướng), Sự Bất mãn & Thất vọng (Vận Hành & Khởi Xướng Vận Hành), Vị Cay đắng (Khai Vấn), và Niềm Thất vọng (Phản Chiếu). Chúng là những biển báo cảnh tỉnh giúp bạn quay về với chân ngã của mình.'
        ]
      };
    }
  }

  // CHAPTER 2: TYPE AND STRATEGY
  static Map<String, dynamic> getChapter2(String typeId, bool isEn) {
    if (isEn) {
      switch (typeId) {
        case 'Manifesting_Generator':
          return {
            'title': 'Chapter 2: Your Type and Strategy',
            'subtitle': 'Manifesting Generator - How You Operate Most Effectively',
            'paragraphs': [
              'With your defined Sacral Center and a direct motor connection to your Throat Center, you are a Manifesting Generator. The Sacral Center is the prime motor of life on Earth, generating vital creative energy. As a Manifesting Generator, you represent approximately 33% of the world population.',
              'You are designed to work, to love the work you do, and to exhaust your measure of creative Sacral energy every single day. Your Sacral motor does not give up until what it has committed to is accomplished. This brings deep satisfaction with life and a restful, regenerating night\'s sleep.',
              'Your direct connection from a motor to the Throat allows you to move rapidly from response to manifestation. You possess the innate gift of efficiency: seeing which steps are essential and which can be skipped. However, this creates a classic dilemma: a tendency to be impatient and move so fast that you skip essential steps, forcing you to go back and fix them, which triggers Frustration and Anger.',
              'Your Strategy is to Wait to Respond, and then Inform before initiating action. You have an open and enveloping aura that draws life to you. Others must ask you yes/no questions so your Sacral can respond through primal guttural sounds: "Ah-huh" (yes) or "Uhn-uh" (no).',
              'The secret to success for you is to never initiate purely from the mind. Wait for a sign from life, listen to your gut response, inform those who will be impacted, and then unleash your incredible manifesting power.'
            ]
          };
        case 'Generator':
          return {
            'title': 'Chapter 2: Your Type and Strategy',
            'subtitle': 'Generator - The Builders and Vital Life Force of the Planet',
            'paragraphs': [
              'As a Generator with a defined Sacral Center and no motor directly connected to the Throat, you represent approximately 36% of the population. Generators are the great builders and the sustained creative engine of humanity.',
              'Your life force is designed to respond to external stimuli. You find fulfillment through dedicated mastery of work that you love. When you initiate from mental ambition, you inevitably meet resistance and suffer from Frustration. When you wait to respond, you experience the signature of deep Satisfaction.',
              'Your Sacral answers moment-to-moment with organic gut sounds: "Ah-huh" (yes), "Uhn-uh" (no), or silence (not now). Trust your visceral reaction over any logical pros-and-cons list.'
            ]
          };
        case 'Manifestor':
          return {
            'title': 'Chapter 2: Your Type and Strategy',
            'subtitle': 'Manifestor - The Initiators and Pathfinders',
            'paragraphs': [
              'Manifestors make up roughly 8-9% of humanity. You have an open Sacral Center and at least one motor connected to the Throat. You are designed to initiate action independently and impact the world around you.',
              'Your aura is closed and repelling, protecting your singular focus. Because others cannot read your aura easily, they may become suspicious or fearful of what you are about to do. That is why your Strategy is To Inform before taking action. Informing eliminates resistance, removes obstacles, and brings you peace instead of anger.'
            ]
          };
        case 'Projector':
          return {
            'title': 'Chapter 2: Your Type and Strategy',
            'subtitle': 'Projector - The Guides and Masters of Energy',
            'paragraphs': [
              'Projectors make up about 20% of the population. With an undefined Sacral Center and no motor to Throat, you are not here to be a worker bee. You are here to see, guide, organize, and direct the energy of others.',
              'Your aura is focused and penetrating, seeing directly into the core of others. Your Strategy is to Wait for Recognition and an authentic Invitation for major life arenas (love, career, home, partnerships). When invited, you experience true Success; when you push or initiate uninvited, you meet rejection and Bitterness.'
            ]
          };
        default: // Reflector
          return {
            'title': 'Chapter 2: Your Type and Strategy',
            'subtitle': 'Reflector - The Cosmic Mirrors and Discerners',
            'paragraphs': [
              'Reflectors are the rarest beings, making up barely 1% of humanity. With all 9 centers completely open, you are a mirror reflecting the health and harmony of your community.',
              'Your aura is resistant and sampling. Your Strategy is to wait through a full 28-day Lunar Cycle before making major life decisions, observing how each gate transited by the Moon shifts your perspective.'
            ]
          };
      }
    } else {
      switch (typeId) {
        case 'Manifesting_Generator':
          return {
            'title': 'Chương 2: Nhóm Năng Lượng & Chiến Lược Sống',
            'subtitle': 'Dạng Người Khởi Xướng - Vận Hành (Manifesting Generator): Cỗ Máy Đa Nhiệm Tốc Độ',
            'paragraphs': [
              'Với Trung tâm Sinh Khí (Đan Điền - Sacral) xác định và có dòng dẫn từ động cơ lên Trung tâm Tuệ Ngôn (Throat), bạn thuộc Nhóm Khởi Xướng - Vận Hành (chiếm khoảng 33% dân số thế giới). Bạn là sự dung hòa độc đáo giữa sức bền vô tận của Người Vận Hành và tốc độ bộc phát của Người Khởi Xướng.',
              'Mục đích tối thượng của bạn là làm việc và cống hiến trọn vẹn nguồn năng lượng sáng tạo mỗi ngày. Động cơ Đan Điền của bạn không bao giờ bỏ cuộc cho đến khi hoàn thành điều nó đã cam kết. Điều này mang lại sự Thỏa Mãn (Satisfaction) sâu sắc và một giấc ngủ hồi phục tái tạo tuyệt vời vào ban đêm.',
              'Nhờ kết nối động cơ lên Họng, bạn có khả năng nhảy cóc từ phản hồi sang hiện thực hóa trong chớp mắt. Bạn sở hữu món quà về sự tinh gọn: nhìn ra ngay bước nào cần thiết và bước nào có thể bỏ qua. Tuy nhiên, tốc độ này tạo ra cạm bẫy: sự thiếu kiên nhẫn khiến bạn đi quá nhanh, bỏ sót những mắt xích quan trọng, để rồi phải quay lại sửa chữa trong tâm trạng Bất Mãn và Giận Dữ.',
              'Chiến lược sống cốt lõi: Đáp Ứng và Thông Báo (Wait to Respond and Inform). Hào quang của bạn rộng mở và bao bọc, thu hút cơ hội đến. Hãy lắng nghe phản xạ dạ dày và âm thanh tự nhiên "Ừ hứ" (có) hoặc "Ừ ừ" (không). Sau khi cơ thể đồng thuận, hãy thông báo trước cho những người liên quan trước khi tăng tốc hành động.',
              'Bí quyết thành công: Đừng bao giờ dùng tâm trí để tự khởi xướng dự án mới. Hãy kiên nhẫn đợi đời sống đặt ra câu hỏi, để Đan Điền của bạn phản hồi, và bạn sẽ trở thành ngọn đuốc truyền cảm hứng mãnh liệt cho mọi người xung quanh.'
            ]
          };
        case 'Generator':
          return {
            'title': 'Chương 2: Nhóm Năng Lượng & Chiến Lược Sống',
            'subtitle': 'Dạng Người Vận Hành (Generator): Trái Tim Nuôi Dưỡng Sự Sống',
            'paragraphs': [
              'Với Đan Điền xác định và không có động cơ nối lên Họng, bạn thuộc Nhóm Vận Hành (chiếm 34-35% dân số). Bạn là lực lượng lao động bền bỉ, lành mạnh và là trái tim giữ nhịp sinh thái của cả hành tinh.',
              'Năng lượng của bạn được thiết kế để Đáp Ứng (Response). Khi bạn tự ý lao đi tìm việc hoặc khởi xướng từ suy nghĩ logic, bạn sẽ gặp phải sự kháng cự và rơi vào trạng thái Bất Mãn (Frustration). Nhưng khi bạn chờ cuộc đời mang cơ hội đến và phản hồi qua âm thanh Đan Điền ("Ừ hứ" / "Ừ ừ"), bạn sẽ tìm thấy sự Thỏa Mãn tột cùng.',
              'Bạn là bậc thầy trong lĩnh vực mình đam mê. Hãy làm những gì bạn thực sự yêu thích để mỗi ngày trôi qua là một ngày tái sinh năng lượng.'
            ]
          };
        case 'Manifestor':
          return {
            'title': 'Chương 2: Nhóm Năng Lượng & Chiến Lược Sống',
            'subtitle': 'Dạng Người Khởi Xướng (Manifestor): Người Tiên Phong Mở Đường',
            'paragraphs': [
              'Người Khởi Xướng chiếm khoảng 8-9% dân số. Bạn không có Đan Điền xác định nhưng có động cơ kết nối trực tiếp lên Tuệ Ngôn. Bạn sinh ra để khởi xướng các phong trào mới và tạo nên tác động to lớn lên xã hội.',
              'Hào quang của bạn kín đáo và đẩy lùi (Closed and Repelling), bảo vệ bạn khỏi sự can thiệp từ bên ngoài nhưng cũng dễ khiến người khác đề phòng. Chiến lược vàng của bạn là Thông Báo (Inform) trước khi hành động để xóa bỏ mọi rào cản và sống trong Bình An (Peace).'
            ]
          };
        case 'Projector':
          return {
            'title': 'Chương 2: Nhóm Năng Lượng & Chiến Lược Sống',
            'subtitle': 'Dạng Người Khai Vấn (Projector): Nhà Dẫn Đường Tinh Tế',
            'paragraphs': [
              'Người Khai Vấn chiếm khoảng 20% dân số. Bạn không sinh ra để cày cuốc như cỗ máy lao động. Món quà bẩm sinh của bạn là khả năng thấu suốt cơ chế vận hành năng lượng của người khác và dẫn dắt họ đạt hiệu suất cao nhất.',
              'Chiến lược sống: Chờ đợi Lời Mời và Sự Công Nhận đích thực trong các việc lớn (tình cảm, sự nghiệp, nơi ở). Khi được công nhận, bạn sẽ gặt hái Thành Công (Success) rực rỡ; khi cố xen vào cuộc sống người khác mà không có lời mời, bạn sẽ chuốc lấy sự Cay Đắng (Bitterness).'
            ]
          };
        default:
          return {
            'title': 'Chương 2: Nhóm Năng Lượng & Chiến Lược Sống',
            'subtitle': 'Dạng Người Phản Chiếu (Reflector): Tấm Gương Tâm Linh Của Vũ Trụ',
            'paragraphs': [
              'Người Phản Chiếu chỉ chiếm 1% dân số, là những sứ giả hiếm có sở hữu cả 9 trung tâm năng lượng hoàn toàn mở. Bạn là tấm gương phản chiếu chính xác sức khỏe và độ tinh khiết của cộng đồng.',
              'Chiến lược sống của bạn là Chờ đợi 28 ngày trọn vẹn của Chu kỳ Mặt Trăng để đón nhận sự sáng suốt trước các quyết định trọng đại.'
            ]
          };
      }
    }
  }

  // CHAPTER 3: AUTHORITY
  static Map<String, dynamic> getChapter3(String authId, bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 3: Your Authority',
        'subtitle': 'Your Decision Making Tool - Navigating Life with Body Intelligence',
        'paragraphs': [
          'The Human Design System teaches human beings how to live by their own authority; how to make decisions that are individually correct. Although we are all conditioned to seek approval and authority outside ourselves, and to make decisions from the mind, we do have a trustworthy personal Authority that we can actually rely on to make choices.',
          'Your strong and gifted mind tries to be the authority for your life, convinced that it knows what’s best for you. Your mind will use and think anything in order to maintain its semblance of control. You can make an ally of your mind by honoring your Authority. Practiced together with Strategy, these tools free the mind to observe the life of the Form as a relaxed, reflective passenger able to enjoy its ride.',
          'When you honor your Inner Authority, decisions become mechanical, honest, and grounded in somatic body awareness. Mental decision-making is rarely more than a 50/50 guess, and the mind is not a trustworthy guidance system for your personal life trajectory.'
        ]
      };
    } else {
      return {
        'title': 'Chương 3: La Bàn Quyết Định (Thẩm Quyền Bên Trong)',
        'subtitle': 'Thẩm Quyền Nội Tại: Cơ Chế Đưa Ra Quyết Định Đích Thực Của Cơ Thể',
        'paragraphs': [
          'Human Design chỉ dạy chúng ta cách sống dựa trên thẩm quyền thiêng liêng bên trong cơ thể thay vì trao quyền kiểm soát cho các áp lực định kiến bên ngoài. Chúng ta từ nhỏ đã bị điều kiện hóa để dùng trí não suy tính được mất, nhưng trí não sinh ra là để nghiên cứu, tích lũy thông tin cho người khác chứ không phải để tự định đoạt số phận của bạn.',
          'Khi tâm trí cố gắng làm cơ quan thẩm quyền, nó sẽ dựng lên hàng ngàn nỗi sợ: sợ thiếu thốn, sợ thất bại, sợ bị phán xét. Bạn giải phóng chính mình bằng cách đưa tâm trí về đúng vị trí của một "hành khách ngồi ghế sau ngắm cảnh" (Passenger Consciousness) và để cơ thể bạn tự điều khiển vô lăng.',
          'Quy tắc vàng: Với quyết định nhỏ, hãy lắng nghe tín hiệu cơ thể ngay lập tức. Với quyết định vừa, hãy ngủ qua một đêm để cảm xúc lắng lại. Với quyết định trọng đại (sự nghiệp, hôn nhân, đầu tư lớn), hãy dành đủ thời gian chiêm nghiệm theo đúng thứ bậc thẩm quyền của bạn.'
        ]
      };
    }
  }

  // CHAPTER 4: DEFINITION
  static Map<String, dynamic> getChapter4(String defId, bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 4: Definition',
        'subtitle': 'Single Definition - Wholeness of the Energy Circuitry',
        'paragraphs': [
          'Definition reveals how your defined life force flows through your circuitry. In Single Definition, all of your defined centers and channels form one unified, continuous circuit. There are no split islands of energy in your chart.',
          'Because your definition forms a constant, unbroken flow, you are self-contained. You do not need other people to bridge energetic gaps between centers. You digest and process information rapidly on your own.',
          'The primary area of learning for you lies in your open centers. Since your defined flow is steady, the open spaces become clear windows through which you observe and learn about the world without losing your core identity.'
        ]
      };
    } else {
      return {
        'title': 'Chương 4: Định Nghĩa Liên Kết',
        'subtitle': 'Phương Thức Liên Kết: Cấu Trúc Tuần Hoàn Năng Lượng Bản Mệnh',
        'paragraphs': [
          'Định nghĩa (Definition) mô tả cách các trung tâm và kênh kết nối với nhau trên đồ hình cơ thể. Có 5 dạng định nghĩa: Không liên kết (Reflector), Đơn (Single), Đôi (Split), Ba (Triple Split), và Bốn (Quadruple Split).',
          'Người có Liên Kết Đơn (Single Definition) sở hữu một mạng lưới các trung tâm xác định kết nối liền mạch thành một khối thống nhất. Bạn có tính tự lập cao, xử lý thông tin nhanh chóng và không phụ thuộc vào người khác để cảm thấy "trọn vẹn". Vùng học tập lớn nhất của bạn nằm ở các trung tâm mở.',
          'Người có Liên Kết Đôi hoặc Ba (Split Definition) có các cụm trung tâm rời nhau. Bạn thường cảm thấy mình có hai hoặc ba tính cách bên trong và vô thức bị thu hút bởi những người sở hữu cổng kết nối bắc cầu (bridge gates) giữa các vùng phân mảnh.'
        ]
      };
    }
  }

  // CHAPTER 5: INCARNATION CROSS AND PROFILE
  static Map<String, dynamic> getChapter5(String profile, String cross, bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 5: Your Incarnation Cross and Profile',
        'subtitle': 'Your Purpose and Life Costume - Profile $profile',
        'paragraphs': [
          'Each human being is an interactive aspect of the totality, with a unique contribution to make. Our life’s activity is expressed as our purpose and is captured in our Incarnation Cross ($cross) and lived out through our Profile, the costume we wear on the stage of life.',
          'Profile represents the binary consciousness of your design: the synthesis of your conscious Personality (black) and unconscious Design (red). Together, they define your archetypal character, interpersonal style, and learning curve.',
          'When you function as your differentiated self through Strategy and Authority, your Cross and Profile naturally take over your life. Fulfilling your purpose is not an intellectual goal, but a natural flowering of living awake as yourself.'
        ]
      };
    } else {
      return {
        'title': 'Chương 5: Hồ Sơ Nhân Dạng & Thánh Giá Hóa Thân',
        'subtitle': 'Sứ Mệnh Cuộc Đời & Vai Diễn Trên Sân Khấu Vũ Trụ - Hồ Sơ $profile',
        'paragraphs': [
          'Thánh Giá Hóa Thân (Incarnation Cross: $cross) đại diện cho mục đích cốt lõi mà linh hồn bạn chọn để trải nghiệm trong kiếp sống này. Nó chiếm 70% năng lượng định mệnh của bạn, được hình thành từ 4 cổng Mặt Trời và Trái Đất (Tính cách và Thiết kế).',
          'Hồ sơ nhân dạng ($profile) là trang phục và vai diễn bạn đảm nhận. Hào ý thức thể hiện cách bạn tự nhận thức về mình, trong khi Hào vô thức là cách cơ thể bạn tự nhiên vận hành và được thế giới xung quanh phản hồi.',
          'Hành trình của bạn được tôi luyện qua các bài học của 6 Hào: từ việc xây dựng nền móng cặn kẽ (Hào 1), trau dồi tài năng ẩn dật (Hào 2), học hỏi qua trải nghiệm thực chứng thử-sai (Hào 3), kết nối cơ hội qua mạng lưới bạn bè (Hào 4), giải quyết khủng hoảng thực tế (Hào 5) đến việc bước lên mái nhà quan sát và trở thành hình mẫu sống chân thật (Hào 6).'
        ]
      };
    }
  }

  // CHAPTER 6: CENTERS WITH NOT-SELF MONOLOGUES
  static Map<String, dynamic> getChapter6(List<String> defined, List<String> undefined, bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 6: Your Centers',
        'subtitle': 'The Student and the Classroom of Life - 9 Energy Hubs',
        'paragraphs': [
          'The nine centers are energy hubs that transform and transmute the life force as it flows through the BodyGraph. Defined centers have consistent, fixed energy that broadcasts outward. Undefined (open) centers are where you absorb and amplify frequencies from the world.',
          'Your Defined Centers (${defined.length}): These are your innate, reliable strengths. You can always count on these energies to remain consistent regardless of who you are with.',
          'Your Undefined Centers (${undefined.length}): These are not broken or empty. They are your greatest learning centers and the source of your maturing wisdom when you do not identify with the incoming conditioning.',
          'Not-Self Mental Monologues in Open Centers: When conditioned, the mind creates deceptive inner monologues trying to resolve the open pressure:',
          '• Open Root Center: "I have to hurry up and get this done. I need to get rid of this pressure."',
          '• Open Solar Plexus Center: "I don’t want to go there because I don’t want confrontation. I better say it nicely so they like me."',
          '• Open Heart / Ego Center: "I have to prove my worth. I have to make promises so people see how valuable I am."',
          '• Open Spleen Center: "I’m holding on to this relationship because I’m afraid of being alone, even though it hurts me."',
          '• Open Ajna Center: "I have to pretend I am certain. I must figure out the answers right now."',
          '• Open Head Center: "I need to answer everyone’s questions. I am obsessing over things that don’t even matter to my life."'
        ]
      };
    } else {
      return {
        'title': 'Chương 6: Phân Tích Chuyên Sâu 9 Trung Tâm Năng Lượng',
        'subtitle': 'Lớp Học Cuộc Đời: Sức Mạnh Bẩm Sinh & Vùng Giải Tỏa Áp Lực Phi Ngã',
        'paragraphs': [
          '9 Trung tâm năng lượng trong Human Design là những trạm biến áp điều phối toàn bộ sinh lực cơ thể, tương ứng trực tiếp với hệ nội tiết và các cơ quan sinh học. Trung tâm xác định mang nguồn năng lượng cố định, ổn định; trung tâm mở là nơi tiếp nhận và khuếch đại năng lượng từ bên ngoài.',
          'Các Trung Tâm Xác Định (${defined.length}): Đây là nguồn sức mạnh bẩm sinh đáng tin cậy nhất của bạn. Bạn luôn có thể dựa vào nguồn lực này mà không sợ bị cạn kiệt hay biến mất.',
          'Các Trung Tâm Mở (${undefined.length}): Đây không phải là điểm yếu hay khiếm khuyết. Đây là nơi bạn đón nhận sự đa dạng của nhân loại và tích lũy trí tuệ sâu sắc nhất, miễn là bạn không tự đồng hóa năng lượng của người khác thành của mình.',
          'ĐẶC BIỆT: TIẾNG NÓI ĐỐI THOẠI NỘI TÂM PHI NGÃ (Not-Self Mental Monologue) TẠI CÁC TRUNG TÂM MỞ:',
          '• Trung tâm Gốc mở: "Tôi phải vội vã làm cho xong việc này. Tôi không thể chịu nổi áp lực này nữa, phải giải quyết ngay lập tức!"',
          '• Trung tâm Thái Dương mở: "Tôi không muốn nói sự thật vì sợ làm họ buồn. Tôi phải giả vờ cười nói để tránh mọi xung đột đối đầu."',
          '• Trung tâm Tâm Ngã (Tim) mở: "Tôi phải cố gắng làm nhiều hơn nữa để chứng minh giá trị bản thân. Tôi phải hứa hẹn để người khác thấy tôi đáng tin cậy."',
          '• Trung tâm Sinh Giác (Lách) mở: "Tôi không dám buông bỏ mối quan hệ/công việc độc hại này vì sợ không có nó tôi sẽ bất an và không sống nổi."',
          '• Trung tâm Tuệ Nhãn mở: "Tôi phải tỏ ra là mình luôn chắc chắn 100%. Tôi phải tìm ra câu trả lời logic cho mọi thứ."',
          '• Trung tâm Trí Huệ mở: "Tôi đang cố gắng trả lời và suy nghĩ về những câu hỏi thậm chí chẳng liên quan gì đến cuộc đời mình."'
        ]
      };
    }
  }

  // CHAPTER 7: CHANNELS
  static Map<String, dynamic> getChapter7(List<dynamic> activeChannels, bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 7: Your Channels',
        'subtitle': 'The Life Force Within - Active Channels of Consciousness',
        'paragraphs': [
          'Understanding channels opens the door to understanding your unique life force. A channel establishes communication between two centers, defining specific gifts, talents, and behavioral patterns that remain active throughout your entire life.',
          'You have ${activeChannels.length} fully activated channels in your chart. Each channel carries a vital genetic imprint that must be expressed authentically without the not-self distortion of mental interference.',
          ...activeChannels.map((ch) {
            final id = ch['id'] ?? '';
            final name = ch['name_en'] ?? ch['name_vi'] ?? '';
            final desc = ch['desc_en'] ?? ch['description'] ?? '';
            return '• Channel $id ($name): $desc';
          })
        ]
      };
    } else {
      return {
        'title': 'Chương 7: Các Kênh Năng Lượng Kích Hoạt',
        'subtitle': 'Dòng Chảy Sinh Mệnh: Những Tài Năng Thiên Bẩm Của Bản Mệnh',
        'paragraphs': [
          'Kênh năng lượng kết nối hai trung tâm với nhau, tạo nên một dòng sinh lực ổn định và định hình nên những tài năng cốt lõi của bạn. Khi một kênh được kích hoạt, nó kích hoạt luôn cả hai trung tâm ở hai đầu kênh.',
          'Lá số của bạn sở hữu ${activeChannels.length} kênh kích hoạt hoàn toàn. Đây là những đường dẫn năng lượng định hình phong cách làm việc, lãnh đạo, giao tiếp và tình cảm của bạn.',
          ...activeChannels.map((ch) {
            final id = ch['id'] ?? '';
            final name = ch['name_vi'] ?? '';
            final desc = ch['desc_vi'] ?? ch['description'] ?? '';
            return '• Kênh $id ($name): $desc';
          })
        ]
      };
    }
  }

  // CHAPTER 8: PLANETS, GATES AND LINES
  static Map<String, dynamic> getChapter8(Map<String, dynamic> activations, bool isEn) {
    final pBodies = activations['personality'] as Map<String, dynamic>? ?? {};
    final dBodies = activations['design'] as Map<String, dynamic>? ?? {};

    if (isEn) {
      return {
        'title': 'Chapter 8: Your Planets, Gates and Lines',
        'subtitle': 'The Programming Agents and Imprinted Genetic Traits',
        'paragraphs': [
          'The Sun, Moon, Nodes and planets are the programming agents of our solar system. The Personality (black) activations are experienced consciously, while the Design (red) activations are experienced somatically through the physical body.',
          '• Sun ☉ (Life Force): Personality Gate ${pBodies["Sun"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Sun"]?["gate_line_str"] ?? "N/A"}. Represents your primary radiant vitality and the core theme of your incarnation.',
          '• Earth ♁ (Grounding & Balance): Personality Gate ${pBodies["Earth"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Earth"]?["gate_line_str"] ?? "N/A"}. Provides the grounding stability that anchors the solar energy into physical reality.',
          '• Moon ☽ (Driving Force): Personality Gate ${pBodies["Moon"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Moon"]?["gate_line_str"] ?? "N/A"}. What drives and moves you deeply from within.',
          '• North Node ☊ (Future Direction): Personality Gate ${pBodies["North_Node"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["North_Node"]?["gate_line_str"] ?? "N/A"}. The mature phase of life and where you grow toward.',
          '• South Node ☋ (Past Foundation): Personality Gate ${pBodies["South_Node"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["South_Node"]?["gate_line_str"] ?? "N/A"}. Your past conditioning, natural familiarity, and developmental stage.',
          '• Mercury ☿ (Communication): Personality Gate ${pBodies["Mercury"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Mercury"]?["gate_line_str"] ?? "N/A"}. What you need to communicate and express to the world.',
          '• Venus ♀ (Values & Morals): Personality Gate ${pBodies["Venus"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Venus"]?["gate_line_str"] ?? "N/A"}. What you cherish, your relational values, and moral boundaries.',
          '• Mars ♂ (Immature Energy): Personality Gate ${pBodies["Mars"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Mars"]?["gate_line_str"] ?? "N/A"}. Extraordinary explosive force that matures into empowering strength.',
          '• Jupiter ♃ (Law & Protection): Personality Gate ${pBodies["Jupiter"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Jupiter"]?["gate_line_str"] ?? "N/A"}. Your personal spiritual law that brings expansion and good fortune.',
          '• Saturn ♄ (The Judge & Discipline): Personality Gate ${pBodies["Saturn"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Saturn"]?["gate_line_str"] ?? "N/A"}. Where you must face consequences and master discipline.',
          '• Uranus ♅ (Unusualness & Order): Personality Gate ${pBodies["Uranus"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Uranus"]?["gate_line_str"] ?? "N/A"}. Where you express your authentic genius and unconventional uniqueness.',
          '• Neptune ♆ (Illusion & Spirituality): Personality Gate ${pBodies["Neptune"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Neptune"]?["gate_line_str"] ?? "N/A"}. Mystical surrender, dissolving illusions to reach pure spiritual essence.',
          '• Pluto ♇ (Truth & Rebirth): Personality Gate ${pBodies["Pluto"]?["gate_line_str"] ?? "N/A"} | Design Gate ${dBodies["Pluto"]?["gate_line_str"] ?? "N/A"}. Deep psychological transformation, bringing subconscious truths to light.'
        ]
      };
    } else {
      return {
        'title': 'Chương 8: Các Hành Tinh, Cổng & Hào Bản Mệnh',
        'subtitle': '13 Thực Thể Thiên Văn Khắc Ghi Bản Đồ Năng Lượng Của Bạn',
        'paragraphs': [
          'Vị trí của 13 thiên thể vào thời điểm bạn sinh ra (Ý thức - Vàng) và 88 ngày trước sinh (Vô thức - Đỏ) tạo nên toàn bộ các cổng và hào kích hoạt trong DNA của bạn.',
          '• Mặt Trời ☉ (Nguồn Sống & Sứ Mệnh): Ý thức Cổng ${pBodies["Sun"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Sun"]?["gate_line_str"] ?? "N/A"}. Đại diện cho 70% luồng hạt neutrino định hình con người bạn, là ánh sáng bạn tỏa rạng ra thế giới.',
          '• Trái Đất ♁ (Điểm Tựa Cân Bằng): Ý thức Cổng ${pBodies["Earth"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Earth"]?["gate_line_str"] ?? "N/A"}. Là cột sống vững chãi giúp bạn hiện thực hóa năng lượng Mặt Trời vào thế giới vật chất.',
          '• Mặt Trăng ☽ (Động Lực Thúc Đẩy): Ý thức Cổng ${pBodies["Moon"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Moon"]?["gate_line_str"] ?? "N/A"}. Nguồn lực bên trong thôi thúc bạn chuyển động và trải nghiệm cuộc sống.',
          '• Nút Bắc ☊ (Định Hướng Trưởng Thành): Ý thức Cổng ${pBodies["North_Node"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["North_Node"]?["gate_line_str"] ?? "N/A"}. Đại diện cho nửa sau cuộc đời (từ tuổi 38-43 trở đi), là môi trường bạn tiến tới.',
          '• Nút Nam ☋ (Môi Trường Quá Khứ): Ý thức Cổng ${pBodies["South_Node"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["South_Node"]?["gate_line_str"] ?? "N/A"}. Nền tảng quen thuộc của giai đoạn đầu đời mà bạn đã tích lũy kinh nghiệm.',
          '• Sao Thủy ☿ (Giao Tiếp & Biểu Đạt): Ý thức Cổng ${pBodies["Mercury"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Mercury"]?["gate_line_str"] ?? "N/A"}. Thông điệp quan trọng nhất mà linh hồn bạn cần chia sẻ với thế giới.',
          '• Sao Kim ♀ (Giá Trị & Đạo Đức): Ý thức Cổng ${pBodies["Venus"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Venus"]?["gate_line_str"] ?? "N/A"}. Tiêu chuẩn về cái đẹp, tình yêu, sự gắn kết và các quy tắc đạo đức bất khả xâm phạm.',
          '• Sao Hỏa ♂ (Năng Lượng Bùng Nổ): Ý thức Cổng ${pBodies["Mars"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Mars"]?["gate_line_str"] ?? "N/A"}. Nguồn năng lượng mãnh liệt cần được tinh luyện qua thời gian để trở thành sức mạnh vững chãi.',
          '• Sao Mộc ♃ (Luật Lệ & Phúc Lành): Ý thức Cổng ${pBodies["Jupiter"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Jupiter"]?["gate_line_str"] ?? "N/A"}. Quy luật tâm linh mang lại may mắn và sự thịnh vượng khi bạn sống đúng bản chất.',
          '• Sao Thổ ♄ (Kỷ Luật & Thẩm Phán): Ý thức Cổng ${pBodies["Saturn"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Saturn"]?["gate_line_str"] ?? "N/A"}. Nơi bạn phải đối diện với bài học trách nhiệm và sự kiên nhẫn khắc nghiệt.',
          '• Sao Thiên Vương ♅ (Độc Đáo & Khai Sáng): Ý thức Cổng ${pBodies["Uranus"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Uranus"]?["gate_line_str"] ?? "N/A"}. Nơi bộc lộ phẩm chất khác biệt phi thường và sự cách tân của bạn.',
          '• Sao Hải Vương ♆ (Trực Giác & Buông Bỏ): Ý thức Cổng ${pBodies["Neptune"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Neptune"]?["gate_line_str"] ?? "N/A"}. Chiếc màn che huyền bí đòi hỏi bạn phải đầu hàng và tin tưởng tuyệt đối vào tâm linh.',
          '• Sao Diêm Vương ♇ (Chân Lý & Tái Sinh): Ý thức Cổng ${pBodies["Pluto"]?["gate_line_str"] ?? "N/A"} | Thiết kế Cổng ${dBodies["Pluto"]?["gate_line_str"] ?? "N/A"}. Chân lý sâu thẳm trong bóng tối giúp bạn lột xác và tái sinh mạnh mẽ.'
        ]
      };
    }
  }

  // CHAPTER 9: SUMMARY
  static Map<String, dynamic> getChapter9(bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 9: Summary & Awakening',
        'subtitle': 'From the Founder of The Human Design System - Ra Uru Hu',
        'paragraphs': [
          'In 1781, coincidental to the discovery of Uranus, a momentous event took place: the advent of the nine-centered being. We are 9-centered beings, transitional forms known as "Homo Sapien in Transitus".',
          'Human Design is about transforming your life by making decisions as yourself, not from the mind. It is Type that reveals the mechanical Strategy and Authority derived from your body, your vehicle, your Design consciousness.',
          'This is the great experiment that defines Human Design. Experiment with your Strategy & Authority. Free your mind to see and discover the beauty of your unique purpose by making decisions as yourself, one at a time.',
          'Love Yourself. - Ra Uru Hu'
        ]
      };
    } else {
      return {
        'title': 'Chương 9: Tổng Kết & Con Đường Tỉnh Thức',
        'subtitle': 'Lời Nhắn Nhủ Từ Người Sáng Lập Hệ Thống Human Design - Ra Uru Hu',
        'paragraphs': [
          'Vào năm 1781, sự xuất hiện của thực thể 9 trung tâm đã đánh dấu bước chuyển mình tiến hóa vĩ đại của nhân loại từ loài người 7 luân xa cổ xưa sang loài người chuyển tiếp "Homo Sapien in Transitus".',
          'Human Design không nhằm mục đích biến bạn thành một ai đó hoàn hảo theo tiêu chuẩn xã hội. Mục đích tối thượng là giúp bạn buông bỏ những kỳ vọng giả tạo để can đảm sống đúng với thiết kế nguyên bản của mình.',
          'Cuộc sống thực sự bắt đầu khi bạn trao quyền dẫn đường cho trí tuệ cơ thể thông qua Chiến lược và Thẩm quyền. Hãy để tâm trí của bạn thư giãn, thưởng thức bộ phim cuộc đời như một vị hành khách thông thái.',
          'Hãy yêu thương chính mình một cách trọn vẹn nhất. - Ra Uru Hu'
        ]
      };
    }
  }

  // CHAPTER 10: RESOURCES
  static Map<String, dynamic> getChapter10(bool isEn) {
    if (isEn) {
      return {
        'title': 'Chapter 10: Resources & Next Steps',
        'subtitle': 'Recommended Steps to Living Your Design',
        'paragraphs': [
          'Step 1: Practice your Strategy and Authority every single day in minor decisions before tackling life-changing choices.',
          'Step 2: Observe the Not-Self voices in your open centers without reacting or judging yourself.',
          'Step 3: Connect with family and partners through awareness of your composite dynamics and respect their differences.',
          'Step 4: Deepen your knowledge with the official IHDS literature and "The Definitive Book of Human Design".'
        ]
      };
    } else {
      return {
        'title': 'Chương 10: Tài Nguyên & Lộ Trình Thực Hành',
        'subtitle': 'Những Bước Tiếp Theo Để Sống Thuận Thiết Kế Bản Mệnh',
        'paragraphs': [
          'Bước 1: Thực hành Chiến lược sống và Thẩm quyền hàng ngày từ những việc nhỏ nhặt nhất (ăn gì, đi đâu, nói chuyện với ai) trước khi áp dụng cho các quyết định lớn.',
          'Bước 2: Học cách quan sát những tiếng nói phi ngã tại các trung tâm mở mà không phản ứng hay phán xét bản thân.',
          'Bước 3: Chia sẻ góc nhìn Human Design với người thân và đối tác để thấu hiểu và tôn trọng sự khác biệt năng lượng giữa hai người.',
          'Bước 4: Nghiên cứu chuyên sâu cuốn sách "Human Design Cho Người Mới Bắt Đầu" của TH Group - Tinh Hoa Bản Mệnh để khai mở trọn vẹn 64 cổng và 36 kênh.'
        ]
      };
    }
  }
}
