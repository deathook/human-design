"""
interpreter.py - Bộ biên dịch và luận giải chuyên sâu Human Design
Tổng hợp toàn bộ luận giải chi tiết theo đúng cấu trúc và nội dung cuốn sách 
"Human Design Cho Người Mới Bắt Đầu" (TH Group - Tinh Hoa Bản Mệnh).
"""

from typing import Dict, Any, List
from hd_calculator import HumanDesignChart, GATES_DATA, CHANNELS_DATA, CENTERS_DATA

def generate_full_reading(chart: HumanDesignChart) -> Dict[str, Any]:
    """
    Sinh báo cáo luận giải chi tiết từ lá số Human Design.
    Bao gồm 8 phần chuyên sâu:
    1. Tổng quan Bản Mệnh
    2. Nhóm Năng Lượng & Chiến Lược Sống
    3. Quyền Năng Bên Trong (Thẩm Quyền Ra Quyết Định)
    4. Hồ Sơ Cá Nhân & Vai Trò Cuộc Đời
    5. Phân Tích 9 Trung Tâm Năng Lượng
    6. Các Kênh Dẫn Năng Lượng Kích Hoạt
    7. Các Cổng Kích Hoạt & Tần Số Rung Động
    8. Thánh Giá Hóa Thân & Sứ Mệnh Cuộc Đời
    """
    data = chart.to_dict()
    
    # Trích xuất signature và not_self an toàn
    raw_sig = data["type"].get("signature", "")
    sig_str = raw_sig if isinstance(raw_sig, str) else raw_sig.get("name_vi", str(raw_sig))
    
    raw_not_self = data["type"].get("not_self", "")
    not_self_str = raw_not_self if isinstance(raw_not_self, str) else raw_not_self.get("name_vi", str(raw_not_self))

    pop_pct = data["type"].get("population_pct", data["type"].get("percentage", ""))

    # 1. Tổng quan bản mệnh
    overview = {
        "title": "Tổng Quan Bản Mệnh Nhân Khí (Human Design)",
        "type": data["type"]["name_vi"],
        "strategy": data["type"]["strategy"]["name"],
        "authority": data["authority"]["name_vi"],
        "profile": data["profile"]["profile"],
        "profile_name": data["profile"]["name_vi"],
        "definition": data["definition"]["name_vi"],
        "incarnation_cross": data["incarnation_cross"]["name"],
        "signature": sig_str,
        "not_self": not_self_str,
        "defined_centers_count": len(data["defined_centers"]),
        "undefined_centers_count": len(data["undefined_centers"]),
        "active_channels_count": len(data["active_channels"]),
        "active_gates_count": len(data["active_gates"])
    }
    
    # 2. Luận giải chi tiết Nhóm Năng Lượng
    type_data = data["type"]
    type_reading = {
        "name_vi": type_data["name_vi"],
        "name_en": type_data.get("name_en", type_data.get("id", "")),
        "percentage": pop_pct,
        "affirmation": type_data.get("affirmation", ""),
        "strategy": type_data.get("strategy", {}),
        "signature": sig_str,
        "not_self": not_self_str,
        "animal_symbol": type_data.get("animal_symbol", ""),
        "strengths": type_data.get("strengths", []),
        "weaknesses": type_data.get("weaknesses", type_data.get("challenges", [])),
        "career_advice": type_data.get("career_advice", ""),
        "relationship_advice": type_data.get("relationship_advice", ""),
        "synthesis": (
            f"Bạn thuộc {type_data['name_vi']}, chiếm khoảng {pop_pct} dân số thế giới. "
            f"Chiến lược sống cốt lõi để thu hút thuận duyên là: {type_data['strategy']['name']} - {type_data['strategy']['description']}. "
            f"Khi sống đúng bản thiết kế, bạn sẽ trải nghiệm cảm xúc {sig_str}. "
            f"Ngược lại, nếu cố gượng ép theo kỳ vọng xã hội, bạn sẽ rơi vào trạng thái phi ngã là {not_self_str}."
        )
    }

    # 3. Luận giải Thẩm Quyền Ra Quyết Định
    auth_data = data["authority"]
    authority_reading = {
        "name_vi": auth_data["name_vi"],
        "rank": auth_data.get("rank", 1),
        "center_vi": auth_data.get("center_vi", ""),
        "population_pct": auth_data.get("population_pct", ""),
        "affirmation": auth_data.get("affirmation", ""),
        "description": auth_data.get("description", ""),
        "decision_rule": auth_data.get("decision_rule", ""),
        "wave_types": auth_data.get("wave_types", []),
        "synthesis": (
            f"Thẩm quyền ra quyết định của bạn là {auth_data['name_vi']}. "
            f"{auth_data['description']} "
            f"Nguyên tắc vàng khi đưa ra quyết định: {auth_data['decision_rule']}"
        )
    }

    # 4. Luận giải Hồ Sơ Cá Nhân (Profile)
    prof_data = data["profile"]
    profile_reading = {
        "profile": prof_data["profile"],
        "name_vi": prof_data["name_vi"],
        "geometry": prof_data.get("geometry", ""),
        "summary": prof_data.get("summary", ""),
        "career": prof_data.get("career", ""),
        "relationship": prof_data.get("relationship", ""),
        "conscious_line": prof_data.get("conscious_line_info", {}),
        "unconscious_line": prof_data.get("unconscious_line_info", {}),
        "synthesis": (
            f"Hồ sơ {prof_data['profile']} ({prof_data['name_vi']}) định hình vai trò và lăng kính bạn tương tác với cuộc sống. "
            f"{prof_data.get('summary', '')} "
            f"Trong sự nghiệp: {prof_data.get('career', '')} "
            f"Trong các mối quan hệ: {prof_data.get('relationship', '')}"
        )
    }

    # 5. Phân tích 9 Trung Tâm Năng Lượng
    centers_reading = []
    for c_id, c_data in data["centers"].items():
        is_def = c_data["is_defined"]
        centers_reading.append({
            "id": c_id,
            "name_vi": c_data["name_vi"],
            "is_defined": is_def,
            "status_text": c_data["status"],
            "description": c_data["defined_desc"] if is_def else c_data["undefined_desc"],
            "key_question": c_data["key_question"],
            "active_gates": c_data["active_gates_in_center"],
            "advice": (
                f"Đây là nguồn năng lượng ổn định, bền vững của bạn. Hãy tự tin dựa vào nguồn lực này và cẩn trọng tránh áp đặt lên người khác."
                if is_def else
                f"Trung tâm này mở, là nơi bạn đón nhận và khuếch đại năng lượng từ bên ngoài. Hãy chiêm nghiệm câu hỏi: '{c_data['key_question']}' để giải phóng áp lực tâm lý."
            )
        })

    # 6. Luận giải Các Kênh Hoạt Động
    channels_reading = []
    for ch in data["active_channels"]:
        nature_vi = {
            "conscious": "Ý thức (Tính cách)",
            "unconscious": "Vô thức (Thiết kế)",
            "mixed": "Hỗn hợp (Ý thức & Vô thức)"
        }.get(ch["nature"], ch["nature"])
        
        channels_reading.append({
            "id": ch["id"],
            "name_vi": ch["name_vi"],
            "name_en": ch["name_en"],
            "nature_vi": nature_vi,
            "group": ch["group"],
            "circuit": ch["circuit"],
            "subcircuit": ch["subcircuit"],
            "centers_vi": ch["centers_vi"],
            "description": ch["description"],
            "advice": ch["advice"],
            "synthesis": (
                f"Kênh {ch['id']} - {ch['name_vi']} ({ch['name_en']}) thuộc nhóm {ch['group']}, dòng mạch {ch['circuit']} ({ch['subcircuit']}). "
                f"Kênh kết nối {ch['centers_vi'][0]} và {ch['centers_vi'][1]}, thể hiện dưới dạng năng lượng {nature_vi}. "
                f"Tài năng cốt lõi: {ch['description']} "
                f"Lời khuyên phát triển: {ch['advice']}"
            )
        })

    # 7. Luận giải Các Cổng Kích Hoạt
    gates_reading = []
    for g_id, g_data in data["active_gates"].items():
        g_info = GATES_DATA.get(str(g_id), {})
        act_type_vi = {
            "personality": "Ý thức (Đen/Vàng)",
            "design": "Vô thức (Đỏ/Xanh)",
            "both": "Song trùng (Cả Ý thức và Vô thức)"
        }.get(g_data["activation_type"], g_data["activation_type"])

        gates_reading.append({
            "gate": g_id,
            "name_vi": g_data["name_vi"],
            "hexagram_title": g_data["hexagram_title"],
            "center_id": g_data["center_id"],
            "activation_type_vi": act_type_vi,
            "high_frequency": g_info.get("high_frequency", ""),
            "low_frequency": g_info.get("low_frequency", ""),
            "voice": g_info.get("voice", ""),
            "relationship_advice": g_info.get("relationship_advice", ""),
            "planets_detail": {
                "personality": g_data["personality_activations"],
                "design": g_data["design_activations"]
            }
        })

    # 8. Luận giải Thánh Giá Hóa Thân (Incarnation Cross)
    cross_data = data["incarnation_cross"]
    cross_reading = {
        "name": cross_data["name"],
        "angle": cross_data["angle"],
        "destiny": cross_data["destiny"],
        "gates_formula": cross_data["gates"]["formula"],
        "description": cross_data["description"],
        "synthesis": (
            f"Thánh Giá Hóa Thân của bạn là '{cross_data['name']}' mang góc hình {cross_data['angle']}. "
            f"Chủ đề số mệnh: {cross_data['destiny']}. "
            f"{cross_data['description']}"
        )
    }

    return {
        "birth_info": data["birth_info"],
        "overview": overview,
        "type_reading": type_reading,
        "authority_reading": authority_reading,
        "profile_reading": profile_reading,
        "centers_reading": centers_reading,
        "channels_reading": channels_reading,
        "gates_reading": gates_reading,
        "cross_reading": cross_reading,
        "raw_chart": data
    }
