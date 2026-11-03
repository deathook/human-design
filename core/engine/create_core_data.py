"""
Khởi tạo dữ liệu Authorities, Definitions, Centers, Profiles
Theo đúng sách 'Human Design Cho Người Mới Bắt Đầu'
"""
import json
import os
import sys

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

DATA_DIR = r"C:\HumanDesign\core\data"

# 2. BẢY PHÂN LOẠI QUYỀN NĂNG (AUTHORITIES) - Trang 83-99
authorities_data = {
    "Emotional": {
        "rank": 1,
        "id": "Emotional",
        "name_vi": "Quyền năng Cảm xúc",
        "center": "Solar_Plexus",
        "center_vi": "Trung tâm Đám Rối Dương",
        "population_pct": "47% - 50%",
        "affirmation": "Tôi tin rằng thời gian luôn ủng hộ tôi, ngay cả khi tôi cảm thấy thiếu kiên nhẫn.",
        "description": "Nằm ở Trung tâm Đám Rối Dương xác định. Có độ ưu tiên cao nhất trong hệ thống quyền năng bên trong. Không có sự thật trong khoảnh khắc tức thời (No truth in the now). Bạn trải qua các làn sóng cảm xúc lên xuống và cần thời gian để cảm xúc lắng đọng về trạng thái trung lập trước khi đưa ra quyết định quan trọng.",
        "wave_types": [
            {"name": "Sóng Nguồn (Kênh 59-6)", "desc": "Nguồn của tất cả các cơn cảm xúc, có sức thâm nhập mạnh mẽ vào hào quang người khác."},
            {"name": "Sóng Cá Nhân (Kênh 12-22, 39-55)", "desc": "Liên quan đến tâm trạng, cảm xúc ủ rũ và chiều sâu nghệ thuật, âm thanh."},
            {"name": "Sóng Bộ Lạc (Kênh 19-49, 37-40)", "desc": "Cơn sóng tích tụ từ nhu cầu gắn kết, dễ bùng nổ theo kiểu giọt nước tràn ly."},
            {"name": "Sóng Tập Thể (Kênh 41-30, 36-35)", "desc": "Sóng tăng dần đều và sụp đổ do kỳ vọng không được đáp ứng. Hãy làm vì trải nghiệm, không vì kỳ vọng."}
        ],
        "decision_rule": "Quyết định nhỏ cần ít nhất 5 phút; quyết định vừa cần ngủ qua đêm; quyết định lớn (sự nghiệp, quan hệ) cần ít nhất một tuần để đạt sự rõ ràng."
    },
    "Sacral": {
        "rank": 2,
        "id": "Sacral",
        "name_vi": "Quyền năng Nguồn sinh lực",
        "center": "Sacral",
        "center_vi": "Trung tâm Đan Điền (Sinh Khí)",
        "population_pct": "35%",
        "affirmation": "Tôi tôn trọng sự kêu gọi thiêng liêng sẽ mang đến những quyết định phù hợp với điều tốt đẹp nhất dành cho tôi.",
        "description": "Xuất hiện ở Nhóm Vận Hành hoặc Khởi Xướng Vận Hành khi Đám Rối Dương mở. Trực giác nói qua cảm giác ở bụng và phát ra âm thanh tự nhiên: 'Ừ hứ' (có) hoặc 'Ừ ừ' (không). Phản ứng xảy ra tức thì trong khoảnh khắc khi nhận được câu hỏi có/không.",
        "decision_rule": "Luyện tập thông qua các câu hỏi có/không hoặc câu hỏi nhị phân ('Bạn có muốn đi ăn không?'). Nếu có sự do dự, câu trả lời là KHÔNG."
    },
    "Splenic": {
        "rank": 3,
        "id": "Splenic",
        "name_vi": "Quyền năng Nhận thức (Trực giác Lách)",
        "center": "Spleen",
        "center_vi": "Trung tâm Sinh Giác (Lách)",
        "population_pct": "11%",
        "affirmation": "Trực giác không bao giờ lừa dối tôi, ngay cả khi nó im lặng.",
        "description": "Bắt nguồn từ Trung tâm Lách khi cả Đám Rối Dương và Đan Điền đều mở (ở nhóm Khởi Xướng hoặc Khai Vấn). Đây là trực giác sinh tồn nguyên thủy, cảnh báo qua cảm giác bồn chồn, ớn lạnh, ấm áp hoặc tiếng thì thầm trong khoảnh khắc. Tín hiệu chỉ xuất hiện một lần duy nhất rồi biến mất.",
        "decision_rule": "Hành động ngay theo trực giác tức thì, không để tâm trí phân tích logic can thiệp hay biến thành nỗi sợ hãi tương lai."
    },
    "Ego": {
        "rank": 4,
        "id": "Ego",
        "name_vi": "Quyền năng Cái tôi bản ngã",
        "center": "Heart",
        "center_vi": "Trung tâm Tâm Ngã (Tim)",
        "population_pct": "1%",
        "affirmation": "Tôi tin vào chân ngã của mình. Tự tin đưa ra quyết định và tin rằng bản thân hòa nhịp với cuộc sống của mình.",
        "description": "Quyền năng rất hiếm, chia làm 2 dạng: Cái tôi bản ngã thể hiện (Tim nối Họng - ở nhóm Khởi Xướng) và Cái tôi bản ngã phản chiếu (Tim nối Ngực - ở nhóm Khai Vấn). Quyết định đến từ ý chí và mong muốn thực sự của trái tim.",
        "decision_rule": "Tự hỏi bản thân: 'Tôi thực sự muốn gì? Điều này có lợi gì cho tôi? Trái tim tôi có thực sự cam kết và sẵn sàng dốc sức không?'"
    },
    "Self_Projected": {
        "rank": 5,
        "id": "Self_Projected",
        "name_vi": "Quyền năng Danh tính (Tự phóng chiếu)",
        "center": "G_Center",
        "center_vi": "Trung tâm Thượng Ngã (Ngực)",
        "population_pct": "2.8%",
        "affirmation": "Tôi tin tưởng vào việc sử dụng tiếng nói của mình để bày tỏ những nhu cầu của bản thân.",
        "description": "Ở nhóm Khai Vấn khi Trung tâm Thượng Ngã kết nối với Tuệ Ngôn (Họng) và không có các trung tâm động cơ bên dưới xác định. Quyết định đúng đắn hé lộ khi bạn nói chuyện tự nhiên trong một không gian an toàn và lắng nghe chính giọng nói của mình.",
        "decision_rule": "Tìm một người lắng nghe trung lập, hoặc tự ghi âm/nói ra thành tiếng để lắng nghe âm điệu chân thật toát ra từ chính mình."
    },
    "Environmental": {
        "rank": 6,
        "id": "Environmental",
        "name_vi": "Quyền năng Môi trường | Tinh thần",
        "center": "Ajna_Crown",
        "center_vi": "Trung tâm Trí Huệ / Tuệ Nhãn",
        "population_pct": "3.6%",
        "affirmation": "Tôi tin tưởng vào quan điểm và trí tuệ của mình. Tôi sử dụng ý kiến của người khác để tìm kiếm sự rõ ràng, để có thể tự tin đưa ra quyết định phù hợp với chân ngã của tôi.",
        "description": "Thuộc nhóm Khai Vấn tinh thần (Mental Projector), chỉ có Đầu + Trán hoặc Đầu + Trán + Họng xác định, không có trung tâm nào bên dưới Họng. Môi trường xung quanh quyết định sự sáng suốt của bạn.",
        "decision_rule": "Quan sát cảm giác của cơ thể với môi trường: Nếu môi trường cảm thấy đúng, quyết định sẽ đúng. Dùng người khác như một bảng phản hồi (sounding board) chứ không xin lời khuyên."
    },
    "Lunar": {
        "rank": 7,
        "id": "Lunar",
        "name_vi": "Quyền năng Chu kỳ Mặt trăng",
        "center": "None",
        "center_vi": "Không có trung tâm xác định",
        "population_pct": "1.4%",
        "affirmation": "Kiên nhẫn là người bạn đồng hành thân thiết. Càng tin tưởng sâu sắc, tôi càng cảm thấy gắn kết hơn.",
        "description": "Dành riêng cho Nhóm Phản Chiếu (Reflector) khi toàn bộ 9 trung tâm đều mở. Trong 28 ngày chu kỳ Mặt trăng, Mặt trăng sẽ đi qua lần lượt tất cả 64 cổng, cho phép bạn trải nghiệm đầy đủ các góc nhìn và quyền năng trước khi quyết định.",
        "decision_rule": "Chờ đợi trọn vẹn 1 chu kỳ Mặt trăng (~28 ngày) đối với các quyết định lớn. Nói chuyện và quan sát cảm xúc qua từng pha của chu kỳ."
    }
}

