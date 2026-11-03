"""
Tạo cơ sở dữ liệu cho 64 CỔNG KẾT NỐI (GATES)
Dựa trên Chương 6 của sách 'Human Design Cho Người Mới Bắt Đầu'
"""
import json
import os
import sys

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

DATA_DIR = r"C:\HumanDesign\core\data"

# Mapping 64 Gates to Centers
GATE_TO_CENTER = {
    64: "Head", 61: "Head", 63: "Head",
    47: "Ajna", 24: "Ajna", 4: "Ajna", 17: "Ajna", 43: "Ajna", 11: "Ajna",
    62: "Throat", 23: "Throat", 56: "Throat", 35: "Throat", 12: "Throat", 45: "Throat", 33: "Throat", 8: "Throat", 31: "Throat", 20: "Throat", 16: "Throat",
    7: "G_Center", 1: "G_Center", 13: "G_Center", 25: "G_Center", 46: "G_Center", 2: "G_Center", 15: "G_Center", 10: "G_Center",
    21: "Heart", 51: "Heart", 26: "Heart", 40: "Heart",
    36: "Solar_Plexus", 22: "Solar_Plexus", 37: "Solar_Plexus", 6: "Solar_Plexus", 49: "Solar_Plexus", 55: "Solar_Plexus", 30: "Solar_Plexus",
    5: "Sacral", 14: "Sacral", 29: "Sacral", 34: "Sacral", 27: "Sacral", 42: "Sacral", 3: "Sacral", 9: "Sacral", 59: "Sacral",
    48: "Spleen", 57: "Spleen", 44: "Spleen", 50: "Spleen", 32: "Spleen", 28: "Spleen", 18: "Spleen",
    53: "Root", 60: "Root", 52: "Root", 19: "Root", 39: "Root", 41: "Root", 54: "Root", 38: "Root", 58: "Root"
}

