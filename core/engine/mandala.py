"""
mandala.py - Bản đồ Mandala Bánh xe 64 Cổng và Tọa độ Hoàng đạo
Ánh xạ chính xác giữa Kinh độ Hoàng đạo (Ecliptic Longitude) và Cổng, Hào, Sắc thái trong Human Design.
"""

from typing import Dict, Any, Tuple

# Thứ tự 64 Cổng trên vòng tròn Mandala (bắt đầu từ Cổng 41 Hào 1 tại 302.0° Hoàng đạo - 02°00'00" Bảo Bình)
MANDALA_GATES = [
    41, 19, 13, 49, 30, 55, 37, 63, 22, 36, 25, 17, 21, 51, 42, 3,
    27, 24, 2, 23, 8, 20, 16, 35, 45, 12, 15, 52, 39, 53, 62, 56,
    31, 33, 7, 4, 29, 59, 40, 64, 47, 6, 46, 18, 48, 57, 32, 50,
    28, 44, 1, 43, 14, 34, 9, 5, 26, 11, 10, 58, 38, 54, 61, 60
]

MANDALA_START_OFFSET = 302.0  # Độ bắt đầu của Cổng 41 (Aquarius 02° 00' 00")
GATE_ARC = 360.0 / 64.0        # 5.625° mỗi cổng
LINE_ARC = GATE_ARC / 6.0       # 0.9375° mỗi hào
COLOR_ARC = LINE_ARC / 6.0      # ~0.15625° mỗi sắc thái (color)
TONE_ARC = COLOR_ARC / 6.0      # ~0.02604° mỗi âm sắc (tone)
BASE_ARC = TONE_ARC / 5.0       # ~0.005208° mỗi tầng cơ sở (base)

ZODIAC_SIGNS = [
    ("Bạch Dương", "Aries", 0.0),
    ("Kim Ngưu", "Taurus", 30.0),
    ("Song Tử", "Gemini", 60.0),
    ("Cự Giải", "Cancer", 90.0),
    ("Sư Tử", "Leo", 120.0),
    ("Xử Nữ", "Virgo", 150.0),
    ("Thiên Bình", "Libra", 180.0),
    ("Bọ Cạp", "Scorpio", 210.0),
    ("Nhân Mã", "Sagittarius", 240.0),
    ("Ma Kết", "Capricorn", 270.0),
    ("Bảo Bình", "Aquarius", 300.0),
    ("Song Ngư", "Pisces", 330.0)
]

# Ánh xạ Cổng thuộc Trung tâm nào
GATE_TO_CENTER = {
    64: "Head", 61: "Head", 63: "Head",
    47: "Ajna", 24: "Ajna", 4: "Ajna", 17: "Ajna", 43: "Ajna", 11: "Ajna",
    62: "Throat", 23: "Throat", 56: "Throat", 35: "Throat", 12: "Throat",
    45: "Throat", 33: "Throat", 8: "Throat", 31: "Throat", 20: "Throat", 16: "Throat",
    7: "G_Center", 1: "G_Center", 13: "G_Center", 25: "G_Center",
    46: "G_Center", 2: "G_Center", 15: "G_Center", 10: "G_Center",
    21: "Heart", 51: "Heart", 26: "Heart", 40: "Heart",
    36: "Solar_Plexus", 22: "Solar_Plexus", 37: "Solar_Plexus",
    6: "Solar_Plexus", 49: "Solar_Plexus", 55: "Solar_Plexus", 30: "Solar_Plexus",
    5: "Sacral", 14: "Sacral", 29: "Sacral", 34: "Sacral",
    27: "Sacral", 42: "Sacral", 3: "Sacral", 9: "Sacral", 59: "Sacral",
    48: "Spleen", 57: "Spleen", 44: "Spleen", 50: "Spleen",
    32: "Spleen", 28: "Spleen", 18: "Spleen",
    53: "Root", 60: "Root", 52: "Root", 19: "Root", 39: "Root",
    41: "Root", 54: "Root", 38: "Root", 58: "Root"
}