# 3. 5 PHƯƠNG THỨC LIÊN KẾT (DEFINITIONS) - Trang 153-156
definitions_data = {
    "No_Definition": {
        "id": "No_Definition",
        "name_vi": "Không có phương thức liên kết",
        "name_en": "No Definition",
        "population_pct": "1.45%",
        "description": "Không có trung tâm năng lượng nào được kết nối với nhau bằng kênh hoàn chỉnh. Đặc trưng của Nhóm Phản Chiếu. Khả năng thích ứng và linh hoạt cực kỳ cao.",
        "advice": "Dành thời gian tĩnh lặng để làm sạch các năng lượng hấp thu từ môi trường. Tuân thủ chiến lược chu kỳ Mặt trăng."
    },
    "Single": {
        "id": "Single",
        "name_vi": "Phương thức liên kết Đơn",
        "name_en": "Single Definition",
        "population_pct": "41%",
        "description": "Tất cả các trung tâm được xác định đều kết nối liên hoàn thành một mạng lưới thống nhất duy nhất. Năng lượng lưu thông thông suốt, xử lý thông tin nhanh, độc lập và tự chủ.",
        "advice": "Tự tin trong quyết định, nhưng cần cởi mở lắng nghe người khác để tránh bảo thủ, cứng nhắc."
    },
    "Split": {
        "id": "Split",
        "name_vi": "Phương thức liên kết Đôi",
        "name_en": "Split Definition",
        "population_pct": "45%",
        "description": "Các trung tâm xác định chia làm 2 cụm riêng biệt không có kênh nối liền. Thường cảm thấy sự giằng co như 'hai tiếng nói' bên trong mình.",
        "advice": "Tự nhiên bị thu hút bởi người mang cổng/kênh bắc cầu giúp nối liền 2 cụm năng lượng. Cần kiên nhẫn hòa giải sự đối thoại bên trong."
    },
    "Triple_Split": {
        "id": "Triple_Split",
        "name_vi": "Phương thức liên kết Ba",
        "name_en": "Triple Split Definition",
        "population_pct": "11%",
        "description": "Có 3 khu vực xác định tách biệt nhau. Khả năng nhìn cuộc sống từ nhiều góc độ phong phú, xuất sắc trong tích hợp các quan điểm đa dạng.",
        "advice": "Cần ra ngoài tiếp xúc với nhiều môi trường và nhiều nhóm người khác nhau để dòng năng lượng được bắc cầu và lưu chuyển tự nhiên."
    },
    "Quadruple_Split": {
        "id": "Quadruple_Split",
        "name_vi": "Phương thức liên kết Bốn",
        "name_en": "Quadruple Split Definition",
        "population_pct": "0.57%",
        "description": "Rất hiếm, có 4 khu vực xác định tách biệt (thường có 8 hoặc 9 trung tâm xác định). Như 4 tính cách riêng biệt cùng tồn tại trong một con người.",
        "advice": "Cần thời gian và sự kiên nhẫn để các phần bên trong đồng thuận. Tránh vội vã đưa ra quyết định khi chưa có sự nhất quán nội tâm."
    }
}