# Thông tin chi tiết các Cổng theo chuẩn sách tác giả
# Mỗi cổng gồm: gate_num, name_vi, hexagram, potential, circuit, quarter, high_energy, low_energy, voice, relationship, advice
GATES_INFO = {
    1: {
        "name_vi": "Sự Thể Hiện", "hexagram": "Sự Sáng Tạo (Thuần Càn)", "potential": "Sáng tạo, độc đáo",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Sáng tạo", "Nghệ thuật", "Mới mẻ", "Độc đáo", "Sống chân thật", "Trí tưởng tượng"],
        "low_energy": ["Sầu muộn", "Chán nản", "Trì trệ", "Điên cuồng", "Khó lường", "Đồng hóa bản thân"],
        "voice": "Không gì tệ hơn khi có người nói với tôi rằng tôi khiến họ nhớ đến ai đó.",
        "relationship": "Đề cao cá tính độc đáo trong quan hệ, tìm kiếm kết nối cho phép bộc lộ bản thân không bị phán xét.",
        "advice": "Nuôi dưỡng sự kiên nhẫn, khoan dung, tôn trọng cá tính người khác và học cách tĩnh lặng khi năng lượng lắng xuống."
    },
    2: {
        "name_vi": "Sự Tiếp Nhận", "hexagram": "Sự Nhạy Bén (Thuần Khôn)", "potential": "Định hướng",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Tầm nhìn", "Định hướng", "Giá trị bản thân", "Niềm tin", "Sự chân thành", "Cách sử dụng tài nguyên"],
        "low_energy": ["Thỏa hiệp vì người khác", "Sử dụng bừa bãi", "Kiệt sức", "Từ chối sự hỗ trợ", "Kiểm soát tài nguyên"],
        "voice": "Ở đây tôi nhìn thấy nhiều điều. Tôi tin rằng bạn cần phải thay đổi, đơn giản là bạn đang đi sai đường.",
        "relationship": "Ý thức mạnh mẽ về sự định hướng, truyền cảm hứng và dẫn dắt người khác khám phá bản thân.",
        "advice": "Cân bằng giữa tự định hướng và sự cởi mở với người khác, trân trọng giá trị tự nhiên của bản thân."
    },
    3: {
        "name_vi": "Sự Sắp Xếp", "hexagram": "Khởi Đầu Nan (Thủy Lôi Truân)", "potential": "Đột phá",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khởi đầu (1)",
        "high_energy": ["Sự mới mẻ", "Sự học hỏi", "Sự khác lạ", "Sự trong sáng", "Sự biến đổi", "Tác nhân thay đổi"],
        "low_energy": ["Trở ngại", "Khởi đầu khó khăn", "Vội vàng", "Tỉ mỉ", "Ám ảnh", "Khó chấp nhận sự thay đổi"],
        "voice": "Nhiều thứ làm tôi thấy choáng ngợp. Tôi ước có thể làm nên điều mới mẻ.",
        "relationship": "Mang lại sự ngẫu hứng và góc nhìn mới mẻ trong quan hệ, thúc đẩy bước ra khỏi vùng an toàn.",
        "advice": "Kiên nhẫn trước sự hỗn loạn ban đầu, giao tiếp hiệu quả để tránh hiểu lầm."
    },
    4: {
        "name_vi": "Sự Chuẩn Tắc", "hexagram": "Sự Bồng Bột Tuổi Trẻ (Sơn Thủy Mông)", "potential": "Theses (Giả thuyết)",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đối lập (3)",
        "high_energy": ["Người giải quyết vấn đề", "Tính khả thi", "Kiến thức", "Tiềm năng", "Sự hiểu biết"],
        "low_energy": ["Mê tín", "Đa nghi", "Phán xét", "Thảm họa", "Nghi ngờ", "Lo lắng", "Soi mói"],
        "voice": "Mình biết câu trả lời cho điều đó. Đây là điều chúng ta nên làm. Mình nên giảm bớt nghi ngờ về mọi thứ nhưng...",
        "relationship": "Tìm kiếm sự rõ ràng và thấu hiểu trong các mối quan hệ, mong muốn đối thoại sâu sắc.",
        "advice": "Nhớ rằng câu trả lời chỉ là giả thuyết, cần thời gian kiểm chứng; học cách chấp nhận sự bí ẩn của con người."
    },
    5: {
        "name_vi": "Nhịp Điệu", "hexagram": "Sự Chờ Đợi (Thủy Thiên Nhu)", "potential": "Nhịp điệu",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đột phá (4)",
        "high_energy": ["Sự kiên định", "Sự trao quyền", "Thói quen", "Sự ổn định", "Khuôn phép", "Sự nhịp nhàng"],
        "low_energy": ["Hách dịch", "Soi mói", "Nóng vội", "Quá tải", "Khắt khe"],
        "voice": "Tôi rất thất vọng với cách họ thể hiện. Họ không bao giờ nhất quán, và điều đó khiến tôi phát bực...",
        "relationship": "Là đối tác đáng tin cậy, đề cao sự bền vững và nhịp điệu tương tác ổn định.",
        "advice": "Không để thói quen trở thành sự áp đặt lên người khác; linh hoạt thích nghi với các tình huống mới."
    },
    6: {
        "name_vi": "Tính Đối Kháng", "hexagram": "Sự Mâu Thuẫn (Thiên Thủy Tụng)", "potential": "Ngoại giao",
        "circuit": "Bộ lạc - Phòng thủ", "quarter": "Đối lập (3)",
        "high_energy": ["Sự thân mật", "Ranh giới", "Phá vỡ rào cản", "Khéo léo", "Bình tĩnh"],
        "low_energy": ["Phòng vệ", "Phán xét", "Tỏ rõ sự yếu kém", "Thiếu tế nhị", "Kiểm soát quá mức", "Quản lý chi li"],
        "voice": "Tôi chưa cảm thấy sẵn sàng để thử điều đó vì nó đòi hỏi tôi phải thực sự bước ra khỏi vùng an toàn của mình.",
        "relationship": "Điều hướng dòng chảy cảm xúc trong quan hệ, quyết định mở lòng hay khép kín đối với sự thân mật.",
        "advice": "Quản lý xung đột một cách xây dựng, tôn trọng thời điểm sẵn sàng của đối phương."
    },
    7: {
        "name_vi": "Định Hướng", "hexagram": "Kỷ Luật (Địa Thủy Sư)", "potential": "Chiến lược",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đối lập (3)",
        "high_energy": ["Hướng dẫn", "Hợp tác", "Phụ tá đắc lực", "Phụng sự", "Hướng đến tương lai"],
        "low_energy": ["Độc đoán", "Giống kẻ thống trị", "Ghen tị", "Áp đảo", "Theo trào lưu"],
        "voice": "Tôi có thể nhận thấy một vấn đề sẽ nảy sinh trong tương lai và chúng ta cần lập kế hoạch để giải quyết nó...",
        "relationship": "Đảm nhận vai trò người dẫn dắt đáng tin cậy, định hướng và hỗ trợ đối tác cùng tiến lên.",
        "advice": "Lãnh đạo thực sự là trao quyền và phục vụ cộng đồng, không ép buộc hay kiểm soát quyền lực."
    },
    8: {
        "name_vi": "Sự Cống Hiến", "hexagram": "Đoàn Kết (Thủy Địa Tỷ)", "potential": "Sự xúc tiến",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Tác nhân", "Quan hệ công chúng", "Sự biểu đạt", "Sự đóng góp", "Phong cách", "Sự tinh xảo"],
        "low_energy": ["Cố gắng quá mức", "Dễ tổn thương", "Thời điểm", "Thiếu mục đích", "Hy sinh bản thân", "Không chân thực"],
        "voice": "Tôi đã thấy được tài năng của bạn và tôi biết mình có thể giúp bạn phát huy tài năng theo cách này.",
        "relationship": "Bị thu hút bởi mối quan hệ cho phép bộc lộ sự độc đáo và trân trọng giá trị bản thân.",
        "advice": "Trước khi giúp người khác, hãy học cách yêu thương và tôn vinh chính mình; cân bằng giữa khẳng định ý tưởng và lắng nghe."
    },
    9: {
        "name_vi": "Sự Tập Trung", "hexagram": "Sức Mạnh Của Điều Nhỏ Bé (Phong Thiên Tiểu Súc)", "potential": "Sự tập trung",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đột phá (4)",
        "high_energy": ["Quyết tâm", "Chú ý", "Nhận dạng", "Sự tập trung", "Chi tiết", "Sự bền bỉ", "Tính kiên trì"],
        "low_energy": ["Sự bồn chồn", "Sự rối rắm", "Ám ảnh", "Mất tập trung", "Sự lo lắng", "Bỏ qua cơ hội"],
        "voice": "Tôi cảm thấy vô cùng thất vọng và dường như không thể tập trung năng lượng vào bất cứ điều gì...",
        "relationship": "Tập trung sâu sắc và thấu cảm với đối phương, nhưng cần giải thích chu kỳ tập trung để tránh bị hiểu nhầm là thờ ơ.",
        "advice": "Sử dụng Chiến lược và Quyền năng để chọn đúng việc đáng tập trung, dành thời gian nghỉ ngơi để không bị ám ảnh."
    },
    10: {
        "name_vi": "Hành Vi (Tình Yêu Bản Thân)", "hexagram": "Thận Trọng Tiến Bước (Thiên Trạch Lý)", "potential": "Sự chân thực",
        "circuit": "Cá nhân - Tập trung", "quarter": "Đột phá (4)",
        "high_energy": ["Tự trọng", "Yêu bản thân", "Can đảm", "Truyền cảm hứng", "Sự chấp nhận", "Sự bình đẳng"],
        "low_energy": ["Chán ghét bản thân", "Tự trở thành nạn nhân", "Tự ti", "Thụ động", "Đổ lỗi", "Nhạy cảm quá mức"],
        "voice": "Tôi là bản thể độc nhất. Tôi không giống bất kỳ ai, và đây chính là sức mạnh siêu phàm của tôi.",
        "relationship": "Truyền cảm hứng để đối tác sống chân thực với chính mình, xây dựng mối quan hệ tôn trọng bản sắc riêng.",
        "advice": "Yêu thương và chấp nhận bản thân trọn vẹn; tránh để sự tự tin biến thành kiêu ngạo hay thiếu khoan dung."
    },
    11: {
        "name_vi": "Ý Tưởng", "hexagram": "Sự Bình Yên (Địa Thiên Thái)", "potential": "Những ý tưởng",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đột phá (4)",
        "high_energy": ["Ý tưởng", "Sự ảo tưởng", "Sự bình yên", "Sự tương hỗ", "Quản lý ý tưởng", "Sự hòa hợp"],
        "low_energy": ["Sự u ám", "Thiếu hụt ý tưởng", "Bế tắc", "Vô vọng", "Cưỡng ép ý tưởng", "Lo lắng khi chia sẻ"],
        "voice": "Tôi có quá nhiều ý tưởng, và tôi không thể xác định mình muốn thực hiện ý tưởng nào, cái này hay cái kia...",
        "relationship": "Mang lại sự năng động và hứng khởi trí tuệ trong các mối quan hệ, kích thích tư duy mở rộng.",
        "advice": "Không phải mọi ý tưởng đều cần thực hiện ngay; ghi chép lại và chia sẻ đúng lúc khi được yêu cầu."
    },
    12: {
        "name_vi": "Sự Cẩn Ngôn", "hexagram": "Thiền Định (Thiên Địa Bĩ)", "potential": "Sự thích hợp",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Sự cẩn trọng", "Ngôn từ thấu suốt", "Giao tiếp sâu sắc", "Chân thành", "Biểu đạt nghệ thuật"],
        "low_energy": ["Im lặng tiêu cực", "Lời nói cay nghiệt", "E dè quá mức", "Áp đặt quan điểm", "Mất kết nối"],
        "voice": "Tôi cố gắng hết sức để hiểu mọi thứ xuất phát từ đâu.",
        "relationship": "Chọn lọc người để chia sẻ, thích trò chuyện sâu sắc chân thực hơn tán gẫu hời hợt.",
        "advice": "Học cách kiên nhẫn khi tâm trạng chưa sẵn sàng; khi cởi mở, lời nói của bạn có sức chuyển hóa rất lớn."
    },
    13: {
        "name_vi": "Sự Đồng Cảm (Người Lắng Nghe)", "hexagram": "Tình Anh Em (Thiên Hỏa Đồng Nhân)", "potential": "Sự quan tâm",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khởi đầu (1)",
        "high_energy": ["Lắng nghe", "Xâu chuỗi sự kiện", "Giữ bí mật", "Hiểu thấu những ẩn ý", "Sáng suốt", "Cảm thông"],
        "low_energy": ["Mắc kẹt", "Niềm tin hạn hẹp", "Tâm lý thù hận", "Ngồi lê đôi mách", "Sự bi quan", "Tư duy hẹp hòi"],
        "voice": "Chúng ta nên trao đổi với họ về văn hóa công ty vì họ dường như luôn nắm bắt được tình hình của mọi người.",
        "relationship": "Người bạn tâm tình đáng tin cậy, lắng nghe và nâng đỡ tinh thần người khác sâu sắc.",
        "advice": "Biết giữ bí mật và tôn trọng sự riêng tư của người khác; dành thời gian tĩnh lặng một mình để xả năng lượng."
    },
    14: {
        "name_vi": "Sự Xuất Sắc (Năng Lượng Của Cải)", "hexagram": "Sự Sở Hữu Lớn Lao (Hỏa Thiên Đại Hữu)", "potential": "Khả năng tiếp thu",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Hành động vì đam mê", "Tiền tài", "Quản lý tài lực", "Hình ảnh doanh nhân", "Sự giàu có"],
        "low_energy": ["Sự sợ hãi", "Bị vật chất chi phối", "Bị ràng buộc", "Sự sầu muộn", "Làm việc quá sức", "Sợ tiền tài"],
        "voice": "Tôi cảm thấy vô cùng thất vọng, như thể tôi đang quay vòng tại chỗ mà không biết đích đến.",
        "relationship": "Mang lại sự kiên định, chu cấp và bảo đảm nền tảng vật chất vững chắc cho người mình yêu thương.",
        "advice": "Tạo ra của cải thông qua việc làm điều mình say mê; không để vật chất chi phối hay kiệt sức vì công việc."
    },
    15: {
        "name_vi": "Tình Nhân Ái", "hexagram": "Sự Khiêm Nhường (Địa Sơn Khiêm)", "potential": "Sự linh hoạt",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khai hóa (2)",
        "high_energy": ["Chấp nhận", "Đón nhận sự đa dạng", "Hòa vào dòng chảy", "Hào quang mạnh mẽ", "Phá vỡ khuôn phép"],
        "low_energy": ["Chỉ trích cực đoan", "Sự nhất quán gượng ép", "Sự cân bằng gượng ép", "Trống rỗng", "Thích kiểm soát"],
        "voice": "Có ngày tôi dậy lúc 10:00, nhưng có khi tôi dậy lúc 5:00... Tôi nên có một thói quen nhưng tôi không thể duy trì được.",
        "relationship": "Mối quan hệ dao động giữa gắn kết mãnh liệt và cần khoảng cách độc lập, tình yêu thương nhân loại rộng mở.",
        "advice": "Tôn trọng nhịp điệu riêng biệt của bản thân, không ép mình vào các khuôn khổ cứng nhắc của xã hội."
    },
    16: {
        "name_vi": "Hoạt Ngôn (Nhiệt Huyết)", "hexagram": "Sự Nhiệt Tình (Lôi Địa Dự)", "potential": "Sự nhận diện",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khai hóa (2)",
        "high_energy": ["Nhiệt tình", "Tài năng", "Tinh thông", "Kinh nghiệm", "Dũng cảm", "Thực hành", "Đơn giản hóa"],
        "low_energy": ["Nóng vội", "Thiếu chuẩn bị", "Sự nhiệt tình của cái tôi", "Hoang tưởng"],
        "voice": "Dựa vào kinh nghiệm, tôi nghĩ rằng điều này hiệu quả nhất vì... Có lẽ tôi nên dành thêm chút thời gian...",
        "relationship": "Chia sẻ đam mê và kỹ năng với đối tác, truyền cảm hứng nhiệt huyết cho những người xung quanh.",
        "advice": "Dành thời gian rèn luyện để kỹ năng đạt độ chín muồi trước khi đem ra trình diễn hay hành động."
    },
    17: {
        "name_vi": "Ý Kiến", "hexagram": "Tuân Thủ (Trạch Lôi Tùy)", "potential": "Ý kiến",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khởi đầu (1)",
        "high_energy": ["Những khả năng", "Có sức ảnh hưởng", "Sự khai phá", "Phụng sự", "Chiến lược | Tầm nhìn xa"],
        "low_energy": ["Gặp trở ngại", "Nóng vội bày tỏ ý kiến", "Mất đi ý chí, động lực", "Sự bất chấp", "Sự xung đột"],
        "voice": "Theo tôi, tốt nhất chúng ta nên làm việc này trước rồi đến việc kia vì mục tiêu chung...",
        "relationship": "Mang lại sự rõ ràng logic và công bằng cho quan hệ, bày tỏ quan điểm cởi mở và thẳng thắn.",
        "advice": "Ý kiến chỉ là giả thuyết; học cách chia sẻ đúng thời điểm và tôn trọng góc nhìn của người khác."
    },
    18: {
        "name_vi": "Sự Điều Chỉnh", "hexagram": "Điều Chỉnh Những Hư Hỏng (Sơn Phong Cổ)", "potential": "Sự phán xét",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đối lập (3)",
        "high_energy": ["Tái điều chỉnh", "Sự tiến hóa", "Liên tục cải tiến", "Khôi phục niềm vui", "Người hoàn hảo"],
        "low_energy": ["Kén chọn, khó tính", "Hay phán xét", "Cảm thấy vượt trội", "Chỉ trích quá mức", "Chủ nghĩa hoàn hảo"],
        "voice": "Tôi biết chúng ta vừa ăn tối ở nhà hàng 5 sao, nhưng tôi nghĩ rằng họ có thể phục vụ tốt hơn vì...",
        "relationship": "Mong muốn hoàn thiện mối quan hệ nhưng dễ bị hiểu lầm là soi mói, chỉ trích đối phương.",
        "advice": "Chỉ đưa ra lời khuyên sửa chữa khi được yêu cầu; học cách chấp nhận những điều chưa hoàn hảo."
    },
    19: {
        "name_vi": "Nhu Cầu", "hexagram": "Tiếp Cận (Địa Trạch Lâm)", "potential": "Nhu cầu",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đột phá (4)",
        "high_energy": ["Nhạy cảm", "Có ý thức", "Nhạy cảm với nhu cầu tập thể", "Có tài tiếp xúc", "Hướng về cộng đồng"],
        "low_energy": ["Thiếu thốn", "Bị cô lập", "Quá nhạy cảm", "Phụ thuộc", "Tự hy sinh bản thân"],
        "voice": "Tôi rất ghét mỗi khi trong tủ lạnh không có gì. Tôi thích có sẵn thức ăn trong tủ hơn, phòng khi có ai đó ghé nhà.",
        "relationship": "Gắn kết sâu sắc, nhạy cảm với cảm xúc đối phương, luôn muốn chăm lo và bảo đảm sự đủ đầy.",
        "advice": "Học cách đáp ứng nhu cầu của chính mình trước khi lo cho người khác; tránh rơi vào sự đồng phụ thuộc."
    },
    20: {
        "name_vi": "Thực Tại (Hiện Diện)", "hexagram": "Chiêm Nghiệm (Phong Địa Quan)", "potential": "Sự tỉnh thức",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Sự hiện diện", "Chiêm nghiệm", "Người tìm kiếm tài năng", "Thời điểm thích hợp", "Kết nối mọi người"],
        "low_energy": ["Hời hợt", "Bất an", "Cố gắng tự làm mọi thứ", "Áp lực về thời gian", "Tránh mặt", "Bận rộn tất bật"],
        "voice": "Tôi đề cao việc đúng thời điểm trong cuộc sống của mình và tôi nghĩ bây giờ là lúc cần hành động.",
        "relationship": "Sống trọn vẹn trong khoảnh khắc hiện tại, phản ứng nhanh nhạy và thấu cảm với bạn đời.",
        "advice": "Kiên nhẫn chờ thời điểm đúng đắn; không để sự bận rộn bề nổi cuốn đi sự tỉnh thức trong khoảnh khắc."
    },
    21: {
        "name_vi": "Sự Kiên Định (Kiểm Soát)", "hexagram": "Vượt Khó (Hỏa Lôi Phệ Hạp)", "potential": "Quyền năng",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Khởi đầu (1)",
        "high_energy": ["Kiểm soát tài nguyên", "Tự do", "Uy quyền", "Biết quan tâm", "Đáng tin tưởng", "Người lãnh đạo"],
        "low_energy": ["Phục tùng", "Kiểm soát quá mức", "Sự năng nổ tiêu cực", "Chủ nghĩa vật chất", "Đấu tranh quyền lực"],
        "voice": "Tôi sẽ tự mình làm việc này vì tôi biết mình có thể làm tốt hơn.",
        "relationship": "Người quản lý và sắp xếp gia đình chu đáo, nhưng cần tránh áp đặt quyền kiểm soát lên bạn đời.",
        "advice": "Học cách buông bỏ bớt quyền kiểm soát, ủy quyền cho người khác để tránh kiệt sức."
    },
    22: {
        "name_vi": "Sự Chân Thành (Duyên Dáng)", "hexagram": "Sự Uyển Chuyển (Sơn Hỏa Bí)", "potential": "Tâm tính",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khởi đầu (1)",
        "high_energy": ["Sự uyển chuyển", "Tôn vinh bản thân", "Vẻ đẹp nội tại", "Nhận thức", "Sự dịu dàng", "Thính giác nhạy bén"],
        "low_energy": ["Tâm trạng thất thường", "Quá chăm chút bản thân", "Kiêu kỳ, đỏng đảnh", "Tẻ nhạt", "Tự phụ", "Sợ thay đổi"],
        "voice": "Tôi có nhiều điều muốn nói nhưng lại sợ rằng sẽ không có ai lắng nghe.",
        "relationship": "Duyên dáng, cuốn hút và lãng mạn; cần thời gian ở một mình khi tâm trạng đi xuống để tránh làm tổn thương người khác.",
        "advice": "Lắng nghe tâm trạng của mình; chỉ giao tiếp xã hội khi bạn thực sự cảm thấy thoải mái và cởi mở."
    },
    23: {
        "name_vi": "Sự Truyền Tải (Đơn Giản Hóa)", "hexagram": "Sự Chia Cắt (Sơn Địa Bác)", "potential": "Sự thông tỏ",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Giải thích mạch lạc", "Đơn giản hóa vấn đề", "Đột phá", "Khách quan", "Trí tuệ thực tiễn"],
        "low_energy": ["Diễn đạt rời rạc", "Quá phức tạp", "Bị hiểu lầm", "Bị khước từ", "Lập dị", "Không ai hiểu"],
        "voice": "Tôi biết điều này nghe có vẻ kỳ lạ, nhưng tôi có cảm giác rất mạnh mẽ rằng đã đến lúc làm điều đó.",
        "relationship": "Nói chuyện thẳng thắn, rõ ràng, giúp đối phương tháo gỡ những khúc mắc phức tạp.",
        "advice": "Chờ đợi lời mời trước khi giải thích; dùng ngôn từ đơn giản để truyền đạt những khái niệm trừu tượng."
    },
    24: {
        "name_vi": "Sự Tối Ưu (Hợp Lý Hóa)", "hexagram": "Sự Trở Về (Địa Lôi Phục)", "potential": "Sự chiêm nghiệm",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Lòng biết ơn", "Thấu hiểu quá khứ", "Điều tra tìm tòi", "Phát kiến sáng tạo", "Hợp lý hóa tích cực"],
        "low_energy": ["An phận", "Hợp lý hóa hành vi xấu", "Tái diễn chu kỳ suy nghĩ", "Cố chấp si mê", "Thiếu hiểu biết"],
        "voice": "Hãy để tôi giải thích. Tôi làm như vậy vì nhiều điều. Đây là cách làm hợp lý vì khi tôi làm vậy, nó sẽ thành hiện thực.",
        "relationship": "Sẵn sàng thảo luận sâu sắc về các vấn đề trong quan hệ, nhưng tránh phân tích quá mức cảm xúc của đối tác.",
        "advice": "Cho tâm trí thời gian tĩnh lặng để câu trả lời tự xuất hiện; không hợp lý hóa những hoàn cảnh tệ hại."
    },
    25: {
        "name_vi": "Tình Bác Ái (Trong Sáng)", "hexagram": "Sự Trong Sáng (Thiên Lôi Vô Vọng)", "potential": "Bản chất tự nhiên",
        "circuit": "Cá nhân - Tập trung", "quarter": "Khởi đầu (1)",
        "high_energy": ["Người chữa lành", "Trí tuệ", "Sự buông bỏ", "Tin cậy vị tha", "Tình yêu thiêng liêng", "Ý thức"],
        "low_energy": ["Mệt mỏi bồn chồn", "Chán nản", "Ích kỷ", "Lo âu hồi hộp", "Ngây thơ", "Căm ghét", "Lạnh lùng"],
        "voice": "Mặc dù điều đó đã xảy ra, nhưng nó mang đến cho tôi sự đồng cảm sâu sắc với bản thân và với người khác.",
        "relationship": "Mang lại tình yêu thuần khiết và sự chữa lành, nhìn thấy vẻ đẹp chân thật bên trong bạn đời.",
        "advice": "Bảo vệ trái tim nhạy cảm của mình, giữ vững niềm tin vào tình yêu ngay cả khi đối mặt với thử thách."
    },
    26: {
        "name_vi": "Khả Năng Lôi Kéo (Chiến Thuật)", "hexagram": "Sức Mạnh Tức Thời của Điều Lớn Lao (Sơn Thiên Đại Súc)", "potential": "Chiến thuật",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đột phá (4)",
        "high_energy": ["Tính hiệu quả", "Khả năng lôi kéo", "Chủ nghĩa tối giản", "Sự khéo léo", "Tính chân thực", "Bán hàng xuất sắc"],
        "low_energy": ["Nói dối", "Thao túng", "Ích kỷ vị kỷ", "Thiếu bản lĩnh", "Không thực hiện cam kết", "Tự ti"],
        "voice": "Tôi biết chúng ta có thể làm điều này theo cách hiệu quả hơn.",
        "relationship": "Thuyết phục và hòa giải khéo léo trong các bất đồng, tạo động lực cho đối phương phát triển.",
        "advice": "Thuyết phục xuất phát từ sự chính trực và tình yêu thương, không dùng xảo thuật để tư lợi."
    },
    27: {
        "name_vi": "Sự Quan Tâm (Nuôi Dưỡng)", "hexagram": "Sự Nuôi Dưỡng (Sơn Lôi Di)", "potential": "Sự quan tâm",
        "circuit": "Bộ lạc - Phòng thủ", "quarter": "Khởi đầu (1)",
        "high_energy": ["Sự nuôi dưỡng", "Sự chăm sóc", "Lòng vị tha", "Chăm sóc bản thân", "Giữ gìn", "Lòng từ bi"],
        "low_energy": ["Cảm giác tội lỗi", "Sự lệ thuộc", "Không có ranh giới", "Hy sinh bản thân", "Quan tâm quá mức"],
        "voice": "Tôi cảm thấy mệt mỏi và thất vọng với chính mình vì tôi chỉ biết chăm sóc cho mọi người trừ bản thân mình.",
        "relationship": "Chu đáo, quan tâm từng bữa ăn giấc ngủ của bạn đời, tạo môi trường gia đình ấm áp.",
        "advice": "Chăm sóc chính mình trước để có đủ năng lượng chăm sóc người khác; thiết lập ranh giới rõ ràng."
    },
    28: {
        "name_vi": "Sự Mạo Hiểm (Đấu Tranh)", "hexagram": "Ưu Thế của Điều Lớn Lao (Trạch Phong Đại Quá)", "potential": "Mạo hiểm",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đối lập (3)",
        "high_energy": ["Sự kiên trì", "Khả năng phục hồi", "Bản lĩnh", "Chấp nhận mạo hiểm", "Hành động ý nghĩa", "Dám đương đầu"],
        "low_energy": ["Sợ hãi", "Sống thiếu mục đích", "Không dám buông bỏ", "Cảm giác thất bại", "Tư duy nạn nhân", "Đau khổ kéo dài"],
        "voice": "Mục đích sống của tôi là gì? Điều gì xứng đáng để tôi sống vì nó?",
        "relationship": "Tìm kiếm các mối quan hệ sâu sắc, cùng nhau vượt qua giông bão để khẳng định giá trị tình yêu.",
        "advice": "Tin tưởng vào thời điểm thiêng liêng, biến khó khăn thành bài học trí tuệ và sức mạnh bền bỉ."
    },
    29: {
        "name_vi": "Sự Cam Kết", "hexagram": "Sự Sâu Thẳm (Thuần Khảm)", "potential": "Sự cam kết",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đối lập (3)",
        "high_energy": ["Quyết đoán", "Cam kết", "Kiên trì", "Có tính chu kỳ", "Quyết tâm", "Tận tụy"],
        "low_energy": ["Cam kết quá mức", "Không có cam kết", "Không đáng tin cậy", "Kiểm soát mọi thứ", "Kiệt sức"],
        "voice": "Tôi sẽ cố gắng hết sức để xem bản thân có làm được không.",
        "relationship": "Chung thủy, tận tụy và kiên định, là điểm tựa vững chãi trong mọi hoàn cảnh gia đình.",
        "advice": "Chỉ nói 'Có' khi Đan Điền thực sự bật đèn xanh; không ôm đồm cam kết để tránh kiệt sức."
    },
    30: {
        "name_vi": "Cảm Xúc Mãnh Liệt (Ngọn Lửa Khát Khao)", "hexagram": "Cảm Xúc Mãnh Liệt (Thuần Ly)", "potential": "Cảm xúc",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khởi đầu (1)",
        "high_energy": ["Đam mê", "Khao khát", "Sự mãnh liệt", "Nhẹ nhàng thanh thoát", "Tập trung đam mê", "Vô tư"],
        "low_energy": ["Quá tải kiệt sức", "Cường độ quá mức", "Do dự thiếu quyết đoán", "Không biết thỏa mãn", "Xung đột"],
        "voice": "Dường như tôi không thể giải thích được lý do vì sao tôi khao khát làm điều đó...",
        "relationship": "Yêu say đắm, mãnh liệt và đầy xúc cảm; cần kiên nhẫn để sóng cảm xúc không đốt cháy mối quan hệ.",
        "advice": "Chấp nhận cảm xúc đến và đi như những làn sóng; hướng niềm đam mê vào sáng tạo nghệ thuật."
    },
    31: {
        "name_vi": "Sự Dẫn Dắt (Thủ Lĩnh Dân Chủ)", "hexagram": "Sự Dẫn Dắt (Trạch Sơn Hàm)", "potential": "Sự ảnh hưởng",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khai hóa (2)",
        "high_energy": ["Đại diện cộng đồng", "Phục vụ cộng đồng", "Luôn lắng nghe", "Ảnh hưởng tốt", "Khiêm tốn", "Mạnh mẽ"],
        "low_energy": ["Tự cho mình biết tất cả", "Luôn muốn công nhận", "Cảm giác không xứng đáng", "Tránh né lãnh đạo", "Kiêu căng"],
        "voice": "Tôi trò chuyện cùng mọi người và tất cả chúng tôi đều tin rằng đây là điều tốt nhất...",
        "relationship": "Người dẫn dắt và kết nối các thành viên trong gia đình, thúc đẩy sự hòa hợp và thấu hiểu.",
        "advice": "Lãnh đạo bằng sự lắng nghe và phục vụ; chỉ nhận vai trò khi được mọi người công nhận và mời gọi."
    },
    32: {
        "name_vi": "Sự Duy Trì (Bảo Tồn)", "hexagram": "Thời Khắc (Lôi Phong Hằng)", "potential": "Sự liên tục",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đối lập (3)",
        "high_energy": ["Bảo tồn gìn giữ", "Thành công", "Tiền tài", "Tính liên tục", "Tính bền bỉ", "Khả năng chịu đựng"],
        "low_energy": ["Sợ hãi sự thất bại", "Do dự thiếu quyết đoán", "Bảo thủ", "Thiếu kiên nhẫn", "Huênh hoang", "Mất kết nối"],
        "voice": "Tôi biết đây sẽ là một sự đầu tư hiệu quả. Tôi cảm nhận được nó.",
        "relationship": "Xây dựng mối quan hệ bền vững lâu dài, trực giác tốt về tiềm năng phát triển của đối tác.",
        "advice": "Vượt qua nỗi sợ thất bại; hiểu rằng mọi sai lầm đều là nấc thang tôi luyện thành công."
    },
    33: {
        "name_vi": "Sự Riêng Tư (Ẩn Dật)", "hexagram": "Ẩn Dật (Thiên Sơn Độn)", "potential": "Sự cẩn trọng",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khai hóa (2)",
        "high_energy": ["Phản ánh quá khứ", "Kể những câu chuyện", "Tập hợp trải nghiệm", "Sự soi sáng", "Tĩnh lặng", "Trí tuệ"],
        "low_energy": ["Giữ chặt quá khứ", "Thiếu hụt", "Mắc kẹt trong quá khứ", "Kiệt sức", "Sai thời điểm", "Luôn phản bác"],
        "voice": "Tôi nhớ khi còn nhỏ chúng ta được dạy nên sống như thế nào... và tôi thấy điều đó giúp ích.",
        "relationship": "Cần không gian riêng tư để suy ngẫm; mang lại trí tuệ sâu sắc cho bạn đời qua những bài học quá khứ.",
        "advice": "Chia sẻ về nhu cầu cần khoảng lặng riêng tư với người thân để tránh bị hiểu nhầm là xa lánh."
    },
    34: {
        "name_vi": "Năng Lượng Bền Bỉ (Sức Mạnh)", "hexagram": "Sức Mạnh Của Sự Vĩ Đại (Lôi Thiên Đại Tráng)", "potential": "Sự mạnh mẽ",
        "circuit": "Cá nhân - Tập trung", "quarter": "Đột phá (4)",
        "high_energy": ["Mang đến sức mạnh", "Oai nghiêm", "Người cộng tác", "Người đa nhiệm", "Đúng thời điểm", "Có sức thuyết phục"],
        "low_energy": ["Hách dịch", "Sợ hãi", "Tự tiêu hao năng lượng", "Thiếu tự tin", "Cưỡng ép quyền lực", "Đấu tranh vũ lực"],
        "voice": "Bây giờ tôi chưa sẵn sàng làm điều đó vì tôi đang bận rộn với việc này.",
        "relationship": "Mang lại sự năng động và sinh lực tràn trề, chung thủy và sẵn sàng bảo vệ người mình yêu.",
        "advice": "Chỉ dồn sức cho những việc mình thực sự say mê; không cố gắng ép buộc mọi thứ diễn ra theo ý mình."
    },
    35: {
        "name_vi": "Sự Tiến Bộ (Thay Đổi)", "hexagram": "Sự Tiến Bộ (Hỏa Địa Tấn)", "potential": "Tiến bộ",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khai hóa (2)",
        "high_energy": ["Thử thách khám phá", "Trải nghiệm kể chuyện", "Trí tuệ", "Thay đổi", "Trải nghiệm mới", "Phiêu lưu"],
        "low_energy": ["Không thể nghỉ ngơi", "Tự tin thái quá", "Không thể hoàn thành", "Chán nản an phận", "Buồn vui thất thường"],
        "voice": "Tôi cảm thấy buồn chán nên muốn cố gắng làm điều gì đó mới mẻ.",
        "relationship": "Mang lại luồng gió mới, kích thích sự khám phá và cùng nhau trải nghiệm những điều mới lạ.",
        "advice": "Loại bỏ kỳ vọng kết quả, tập trung vào giá trị phong phú của hành trình trải nghiệm."
    },
    36: {
        "name_vi": "Sự Vượt Khó (Khủng Hoảng)", "hexagram": "Sự Tối Tăm Của Ánh Sáng (Địa Hỏa Minh Di)", "potential": "Lòng trắc ẩn",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khởi đầu (1)",
        "high_energy": ["Sâu sắc", "Cởi mở", "Cống hiến", "Khám phá", "Trí tuệ cảm xúc", "Sự rõ ràng", "Đi sâu vào chủ đề"],
        "low_energy": ["Hỗn loạn chỉ trích", "Tâm hồn lạc lối", "Căng thẳng lo âu", "Dễ tổn thương", "Hành động thiếu suy nghĩ"],
        "voice": "Tôi đang cảm thấy khó khăn trong việc kết nối với cảm xúc của mình, có lẽ tôi nên thử làm điều mới...",
        "relationship": "Cảm xúc mãnh liệt, đam mê sâu sắc; cùng nhau vượt qua khủng hoảng để trưởng thành.",
        "advice": "Kiên nhẫn chờ cảm xúc lắng xuống; không hành động bốc đồng khi đang ở đỉnh hoặc đáy cảm xúc."
    },
    37: {
        "name_vi": "Sự Hòa Đồng (Tình Thân)", "hexagram": "Tình Thân (Phong Hỏa Gia Nhân)", "potential": "Lòng trung thành",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Khởi đầu (1)",
        "high_energy": ["Lòng trung thành", "Thỏa thuận", "Bình yên nội tại", "Hướng về cộng đồng", "Hài hòa", "Nuôi dưỡng"],
        "low_energy": ["Yếu kém đa sầu đa cảm", "Tàn nhẫn", "Nỗi sợ đeo bám", "Mưu mô mánh khóe", "Cố làm hài lòng mọi người"],
        "voice": "Tôi lo lắng rằng tôi đã thực hiện thỏa thuận đó và dường như nó không được tiến hành như cam kết.",
        "relationship": "Coi trọng lời hứa và sự trung thực, xây dựng không gian gia đình đầm ấm và tương trợ lẫn nhau.",
        "advice": "Giao tiếp rõ ràng về các kỳ vọng và thỏa thuận trong gia đình để tránh sự ấm ức ngầm."
    },
    38: {
        "name_vi": "Sự Kiên Cường (Đối Lập)", "hexagram": "Sự Đối Lập (Hỏa Trạch Khuê)", "potential": "Sự bền bỉ",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Dễ dàng đạt mọi thứ", "Chiến binh kiên cường", "Có tầm nhìn kiên định", "Tranh đấu vì điều xứng đáng"],
        "low_energy": ["Xung đột nội tâm", "Ngang bướng", "Than thân trách phận", "Gây nên mâu thuẫn", "Đấu tranh sai mục đích"],
        "voice": "Mục đích sống của tôi là gì? Điều gì xứng đáng để tôi chiến đấu?",
        "relationship": "Độc lập, cá tính mạnh mẽ; sẵn sàng bảo vệ người yêu trước mọi sóng gió cuộc đời.",
        "advice": "Chọn lọc trận chiến đáng giá; không biến mọi bất đồng nhỏ thành cuộc tranh đấu quyền lực."
    },
    39: {
        "name_vi": "Sự Khiêu Khích (Trở Ngại)", "hexagram": "Sự Trở Ngại (Thủy Sơn Kiển)", "potential": "Giải phóng",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khai hóa (2)",
        "high_energy": ["Sự khơi gợi", "Luôn có động lực", "Người năng động", "Đưa mọi người đến sự dồi dào", "Sự giải phóng"],
        "low_energy": ["Luôn cất giữ mọi thứ", "Châm ngòi mâu thuẫn", "Kích động sự việc", "Thiếu thốn mắc kẹt", "Rầu rĩ căng thẳng"],
        "voice": "Tôi thích thử thách nội tâm người khác chỉ để xem cách họ phản ứng...",
        "relationship": "Khuấy động cảm xúc để giúp người khác bước ra khỏi vùng an toàn, nhưng cần tế nhị và đúng lúc.",
        "advice": "Khiêu khích xuất phát từ tình yêu thương nhằm giúp đối phương thức tỉnh, không chọc giận vô cớ."
    },
    40: {
        "name_vi": "Sự Độc Lập (Giải Thoát)", "hexagram": "Sự Giải Thoát (Lôi Thủy Giải)", "potential": "Sự quyết tâm",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đối lập (3)",
        "high_energy": ["Trụ cột gia đình", "Người hùng hỗ trợ", "Yêu công việc", "Giải quyết vấn đề", "Ý chí mạnh mẽ", "Khả năng cân bằng"],
        "low_energy": ["Tương tác quá mức", "Mệt mỏi cô độc", "Khước từ", "Nghiện công việc", "Cố cứu vãn tình hình", "Bỏ bê bản thân"],
        "voice": "Tôi yêu công việc nhưng tôi cần cân bằng giữa làm việc và nghỉ ngơi.",
        "relationship": "Trụ cột vững chắc cho gia đình, nhưng rất cần thời gian riêng để nạp lại năng lượng.",
        "advice": "Cân bằng giữa cống hiến cho gia đình và dành thời gian nghỉ ngơi cho chính bản thân."
    },
    41: {
        "name_vi": "Tiềm Năng (Khởi Đầu Mới)", "hexagram": "Sự Suy Giảm (Sơn Trạch Tổn)", "potential": "Hy vọng",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đột phá (4)",
        "high_energy": ["Trí tưởng tượng", "Tính sáng tạo", "Mơ mộng", "Có tầm nhìn", "Sức tưởng tượng vô hạn", "Người khởi xướng"],
        "low_energy": ["Suy sụp tinh thần", "Kiềm hãm trí tưởng tượng", "Suy nghĩ tiêu cực", "Đánh mất sức sáng tạo", "Lo sợ phán xét"],
        "voice": "Tôi không biết tại sao nhưng tôi cảm thấy như có sự thôi thúc bản thân phải thử điều gì đó mới mẻ...",
        "relationship": "Mang lại sự lãng mạn, háo hức và những ý tưởng hẹn hò độc đáo trong tình yêu.",
        "advice": "Tôn vinh trí tưởng tượng phong phú; hiểu rằng không phải mọi giấc mơ đều cần biến thành hành động ngay."
    },
    42: {
        "name_vi": "Sự Tăng Trưởng (Hoàn Thành)", "hexagram": "Sự Tăng Trưởng (Phong Lôi Ích)", "potential": "Tăng trưởng",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khởi đầu (1)",
        "high_energy": ["Hoàn thành công việc", "Phát triển tăng trưởng", "Khả năng độc lập", "Hoàn thành các quá trình", "Trải nghiệm phong phú"],
        "low_energy": ["Trì trệ chậm chạp", "Vội vàng hấp tấp", "Mắc kẹt trong vòng lặp", "Thiếu quyết đoán", "Tự trách bản thân"],
        "voice": "Tôi cảm thấy vô cùng bức bối khi cứ lặp đi lặp lại một việc, như thể bị mắc kẹt trong vòng lặp không lối thoát...",
        "relationship": "Kiên nhẫn đồng hành đưa mối quan hệ phát triển qua từng nấc thang trưởng thành.",
        "advice": "Biết rõ khi nào nên hoàn tất một chu kỳ và khi nào nên buông bỏ để bắt đầu chu kỳ mới."
    },
    43: {
        "name_vi": "Sự Thấu Hiểu (Đột Phá)", "hexagram": "Đột Phá (Trạch Thiên Quải)", "potential": "Hiểu biết",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Truyền cảm hứng sáng tạo", "Hiệu quả", "Khai sáng", "Thấu hiểu", "Đột phá", "Chuyển hóa", "Xuất chúng"],
        "low_energy": ["Bị khước từ phớt lờ", "Bị loại bỏ", "Thiếu hiệu quả", "Không biết lắng nghe", "Lo lắng ồn ào", "Luôn cho mình đúng"],
        "voice": "Tôi biết điều này nghe có vẻ hơi lạ hoặc đến bất ngờ, nhưng tôi vừa nhận được một thông điệp... Bạn có muốn nghe không?",
        "relationship": "Nhìn thấu động cơ sâu xa của đối phương, nhưng cần khéo léo diễn đạt để không gây sốc.",
        "advice": "Chờ đợi lời mời trước khi chia sẻ sự thấu hiểu độc đáo của mình để được lắng nghe và trân trọng."
    },
    44: {
        "name_vi": "Cảnh Giác (Hợp Tác)", "hexagram": "Đối Mặt (Thiên Phong Cấu)", "potential": "Sự hợp tác",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đối lập (3)",
        "high_energy": ["Khả năng chữa lành", "Làm việc nhóm", "Tính thẩm mỹ cao", "Hài hòa cân bằng", "Có linh cảm", "Tự chủ"],
        "low_energy": ["Thiếu tin cậy đa nghi", "Bị cô lập", "Đánh giá sai lầm", "Lo sợ quá khứ tái diễn", "Bị mắc kẹt", "Vô cảm"],
        "voice": "Tôi lo sợ những gì đã xảy ra trong quá khứ sẽ tái diễn.",
        "relationship": "Nhạy bén nhận ra người có tần số năng lượng phù hợp để kết nối; trực giác tốt về lòng người.",
        "advice": "Vượt qua bóng ma quá khứ; dùng kinh nghiệm cũ làm bài học sáng suốt thay vì rào cản ngăn cản tình yêu."
    },
    45: {
        "name_vi": "Tiếng Nói Lãnh Đạo (Hội Họp)", "hexagram": "Hội Họp Cùng Nhau (Trạch Địa Tụy)", "potential": "Sự tích lũy",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Khai hóa (2)",
        "high_energy": ["Khả năng lãnh đạo", "Người lãnh đạo rộng lượng", "Chia sẻ tài nguyên", "Tiếng nói cộng đồng", "Chỉ đạo công việc"],
        "low_energy": ["Rụt rè nhút nhát", "Ngạo mạn", "Thiếu tư duy", "Tự đề cao bản thân", "Thích thể hiện", "Lấn át người khác"],
        "voice": "Tôi là người sẽ dẫn dắt việc này.",
        "relationship": "Người chu cấp, che chở và định hướng cho gia đình; cần tạo sự bình đẳng thay vì gia trưởng.",
        "advice": "Dùng quyền lực và tài nguyên để phục vụ lợi ích chung của tập thể và gia đình."
    },
    46: {
        "name_vi": "Ngôi Đền Sống (Chân Ngã Thể Xác)", "hexagram": "Sự Nâng Đỡ (Địa Phong Thăng)", "potential": "Sự cống hiến",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đối lập (3)",
        "high_energy": ["Kiên định", "Động lực mạnh mẽ", "Nội tâm ổn định", "Yêu thương bản thân", "Niềm vui giản dị", "Có duyên lành"],
        "low_energy": ["Lo lắng quá mức", "Phù phiếm", "Bỏ bê bản thân", "Ám ảnh hình thể", "Không hòa hợp với cơ thể", "Tự tin thái quá"],
        "voice": "Cơ thể là ngôi đền thiêng và tôi trân trọng nó dù đôi khi tôi thử thách giới hạn của nó...",
        "relationship": "Thể hiện tình yêu qua sự tiếp xúc thể chất và sự chăm sóc sức khỏe ân cần cho bạn đời.",
        "advice": "Yêu thương cơ thể mình như một ngôi đền thiêng; sống trọn vẹn trong khoảnh khắc hiện tại."
    },
    47: {
        "name_vi": "Sự Nhận Thức (Diễn Giải)", "hexagram": "Sự Áp Bức (Trạch Thủy Khốn)", "potential": "Sự diễn giải",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đối lập (3)",
        "high_energy": ["Tư duy phát triển", "Phân tích suy ngẫm", "Đón nhận mọi khả năng", "Khơi nguồn cảm hứng", "Khoảnh khắc giác ngộ"],
        "low_energy": ["Vô dụng vô nghĩa", "Thất bại", "Luôn bị ám ảnh", "Bối rối lầm lạc", "Năng lượng tiêu cực", "Bảo thủ áp bức"],
        "voice": "Dựa trên những gì tôi đã được học thì đây là cách nó được thực hiện.",
        "relationship": "Sẵn sàng lắng nghe và cùng bạn đời vượt qua những giai đoạn bối rối, tìm ra ý nghĩa sâu xa.",
        "advice": "Tin tưởng rằng câu trả lời sẽ đến đúng lúc; không ép buộc bản thân phải hiểu mọi thứ ngay tức khắc."
    },
    48: {
        "name_vi": "Sự Sâu Sắc (Ý Chí)", "hexagram": "Ý Chí (Thủy Phong Tỉnh)", "potential": "Chiều sâu",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đối lập (3)",
        "high_energy": ["Sâu sắc", "Trí tuệ tinh thông", "Tiếp thu kiến thức", "Tính đơn giản", "Linh hoạt có giải pháp", "Tài năng tự nhiên"],
        "low_energy": ["Kỹ lưỡng quá mức", "Sự thất vọng", "Ở trong vùng an toàn", "Cảm thấy không đủ giỏi", "Nhạt nhẽo vô vị", "Thiếu đạo đức"],
        "voice": "Tôi lo rằng mình không đủ kiến thức, chiều sâu mỗi khi phát ngôn... Tôi nên học thêm một khóa nữa...",
        "relationship": "Người bạn tri kỷ thông thái, thấu hiểu tâm tư sâu kín của đối phương.",
        "advice": "Vượt qua hội chứng kẻ mạo danh (Imposter Syndrome); tin tưởng vào kho tàng tri thức bạn đã có."
    },
    49: {
        "name_vi": "Nguyên Tắc (Cách Mạng)", "hexagram": "Cách Mạng (Trạch Hỏa Cách)", "potential": "Nguyên tắc",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Khởi đầu (1)",
        "high_energy": ["Cách mạng tái sinh", "Những nguyên tắc", "Chuyển hóa", "Hiểu bản thân cần gì", "Giao tiếp", "Kết nối muôn loài"],
        "low_energy": ["Phản ứng cảm tính", "Từ chối / Bị từ chối", "Nguyên tắc kỳ vọng", "Không nhìn nhận bản thân", "Vô cảm bạo lực"],
        "voice": "Tôi sẽ không tổn hại đến những giá trị bản thân vì đây là những gì tôi tin tưởng.",
        "relationship": "Trung thành, rạch ròi, đòi hỏi sự công bằng và tôn trọng nguyên tắc trong tình cảm.",
        "advice": "Biết rõ nguyên tắc nào đáng giữ, nguyên tắc nào cần buông bỏ để không làm tổn thương người thân."
    },
    50: {
        "name_vi": "Giá Trị (Cái Nôi Văn Hóa)", "hexagram": "Cái Nôi Văn Hóa (Hỏa Phong Đỉnh)", "potential": "Những giá trị",
        "circuit": "Bộ lạc - Phòng thủ", "quarter": "Đối lập (3)",
        "high_energy": ["Mang lại giá trị", "Chuyển hóa trưởng thành", "Phát triển mạnh mẽ", "Cân bằng hài hòa", "Người bảo vệ chăm sóc"],
        "low_energy": ["Cảm giác tội lỗi", "Cảm thấy quá tải", "Thiếu trách nhiệm", "Mất cân bằng cảm xúc", "Chăm lo không đúng người"],
        "voice": "Tôi biết đây là những chuẩn mực giá trị xã hội được mong đợi nhưng tôi vẫn muốn đấu tranh...",
        "relationship": "Người nuôi dưỡng và giữ gìn các giá trị gia đình; sẵn sàng gánh vác trách nhiệm vì người thân.",
        "advice": "Chăm sóc bản thân trước tiên để không bị cảm giác tội lỗi và gánh nặng trách nhiệm đè bẹp."
    },
    51: {
        "name_vi": "Sự Ngoan Cường (Cú Sốc)", "hexagram": "Sự Khơi Dậy (Thuần Chấn)", "potential": "Sự can đảm",
        "circuit": "Cá nhân - Tập trung", "quarter": "Khởi đầu (1)",
        "high_energy": ["Thuận theo xu thế", "Chiến binh quả cảm", "Thay đổi mạnh mẽ", "Thích nghi phát triển", "Vượt qua cái tôi"],
        "low_energy": ["Tính ái kỷ", "Kiểm soát mọi thứ", "Chiến binh khờ khạo", "Hành vi tiêu cực", "Bất ngờ với cú sốc", "Mất niềm tin"],
        "voice": "Tôi sẽ đi làm một điều gì đó cực đoan và gây sốc bởi vì...",
        "relationship": "Truyền cảm hứng dũng cảm và kiên cường cho bạn đời trước mọi biến cố bất ngờ.",
        "advice": "Giữ vững niềm tin khi mọi thứ đảo lộn; xem mỗi cú sốc là cơ hội để thức tỉnh tâm linh."
    },
    52: {
        "name_vi": "Sự Tĩnh Lặng (Bất Biến)", "hexagram": "Sự Bất Biến (Thuần Cấn)", "potential": "Tĩnh lặng",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khai hóa (2)",
        "high_energy": ["Tĩnh lặng tái đánh giá", "Trao sức mạnh", "Tuân thủ kỷ luật", "Thận trọng", "Tầm nhìn sắc bén", "Vượt khó"],
        "low_energy": ["Tê liệt quá tải", "Điên rồ phản ứng", "Bị lôi kéo lười nhác", "Căng thẳng", "Rối loạn tăng động", "Mất tập trung"],
        "voice": "Tôi có thể rơi vào trạng thái tập trung hàng giờ liền. Tôi cảm thấy sự bồn chồn căng thẳng nhưng không biết cần tập trung vào đâu...",
        "relationship": "Sự điềm tĩnh và vững chãi mang lại cảm giác an toàn, che chở cho người bạn đời.",
        "advice": "Học cách giữ sự tĩnh lặng nội tâm trước khi hành động; kiên nhẫn chờ thời cơ chín muồi."
    },
    53: {
        "name_vi": "Sự Khởi Đầu (Phát Triển)", "hexagram": "Sự Phát Triển (Phong Sơn Tiệm)", "potential": "Sự sẵn sàng",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khai hóa (2)",
        "high_energy": ["Những khởi đầu", "Khai tâm cho người khác", "Bắt đầu điều mới", "Mở rộng", "Tôn vinh chu kỳ", "Nâng đỡ"],
        "low_energy": ["Kiệt sức cưỡng ép", "Không hoàn tất cam kết", "Khởi đầu không đúng lúc", "Chỉ trích bản thân", "Căng thẳng áp lực"],
        "voice": "Tôi cảm thấy buộc phải khởi động một dự án mới mặc dù vẫn còn nhiều cái khác cần tôi hoàn thành.",
        "relationship": "Thôi thúc sự đổi mới và bước sang giai đoạn phát triển mới trong tình cảm.",
        "advice": "Chấp nhận rằng bạn là người khởi động chứ không nhất thiết phải tự mình hoàn thành mọi công đoạn."
    },
    54: {
        "name_vi": "Tham Vọng (Vươn Lên)", "hexagram": "Vươn Lên Từ Sự Hợp Tác (Lôi Trạch Quy Muội)", "potential": "Tham vọng",
        "circuit": "Bộ lạc - Bản ngã", "quarter": "Đột phá (4)",
        "high_energy": ["Có động lực", "Tham vọng", "Thăng hoa", "Khởi nghiệp", "Ý tưởng lớn", "Có tầm ảnh hưởng", "Thành công vật chất"],
        "low_energy": ["Kiệt sức giả dối", "Lợi dụng người khác", "Trống rỗng", "Tham lam", "Không có tham vọng", "Lười nhác"],
        "voice": "Tôi hy vọng rằng người có tầm ảnh hưởng sẽ nhận thấy nỗ lực của tôi. Tôi thực sự rất mong được thăng tiến.",
        "relationship": "Cùng bạn đời phấn đấu vươn lên xây dựng cuộc sống thịnh vượng và nâng tầm gia đình.",
        "advice": "Cân bằng giữa tham vọng và sự hài lòng với hiện tại; chọn đúng thời điểm để hành động."
    },
    55: {
        "name_vi": "Sự Đủ Đầy (Phong Phú)", "hexagram": "Sự Phong Phú (Lôi Hỏa Phong)", "potential": "Sự đủ đầy",
        "circuit": "Cá nhân - Trực giác", "quarter": "Khởi đầu (1)",
        "high_energy": ["Có ý thức", "Tin tưởng", "Tiến hóa tự do", "Đủ đầy tin cậy", "Năng lượng thiêng liêng", "Đam mê", "Sáng tạo"],
        "low_energy": ["Do dự lưỡng lự", "Nói dông dài", "Trống rỗng sợ hãi", "Than phiền thị phi", "Tâm trạng xấu", "Sầu muộn thiếu đam mê"],
        "voice": "Tôi biết nếu mình không có tâm trạng để làm việc, mọi việc ắt hẳn sẽ không được hoàn thành.",
        "relationship": "Kết nối cảm xúc sâu sắc, cùng đồng hành thức tỉnh và khám phá chân trời tâm linh.",
        "advice": "Tin tưởng vào sự đủ đầy của vũ trụ; tôn trọng chu kỳ tâm trạng lên xuống của bản thân."
    },
    56: {
        "name_vi": "Người Kể Chuyện (Lữ Khách)", "hexagram": "Người Lữ Khách (Hỏa Sơn Lữ)", "potential": "Sự kích thích",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Khai hóa (2)",
        "high_energy": ["Người kể chuyện", "Người khám phá", "Tấm lòng cởi mở", "Nhiều trải nghiệm", "Làm phong phú cuộc sống", "Say mê"],
        "low_energy": ["Sao lãng", "Tự phán xét bản thân", "Phóng đại quá mức", "Bị kích thích quá mức", "Rầu rĩ buồn thảm", "Xa rời thực tế"],
        "voice": "Hôm nọ, khách hàng của tôi đã làm điều đó, thật lòng mà nói tôi không thể tin nổi. Bạn có tin không?",
        "relationship": "Linh hồn của cuộc trò chuyện, làm say mê bạn đời bằng những câu chuyện trải nghiệm đầy cảm xúc.",
        "advice": "Chờ đợi lời mời trước khi kể chuyện để thông điệp chạm đến người nghe một cách sâu sắc nhất."
    },
    57: {
        "name_vi": "Trực Giác (Sự Dịu Dàng)", "hexagram": "Sự Dịu Dàng (Thuần Tốn)", "potential": "Trực giác",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đối lập (3)",
        "high_energy": ["Có trực giác bản năng", "Nhạy cảm với rung động", "Đúng thời điểm", "Tin tưởng bản thân", "Sinh tồn", "Sáng tỏ"],
        "low_energy": ["Lo sợ tương lai", "Không hành động", "Nghi ngờ do dự", "Thiếu quyết đoán", "Tê liệt vì nỗi sợ", "Thiếu cam kết"],
        "voice": "Tôi đang loay hoay tìm hiểu điều gì đang chờ đợi mình ở phía trước... Tôi sợ rằng tương lai sẽ cuốn tôi đi...",
        "relationship": "Thấu cảm tinh tế, cảm nhận được nhu cầu sâu kín của đối phương mà không cần nói ra.",
        "advice": "Tin tưởng vào tiếng thì thầm trực giác trong khoảnh khắc hiện tại; không để nỗi sợ tương lai cản bước."
    },
    58: {
        "name_vi": "Niềm Vui (Sự Hân Hoan)", "hexagram": "Niềm Vui (Thuần Đoài)", "potential": "Sự hân hoan",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Đột phá (4)",
        "high_energy": ["Say mê cuộc sống", "Lôi cuốn thông thạo", "Vui sướng đầy sức sống", "Vui tươi hạnh phúc", "Phụng sự", "An lành"],
        "low_energy": ["Không thỏa mãn", "Luôn bất mãn", "Cảm thấy cay đắng", "Luôn soi xét", "Chỉ trích khắt khe"],
        "voice": "Tôi cảm thấy áp lực phải dấn thân vào một mục tiêu... Tôi cho rằng chúng ta có thể cải thiện điều này bằng cách...",
        "relationship": "Lan tỏa năng lượng vui tươi, yêu đời, tạo bầu không khí sống động và mới mẻ cho tình yêu.",
        "advice": "Phân biệt giữa việc cùng nhau hoàn thiện và cố gắng thay đổi đối phương; trân trọng những điều tốt đẹp hiện tại."
    },
    59: {
        "name_vi": "Sự Thân Mật (Phân Tán)", "hexagram": "Sự Phân Tán (Phong Thủy Hoán)", "potential": "Sự thân mật",
        "circuit": "Bộ lạc - Phòng thủ", "quarter": "Đối lập (3)",
        "high_energy": ["Thân mật tính dục", "Minh bạch rõ ràng", "Nuôi dưỡng sự sống", "Sâu sắc", "Phá vỡ hào quang", "Kế thừa"],
        "low_energy": ["Xâm phạm ranh giới", "Loại trừ", "Phán xét tính dục", "Phòng vệ", "Giận dữ thiếu thân mật", "Gắn kết hời hợt"],
        "voice": "Tôi thấy bực bội khi có người vượt qua những ranh giới tôi đã thiết lập.",
        "relationship": "Khả năng kết nối tâm hồn sâu sắc, gắn kết hai người xa lạ thành tri kỷ; người mai mối tự nhiên.",
        "advice": "Học cách thiết lập và tôn trọng ranh giới cảm xúc của bản thân và đối phương."
    },
    60: {
        "name_vi": "Sự Giới Hạn (Đồng Thuận)", "hexagram": "Sự Giới Hạn (Thủy Trạch Tiết)", "potential": "Chủ nghĩa thực tế",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Ranh giới lành mạnh", "Tháo vát sáng tạo", "Kiên nhẫn chấp nhận", "Kỷ luật", "Thực tế vững vàng"],
        "low_energy": ["Nản lòng mắc kẹt", "Bồn chồn căng thẳng", "Thờ ơ lạnh nhạt", "Cưỡng ép thay đổi", "Tiêu cực bế tắc"],
        "voice": "Tôi cảm thấy gần như lúc nào cũng có áp lực thôi thúc phải mang điều mới vào thế giới này...",
        "relationship": "Mang lại sự an tâm, vững chãi và thực tế cho mối quan hệ giữa những thăng trầm cuộc sống.",
        "advice": "Giới hạn là khuôn khổ nuôi dưỡng sự sáng tạo; kiên nhẫn chờ thời điểm đúng đắn để đột phá."
    },
    61: {
        "name_vi": "Sự Bí Ẩn (Chân Lý Nội Tâm)", "hexagram": "Chân Lý Nội Tâm (Phong Trạch Trung Phu)", "potential": "Sự khai phá",
        "circuit": "Cá nhân - Trực giác", "quarter": "Đột phá (4)",
        "high_energy": ["Sự thấu tỏ", "Huyền bí nhận thức", "Chân lý nội tâm", "Nguồn cảm hứng", "Tâm trí ổn định", "Mơ mộng"],
        "low_energy": ["Hiếu kỳ quá mức", "Mất đi sự mơ tưởng", "Cuồng tín ám ảnh", "Rối loạn tinh thần", "Áp lực cảm xúc"],
        "voice": "Tôi đã có một khoảnh khắc vỡ òa khi đọc bài viết này... Cuối cùng tôi cảm thấy như mình đã biết cách kết nối mọi thứ...",
        "relationship": "Kết nối sâu sắc về tư tưởng và tinh thần, cùng nhau khám phá những điều mầu nhiệm của cuộc sống.",
        "advice": "Chấp nhận rằng có những điều trực giác chỉ 'biết' mà không cần logic lý giải; cho tâm trí được nghỉ ngơi."
    },
    62: {
        "name_vi": "Tính Thực Tiễn (Ưu Thế Chi Tiết)", "hexagram": "Ưu Thế Chi Tiết Nhỏ (Lôi Sơn Tiểu Quá)", "potential": "Tính chính xác",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khai hóa (2)",
        "high_energy": ["Kiên quyết chi tiết", "Có tổ chức phương pháp", "Diễn đạt lưu loát", "Tính chính xác", "Thực tiễn"],
        "low_energy": ["Mắc kẹt trong chi tiết", "Bám chấp kế hoạch", "Lo âu ám ảnh", "Quá chi tiết cứng nhắc", "Giới hạn bởi logic"],
        "voice": "Tôi nghĩ chúng ta có thể đi theo một trong hai hướng sau. Mỗi hướng đi đều mang đến kết quả tương đồng...",
        "relationship": "Quan tâm đến từng chi tiết nhỏ của đối phương, giao tiếp rõ ràng và mạch lạc.",
        "advice": "Cân bằng giữa tư duy phân tích chi tiết với sự đồng cảm và lắng nghe cảm xúc của bạn đời."
    },
    63: {
        "name_vi": "Sự Nghi Ngờ (Sau Khi Hoàn Tất)", "hexagram": "Sau Khi Hoàn Tất (Thủy Hỏa Ký Tế)", "potential": "Sự kiểm chứng",
        "circuit": "Tập thể - Hiểu biết", "quarter": "Khởi đầu (1)",
        "high_energy": ["Nghi ngờ hiếu kỳ", "Quyết đoán chân thật", "Khuyến khích", "Công nhận khuôn mẫu", "Tin vào bản thân"],
        "low_energy": ["Nghi ngờ bản thân", "Đa nghi thái quá", "Tìm kiếm chứng cứ mù quáng", "Không thỏa đáng", "Thiếu tin tưởng"],
        "voice": "Tôi có quá nhiều câu hỏi mà dường như không thể tìm ra lời giải... Lẽ ra tôi nên tin tưởng vào điều đó...",
        "relationship": "Biết lắng nghe và giúp bạn đời nhìn xuyên qua bề mặt vấn đề; cần tránh tra hỏi khiến đối phương ngột ngạt.",
        "advice": "Hướng sự hoài nghi ra các câu hỏi khoa học/công việc thay vì nghi ngờ chính mình hay người thân."
    },
    64: {
        "name_vi": "Sự Bối Rối (Trước Khi Hoàn Tất)", "hexagram": "Trước Khi Hoàn Tất (Hỏa Thủy Vị Tế)", "potential": "Sự phản chiếu",
        "circuit": "Tập thể - Cảm nhận", "quarter": "Đối lập (3)",
        "high_energy": ["Nguồn cảm hứng", "Tầm nhìn sáng tạo", "Bức tranh tổng thể", "Thông tỏ hợp lý hóa", "Xúc cảm mãnh liệt"],
        "low_energy": ["Quá nhiều ý tưởng", "Mắc kẹt cách làm", "Căng thẳng thất vọng", "Bối rối sao chép", "Lo âu từ bỏ"],
        "voice": "Tôi là một người có trí tưởng tượng. Tâm trí tôi tràn ngập những hình ảnh từ quá khứ... Tôi muốn mọi thứ có ý nghĩa.",
        "relationship": "Mang lại chiều sâu trí tuệ và góc nhìn mới mẻ cho đối phương; chia sẻ thế giới nội tâm để cùng thấu hiểu.",
        "advice": "Dùng phương pháp hình dung kết quả cuối cùng; tin rằng câu trả lời sẽ xuất hiện khi thời điểm chín muồi."
    }
}

# Hoàn thiện danh sách 64 cổng
gates_full_data = {}
for g_num in range(1, 65):
    info = GATES_INFO.get(g_num, {
        "name_vi": f"Cổng {g_num}", "hexagram": "Kinh Dịch", "potential": "Năng lượng tiềm năng",
        "circuit": "Tập thể", "quarter": "Tiến hóa",
        "high_energy": ["Tích cực", "Sáng tạo", "Chân thực"],
        "low_energy": ["Bất an", "Trì trệ", "Sợ hãi"],
        "voice": f"Tiếng nói của Cổng {g_num}",
        "relationship": f"Ảnh hưởng của Cổng {g_num} trong mối quan hệ.",
        "advice": "Lắng nghe Chiến lược và Quyền năng của bản thân."
    })
    info["gate_number"] = g_num
    info["center"] = GATE_TO_CENTER.get(g_num, "Unknown")
    gates_full_data[str(g_num)] = info

with open(os.path.join(DATA_DIR, "gates.json"), "w", encoding="utf-8") as f:
    json.dump(gates_full_data, f, ensure_ascii=False, indent=2)

print(f"Đã tạo gates.json thành công với {len(gates_full_data)} cổng!")