# Tên và từ khóa 6 Hào theo sách
LINES_INFO = {
    1: {
        "name_vi": "Nền móng (Investigator)",
        "keyword": "Nghiên cứu, cội nguồn, an toàn",
        "description": "Cần thấu hiểu bản chất cốt lõi trước khi hành động; học hỏi sâu sắc để xây dựng nền tảng vững chắc."
    },
    2: {
        "name_vi": "Ẩn sĩ (Hermit)",
        "keyword": "Tài năng tự nhiên, không gian riêng, phản xạ",
        "description": "Tố chất thiên bẩm không cần gượng ép; phát huy rực rỡ khi được thế giới bên ngoài nhìn nhận và gọi tên."
    },
    3: {
        "name_vi": "Khám phá/Thử nghiệm (Martyr)",
        "keyword": "Thử sai, trải nghiệm, thích nghi",
        "description": "Học hỏi thông qua trải nghiệm thực tế; thất bại chính là bài học quý giá để tìm ra giải pháp tối ưu."
    },
    4: {
        "name_vi": "Cơ hội/Mạng lưới (Opportunist)",
        "keyword": "Mối quan hệ, tình bạn, kết nối",
        "description": "Cơ hội đến từ cộng đồng và người quen biết; xây dựng niềm tin trước khi chia sẻ định hướng hoặc làm ăn."
    },
    5: {
        "name_vi": "Dị giáo/Kỳ vọng (Heretic)",
        "keyword": "Giải pháp thực tế, phóng chiếu, cứu tinh",
        "description": "Người giải quyết khủng hoảng xuất sắc; cần giữ gìn danh tiếng và đặt ranh giới thực tế trước kỳ vọng xã hội."
    },
    6: {
        "name_vi": "Hình mẫu (Role Model)",
        "keyword": "3 giai đoạn, thông thái, tấm gương sống",
        "description": "Trải nghiệm sâu sắc và dần trở thành hình mẫu sống chân thật; sống đúng với bản thiết kế để truyền cảm hứng."
    }
}

def get_zodiac_details(lon: float) -> Tuple[str, str, str]:
    """Chuyển kinh độ hoàng đạo thành Cung hoàng đạo và độ:phút:giây"""
    normalized = lon % 360.0
    sign_idx = int(normalized / 30.0)
    sign_vi, sign_en, sign_start = ZODIAC_SIGNS[sign_idx]
    
    deg_in_sign = normalized - sign_start
    degrees = int(deg_in_sign)
    minutes = int((deg_in_sign - degrees) * 60)
    seconds = int(((deg_in_sign - degrees) * 60 - minutes) * 60)
    
    formatted = f"{degrees:02d}° {minutes:02d}' {seconds:02d}'' {sign_vi}"
    return sign_vi, sign_en, formatted

def ecliptic_to_gate_line(longitude: float) -> Dict[str, Any]:
    """
    Chuyển đổi kinh độ hoàng đạo (0 - 360 độ) thành Cổng, Hào, Sắc thái, Tầng cơ sở.
    """
    # Tính khoảng cách góc so với điểm khởi đầu Mandala (302.0 độ)
    offset = (longitude - MANDALA_START_OFFSET) % 360.0
    if offset < 0:
        offset += 360.0
        
    gate_index = int(offset / GATE_ARC)
    gate = MANDALA_GATES[gate_index]
    
    # Khoảng cách bên trong cổng
    gate_internal_offset = offset - (gate_index * GATE_ARC)
    
    # Tính hào (Line: 1 - 6)
    line = int(gate_internal_offset / LINE_ARC) + 1
    if line > 6:
        line = 6
        
    # Khoảng cách bên trong hào
    line_internal_offset = gate_internal_offset - ((line - 1) * LINE_ARC)
    
    # Tính Color (1 - 6)
    color = int(line_internal_offset / COLOR_ARC) + 1
    if color > 6:
        color = 6
        
    color_internal_offset = line_internal_offset - ((color - 1) * COLOR_ARC)
    
    # Tính Tone (1 - 6)
    tone = int(color_internal_offset / TONE_ARC) + 1
    if tone > 6:
        tone = 6
        
    tone_internal_offset = color_internal_offset - ((tone - 1) * TONE_ARC)
    
    # Tính Base (1 - 5)
    base = int(tone_internal_offset / BASE_ARC) + 1
    if base > 5:
        base = 5
        
    sign_vi, sign_en, zodiac_str = get_zodiac_details(longitude)
    center_id = GATE_TO_CENTER.get(gate, "")
    
    return {
        "gate": gate,
        "line": line,
        "color": color,
        "tone": tone,
        "base": base,
        "gate_line_str": f"{gate}.{line}",
        "center_id": center_id,
        "longitude": longitude,
        "zodiac_vi": sign_vi,
        "zodiac_en": sign_en,
        "zodiac_formatted": zodiac_str,
        "line_info": LINES_INFO.get(line, {})
    }