# 4. 9 TRUNG TÂM NĂNG LƯỢNG (CENTERS) - Trang 100-152
centers_data = {
    "Head": {
        "id": "Head",
        "name_vi": "Trung tâm Trí Huệ",
        "name_en": "Crown Center",
        "location": "Đỉnh đầu",
        "function_type": "Áp lực (Pressure)",
        "biological": "Tuyến tùng (Pineal gland)",
        "defined_pct": "30%",
        "undefined_pct": "70%",
        "gates": [64, 61, 63],
        "defined_desc": "Dòng cảm hứng ổn định, áp lực tư duy bền bỉ từ bên trong, tò mò sâu sắc và tập trung giải quyết các câu hỏi lớn.",
        "undefined_desc": "Linh hoạt tinh thần, tiếp nhận câu hỏi và cảm hứng từ môi trường, có thể hiểu nhiều góc nhìn nhưng dễ bị áp lực giải quyết vấn đề của người khác.",
        "key_question": "Tôi có đang cố gắng trả lời những câu hỏi không phải của mình không?"
    },
    "Ajna": {
        "id": "Ajna",
        "name_vi": "Trung tâm Tuệ Nhãn",
        "name_en": "Ajna Center",
        "location": "Trán",
        "function_type": "Nhận thức tinh thần (Awareness)",
        "biological": "Tuyến yên (Pituitary gland)",
        "defined_pct": "47%",
        "undefined_pct": "53%",
        "gates": [47, 24, 4, 17, 43, 11],
        "defined_desc": "Cách xử lý và cấu trúc thông tin cố định, đáng tin cậy; tư duy nhất quán, kiên định với quan điểm nhưng có thể cứng nhắc.",
        "undefined_desc": "Tư duy mở, dễ dàng thấu hiểu và xem xét vấn đề từ nhiều lăng kính, không cần phải cố tỏ ra chắc chắn về mọi thứ.",
        "key_question": "Tôi có đang cố gắng thuyết phục mọi người rằng tôi luôn chắc chắn không?"
    },
    "Throat": {
        "id": "Throat",
        "name_vi": "Trung tâm Tuệ Ngôn",
        "name_en": "Throat Center",
        "location": "Cổ họng",
        "function_type": "Biểu hiện & Hiện thực hóa (Manifestation)",
        "biological": "Tuyến giáp trạng và cận giáp",
        "defined_pct": "72%",
        "undefined_pct": "28%",
        "gates": [62, 23, 56, 35, 12, 45, 33, 8, 31, 20, 16],
        "defined_desc": "Giọng nói và phong cách biểu đạt nhất quán, có sức mạnh biến ý tưởng thành hành động thực tế.",
        "undefined_desc": "Giao tiếp linh hoạt tùy đối tượng, cần học cách thoải mái với sự im lặng và chỉ nói khi được mời để lời nói có trọng lượng.",
        "key_question": "Tôi có đang cố gắng thu hút sự chú ý bằng cách nói quá nhiều không?"
    },
    "G_Center": {
        "id": "G_Center",
        "name_vi": "Trung tâm Thượng Ngã",
        "name_en": "G-Center",
        "location": "Ngực giữa",
        "function_type": "Bản sắc, Định hướng & Tình yêu (Identity & Direction)",
        "biological": "Gan và tuần hoàn máu",
        "defined_pct": "57%",
        "undefined_pct": "43%",
        "gates": [7, 1, 13, 25, 46, 2, 15, 10],
        "defined_desc": "Bản sắc và hướng đi cuộc đời ổn định, rõ ràng về con người mình và tình yêu bản thân, như một chiếc la bàn vững chãi.",
        "undefined_desc": "Bản sắc linh hoạt, đổi thay theo môi trường và người đồng hành; phát triển qua việc trải nghiệm nhiều con đường khác nhau.",
        "key_question": "Tôi có đang ám ảnh tìm kiếm xem tôi là ai và tôi đang đi về đâu không?"
    },
    "Heart": {
        "id": "Heart",
        "name_vi": "Trung tâm Tâm Ngã (Ý Chí)",
        "name_en": "Heart / Ego Center",
        "location": "Bên phải Thượng Ngã",
        "function_type": "Động cơ Ý chí & Giá trị bản thân (Motor)",
        "biological": "Tim, tuyến ức, dạ dày, túi mật",
        "defined_pct": "37%",
        "undefined_pct": "63%",
        "gates": [21, 51, 26, 40],
        "defined_desc": "Ý chí mạnh mẽ, quyết tâm cao, khả năng thực hiện cam kết và quản lý tài nguyên vật chất tuyệt vời.",
        "undefined_desc": "Giá trị bản thân là vốn có không cần chứng minh; không nên đưa ra những lời hứa ràng buộc ý chí hay cố làm hài lòng người khác.",
        "key_question": "Tôi có đang cảm thấy mình phải chứng minh giá trị bản thân với ai đó không?"
    },
    "Solar_Plexus": {
        "id": "Solar_Plexus",
        "name_vi": "Trung tâm Thái Dương",
        "name_en": "Solar Plexus Center",
        "location": "Bên phải Đan Điền",
        "function_type": "Nhận thức & Động cơ Cảm xúc (Awareness & Motor)",
        "biological": "Thận, tuyến tiền liệt, hệ thần kinh",
        "defined_pct": "53%",
        "undefined_pct": "47%",
        "gates": [36, 22, 37, 6, 49, 55, 30],
        "defined_desc": "Phát ra các làn sóng cảm xúc chu kỳ tự nhiên; cần chờ cảm xúc lắng đọng để đạt sự sáng suốt trước khi quyết định.",
        "undefined_desc": "Hấp thụ và khuếch đại cảm xúc từ người khác; là tấm gương thấu cảm nhưng cần thiết lập ranh giới cảm xúc lành mạnh.",
        "key_question": "Tôi có đang né tránh xung đột và sự thật vì sợ làm người khác buồn không?"
    },
    "Sacral": {
        "id": "Sacral",
        "name_vi": "Trung tâm Sinh Khí (Đan Điền)",
        "name_en": "Sacral Center",
        "location": "Bụng dưới",
        "function_type": "Động cơ Lực sống (Motor)",
        "biological": "Cơ quan sinh sản",
        "defined_pct": "67%",
        "undefined_pct": "33%",
        "gates": [5, 14, 29, 34, 27, 42, 3, 9, 59],
        "defined_desc": "Nguồn pin năng lượng bền bỉ, làm việc hăng say với điều mình yêu thích, phản hồi qua âm thanh Đan Điền.",
        "undefined_desc": "Không có nguồn năng lượng làm việc liên tục; cần biết điểm dừng để nghỉ ngơi và nạp lại năng lượng, tránh làm việc quá sức.",
        "key_question": "Tôi có biết khi nào là đủ để dừng lại và nghỉ ngơi không?"
    },
    "Spleen": {
        "id": "Spleen",
        "name_vi": "Trung tâm Sinh Giác (Lách)",
        "name_en": "Spleen Center",
        "location": "Bên trái Đan Điền",
        "function_type": "Nhận thức Trực giác Thể chất (Awareness)",
        "biological": "Hệ miễn dịch, hệ bạch huyết và lách",
        "defined_pct": "55%",
        "undefined_pct": "45%",
        "gates": [48, 57, 44, 50, 32, 28, 18],
        "defined_desc": "Trực giác sinh tồn nhạy bén trong khoảnh khắc hiện tại, hệ miễn dịch tốt, cảm nhận nhanh điều gì an toàn hay nguy hiểm.",
        "undefined_desc": "Nhạy cảm với sức khỏe và năng lượng người khác; dễ bám víu vào những mối quan hệ độc hại chỉ vì cảm giác an toàn quen thuộc.",
        "key_question": "Tôi có đang níu giữ điều gì không còn tốt đẹp cho mình chỉ vì sợ hãi không?"
    },
    "Root": {
        "id": "Root",
        "name_vi": "Trung tâm Gốc",
        "name_en": "Root Center",
        "location": "Đáy cơ thể",
        "function_type": "Áp lực & Động cơ Sinh tồn (Pressure & Motor)",
        "biological": "Tuyến thượng thận, adrenaline",
        "defined_pct": "60%",
        "undefined_pct": "40%",
        "gates": [53, 60, 52, 19, 39, 41, 54, 38, 58],
        "defined_desc": "Chịu đựng áp lực và căng thẳng tốt; có khả năng biến áp lực thành động lực hành động ổn định và nhất quán.",
        "undefined_desc": "Dễ bị áp lực và cảm giác vội vã từ người khác cuốn đi; cần học cách thư giãn và không để sự gấp gáp thúc ép hành động sai lầm.",
        "key_question": "Tôi có đang vội vã làm mọi thứ chỉ để giải phóng áp lực không?"
    }
}

# 5. 6 DÒNG & 12 HỒ SƠ NHÂN DẠNG (PROFILES) - Trang 158-188
profiles_data = {
    "lines": {
        "1": {"name": "Hiếu kỳ | Cặn kẽ", "name_en": "Investigator", "metaphor": "Nền móng ngôi nhà", "nature": "Cá nhân", "desc": "Cần nghiên cứu sâu, xây dựng nền tảng vững chắc để vượt qua nỗi bất an."},
        "2": {"name": "Tài năng | Thầm lặng", "name_en": "Hermit", "metaphor": "Cửa sổ tầng 1", "nature": "Cá nhân", "desc": "Thiên tài tự nhiên, cần thời gian bế quan tịnh dưỡng và chờ được gọi tên để tỏa sáng."},
        "3": {"name": "Thực nghiệm | Thích nghi", "name_en": "Martyr", "metaphor": "Cầu thang ngôi nhà", "nature": "Cá nhân", "desc": "Học qua thử và sai, kiên cường vượt qua vấp ngã để rút ra bài học thực chứng quý báu."},
        "4": {"name": "Quảng giao | Ổn định", "name_en": "Opportunist", "metaphor": "Ban công tầng 2", "nature": "Tập thể", "desc": "Xây dựng mạng lưới quan hệ sâu sắc, cơ hội đến từ bạn bè và người quen biết."},
        "5": {"name": "Lãnh đạo | Tầm nhìn xa", "name_en": "Heretic", "metaphor": "Cửa sổ ẩn tầng 2", "nature": "Tập thể", "desc": "Người đưa ra giải pháp thực tiễn cứu nguy cho tập thể, được kỳ vọng như vị cứu tinh."},
        "6": {"name": "Lý tưởng | Tấm gương sáng", "name_en": "Role Model", "metaphor": "Sân thượng / Nóc nhà", "nature": "Tập thể", "desc": "Hành trình 3 giai đoạn: Thử sai (0-30), Lên mái nhà chiêm nghiệm (30-50), Trở thành tấm gương mẫu mực (>50)."}
    },
    "profiles": {
        "1/3": {
            "name": "1/3: Hiếu kỳ | Cặn kẽ / Thực nghiệm | Thích nghi",
            "conscious": 1, "unconscious": 3, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Người khám phá chân lý qua sự kết hợp giữa nghiên cứu sâu sắc và thực chứng thử - sai. Bạn là chuyên gia với nền tảng kiến thức vững chắc và kinh nghiệm phong phú.",
            "career": "Nghiên cứu, chuyên gia tư vấn kỹ thuật, phát triển sản phẩm, cố vấn chiến lược.",
            "relationship": "Cần tìm hiểu kỹ đối tác để cảm thấy an toàn, học hỏi qua những thăng trầm để xây dựng niềm tin bền vững."
        },
        "1/4": {
            "name": "1/4: Hiếu kỳ | Cặn kẽ / Quảng giao | Ổn định",
            "conscious": 1, "unconscious": 4, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Người nắm vững nền tảng kiến thức và chia sẻ với mạng lưới thân thiết. Bạn xây dựng lòng tin qua sự uyên bác và mở rộng cơ hội từ bạn bè.",
            "career": "Giảng dạy, đào tạo, quản lý mạng lưới quan hệ, chuyên gia trong cộng đồng.",
            "relationship": "Muốn hiểu rõ nền tảng mối quan hệ trước khi cam kết; tình cảm thường phát triển từ nền tảng tình bạn thân thiết."
        },
        "2/4": {
            "name": "2/4: Tài năng | Thầm lặng / Quảng giao | Ổn định",
            "conscious": 2, "unconscious": 4, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Ẩn sĩ thân thiện. Vừa cần không gian riêng để trau dồi tài năng bẩm sinh, vừa là cầu nối tuyệt vời gắn kết mọi người khi được gọi ra khỏi vỏ ốc.",
            "career": "Nghệ sĩ, lập trình viên, nhà nghiên cứu độc lập, chuyên viên quan hệ công chúng.",
            "relationship": "Cần đối phương tôn trọng khoảng thời gian ở một mình, đồng thời rất chân thành và ấm áp khi kết nối."
        },
        "2/5": {
            "name": "2/5: Tài năng | Thầm lặng / Lãnh đạo | Tầm nhìn xa",
            "conscious": 2, "unconscious": 5, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Vị cứu tinh ẩn dật. Có tài năng tự nhiên để giải quyết vấn đề nan giải cho người khác khi được mời gọi đóng vai trò người dẫn dắt thực tế.",
            "career": "Cố vấn khủng hoảng, lãnh đạo chiến lược, chuyên gia giải pháp công nghệ.",
            "relationship": "Cần sự thấu hiểu từ bạn đời về nhu cầu ẩn dật, tránh bị áp đặt quá nhiều kỳ vọng viển vông từ đối phương."
        },
        "3/5": {
            "name": "3/5: Thực nghiệm | Thích nghi / Lãnh đạo | Tầm nhìn xa",
            "conscious": 3, "unconscious": 5, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Chiến binh kinh nghiệm đầy sức hút. Trải qua muôn vàn thử nghiệm và sai lầm để đúc kết thành kho trí tuệ thực tiễn giúp đỡ cả cộng đồng.",
            "career": "Doanh nhân khởi nghiệp, giải quyết khủng hoảng, diễn giả truyền cảm hứng, nhà đổi mới.",
            "relationship": "Cần người bạn đồng hành thấu hiểu bản chất thử-sai, không phán xét những giai đoạn biến động."
        },
        "3/6": {
            "name": "3/6: Thực nghiệm | Thích nghi / Lý tưởng | Tấm gương sáng",
            "conscious": 3, "unconscious": 6, "geometry": "Góc phải (Chủ đề cá nhân)",
            "summary": "Cầu nối giữa trải nghiệm thực tế và trí tuệ hình mẫu. Trải qua nửa đầu đời đầy gian nan thử thách để trở thành ngọn hải đăng khôn ngoan ở giai đoạn sau.",
            "career": "Tư vấn lãnh đạo, nhà văn, nhà phát triển con người, cố vấn cuộc sống.",
            "relationship": "Nửa đầu đời có nhiều thăng trầm trong tình cảm; sau tuổi 30 và 50 đạt được sự thấu hiểu và gắn kết mẫu mực."
        },
        "4/6": {
            "name": "4/6: Quảng giao | Ổn định / Lý tưởng | Tấm gương sáng",
            "conscious": 4, "unconscious": 6, "geometry": "Góc kết nối (Chủ đề ổn định)",
            "summary": "Người dẫn đường bằng tình bạn và gương mẫu. Sử dụng sức mạnh mạng lưới chân thành để truyền cảm hứng và trở thành hình mẫu đáng kính.",
            "career": "Lãnh đạo cộng đồng, ngoại giao, quản trị nhân sự, cố vấn tổ chức.",
            "relationship": "Coi trọng sự chân thành, minh bạch; tình yêu gắn liền với sự đồng điệu lý tưởng và phát triển chung."
        },
        "4/1": {
            "name": "4/1: Quảng giao | Ổn định / Hiếu kỳ | Cặn kẽ",
            "conscious": 4, "unconscious": 1, "geometry": "Góc kết nối (Cầu nối định mệnh)",
            "summary": "Hồ sơ hiếm có con đường cố định vững như bàn thạch. Kết hợp giữa sự thân thiện quảng giao và nền tảng nghiên cứu cặn kẽ.",
            "career": "Nhà giáo dục, nghiên cứu ứng dụng, xây dựng hệ thống quy chuẩn.",
            "relationship": "Cần đối tác tôn trọng lộ trình sống kiên định của mình, rất trung thành và đáng tin cậy."
        },
        "5/1": {
            "name": "5/1: Lãnh đạo | Tầm nhìn xa / Hiếu kỳ | Cặn kẽ",
            "conscious": 5, "unconscious": 1, "geometry": "Góc trái (Chủ đề liên cá nhân)",
            "summary": "Vị tướng thực thụ. Mang đến các giải pháp thực tế được xây dựng trên nền tảng nghiên cứu vững chắc. Người khác luôn tìm đến bạn để tìm lời giải.",
            "career": "Lãnh đạo doanh nghiệp, kiến trúc sư trưởng, chuyên gia tư vấn chiến lược cấp cao.",
            "relationship": "Cần bảo vệ ranh giới cá nhân, chỉ nhận trách nhiệm khi bản thân đã có đủ dữ liệu và nền tảng vững chắc."
        },
        "5/2": {
            "name": "5/2: Lãnh đạo | Tầm nhìn xa / Tài năng | Thầm lặng",
            "conscious": 5, "unconscious": 2, "geometry": "Góc trái (Chủ đề liên cá nhân)",
            "summary": "Nhà lãnh đạo tự nhiên với tài năng tiềm ẩn. Được xã hội kêu gọi đảm nhận trọng trách dù thâm tâm luôn muốn dành thời gian riêng tư.",
            "career": "Quản trị cấp cao, chuyên gia cố vấn độc lập, người dẫn dắt các phong trào cải cách.",
            "relationship": "Cần sự tôn trọng không gian riêng từ bạn đời, cân bằng giữa cống hiến cho xã hội và chăm sóc nội tâm."
        },
        "6/2": {
            "name": "6/2: Lý tưởng | Tấm gương sáng / Tài năng | Thầm lặng",
            "conscious": 6, "unconscious": 2, "geometry": "Góc trái (Chủ đề liên cá nhân)",
            "summary": "Tấm gương sáng mang vẻ đẹp thanh khiết của ẩn sĩ. Nhìn thấu bản chất cuộc đời, trải qua tôi luyện để trở thành người dẫn đường đầy uy tín và lòng từ bi.",
            "career": "Cố vấn cấp cao, triết gia, nhà trị liệu tinh thần, lãnh đạo tinh thần.",
            "relationship": "Tìm kiếm người bạn tâm giao có sự kết nối sâu sắc về tâm hồn, không thích sự hời hợt tầm thường."
        },
        "6/3": {
            "name": "6/3: Lý tưởng | Tấm gương sáng / Thực nghiệm | Thích nghi",
            "conscious": 6, "unconscious": 3, "geometry": "Góc trái (Chủ đề liên cá nhân)",
            "summary": "Người không ngừng học hỏi và làm mới mình. Luôn giữ tinh thần dấn thân thử nghiệm để hoàn thiện lý tưởng sống cao đẹp.",
            "career": "Nhà tiên phong đổi mới, nhà hoạt động xã hội, tác giả truyền cảm hứng.",
            "relationship": "Coi mối quan hệ như một hành trình học hỏi liên tục; kiên nhẫn vượt qua thử thách để xây dựng tình yêu đích thực."
        }
    }
}

with open(os.path.join(DATA_DIR, "authorities.json"), "w", encoding="utf-8") as f:
    json.dump(authorities_data, f, ensure_ascii=False, indent=2)

with open(os.path.join(DATA_DIR, "definitions.json"), "w", encoding="utf-8") as f:
    json.dump(definitions_data, f, ensure_ascii=False, indent=2)

with open(os.path.join(DATA_DIR, "centers.json"), "w", encoding="utf-8") as f:
    json.dump(centers_data, f, ensure_ascii=False, indent=2)

with open(os.path.join(DATA_DIR, "profiles.json"), "w", encoding="utf-8") as f:
    json.dump(profiles_data, f, ensure_ascii=False, indent=2)

print("Đã tạo authorities.json, definitions.json, centers.json, profiles.json thành công!")
