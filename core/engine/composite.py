"""
composite.py - Bộ tính toán Biểu đồ Hợp Đôi (Composite Chart) và Độ Tương Thích Quan Hệ
Phân tích tương tác năng lượng giữa hai người dựa trên các quy luật Human Design:
- Kênh Hấp Dẫn Tương Hỗ (Electromagnetic)
- Kênh Đồng Điệu (Companionship)
- Kênh Áp Đảo (Dominance)
- Kênh Thỏa Hiệp (Compromise)
- Động lực 9 Trung tâm (9-0, 8-1, 7-2, 6-3, 5-4)
"""

from typing import Dict, Any, List, Set
from hd_calculator import HumanDesignChart, CHANNELS_DATA, CENTERS_DATA

def calculate_composite(chart_a: HumanDesignChart, chart_b: HumanDesignChart, name_a: str = "Người A", name_b: str = "Người B") -> Dict[str, Any]:
    """
    So sánh và phân tích tương tác năng lượng giữa 2 lá số Human Design.
    """
    raw_a = chart_a.to_dict()
    raw_b = chart_b.to_dict()

    gates_a = set(raw_a["active_gates"].keys())
    gates_b = set(raw_b["active_gates"].keys())

    channels_a_ids = {ch["id"] for ch in raw_a["active_channels"]}
    channels_b_ids = {ch["id"] for ch in raw_b["active_channels"]}

    electromagnetic_channels = []
    companionship_channels = []
    dominance_a_channels = []
    dominance_b_channels = []
    compromise_a_channels = [] # A có trọn kênh, B có 1 cổng
    compromise_b_channels = [] # B có trọn kênh, A có 1 cổng

    composite_defined_centers = set(raw_a["defined_centers"]) | set(raw_b["defined_centers"])
    new_composite_channels = []

    for ch_id, ch_info in CHANNELS_DATA.items():
        g1, g2 = ch_info["gates"][0], ch_info["gates"][1]
        
        has_full_a = (ch_id in channels_a_ids) or (g1 in gates_a and g2 in gates_a)
        has_full_b = (ch_id in channels_b_ids) or (g1 in gates_b and g2 in gates_b)
        
        has_g1_a = g1 in gates_a
        has_g2_a = g2 in gates_a
        has_g1_b = g1 in gates_b
        has_g2_b = g2 in gates_b

        # 1. Đồng điệu (Companionship): Cả hai đều có trọn kênh
        if has_full_a and has_full_b:
            companionship_channels.append({
                "id": ch_id,
                "name_vi": ch_info["name_vi"],
                "description": f"Cả {name_a} và {name_b} đều sở hữu kênh này độc lập. Tạo nên sự thấu hiểu sâu sắc, chung một nhịp điệu tư duy và hành vi.",
                "advice": "Rất hòa hợp tự nhiên, nhưng đôi khi có thể trở nên quá quen thuộc hoặc cạnh tranh ngầm trong lĩnh vực này."
            })
            
        # 2. Hấp dẫn tương hỗ (Electromagnetic): Mỗi người giữ một cổng, cùng nhau hoàn thiện kênh
        elif not has_full_a and not has_full_b:
            if (has_g1_a and has_g2_b) or (has_g2_a and has_g1_b):
                gate_a_num = g1 if has_g1_a else g2
                gate_b_num = g2 if has_g1_a else g1
                electromagnetic_channels.append({
                    "id": ch_id,
                    "name_vi": ch_info["name_vi"],
                    "gate_a": gate_a_num,
                    "gate_b": gate_b_num,
                    "description": f"{name_a} giữ Cổng {gate_a_num}, {name_b} giữ Cổng {gate_b_num}. Khi ở cạnh nhau, hai bạn kích hoạt trọn vẹn Kênh {ch_info['name_vi']}, tạo nên sức hút nam châm mãnh liệt.",
                    "advice": "Sức hút ban đầu rất lớn. Hãy trân trọng sự bổ khuyết của đối phương thay vì cố gắng thay đổi nửa kia theo ý mình."
                })
                # Kênh mới này làm xác định thêm trung tâm trong biểu đồ hợp đôi
                composite_defined_centers.add(ch_info["centers"][0])
                composite_defined_centers.add(ch_info["centers"][1])
                new_composite_channels.append(ch_id)

        # 3. Áp đảo hoặc Thỏa hiệp
        elif has_full_a and not has_full_b:
            if has_g1_b or has_g2_b:
                # Compromise: A có trọn kênh, B có 1 cổng
                shared_gate = g1 if has_g1_b else g2
                compromise_a_channels.append({
                    "id": ch_id,
                    "name_vi": ch_info["name_vi"],
                    "holder": name_a,
                    "single_gate_holder": name_b,
                    "gate": shared_gate,
                    "description": f"{name_a} có trọn vẹn kênh, trong khi {name_b} chỉ giữ Cổng {shared_gate}. {name_b} có thể cảm thấy năng lượng của mình bị cuốn theo cách vận hành cố định của {name_a}.",
                    "advice": f"{name_a} cần linh hoạt, không áp đặt quy chuẩn của mình lên {name_b}; {name_b} cần học cách thả lỏng không phản kháng trong chủ đề này."
                })
            else:
                # Dominance: A có trọn kênh, B không có cổng nào
                dominance_a_channels.append({
                    "id": ch_id,
                    "name_vi": ch_info["name_vi"],
                    "dominant": name_a,
                    "receiver": name_b,
                    "description": f"{name_a} dẫn dắt hoàn toàn năng lượng Kênh {ch_info['name_vi']}. {name_b} tiếp nhận và học hỏi trường năng lượng này từ {name_a}.",
                    "advice": f"{name_a} là người dẫn đường tự nhiên, {name_b} sẽ cảm nhận được sự vững chãi nếu tin tưởng."
                })

        elif has_full_b and not has_full_a:
            if has_g1_a or has_g2_a:
                # Compromise: B có trọn kênh, A có 1 cổng
                shared_gate = g1 if has_g1_a else g2
                compromise_b_channels.append({
                    "id": ch_id,
                    "name_vi": ch_info["name_vi"],
                    "holder": name_b,
                    "single_gate_holder": name_a,
                    "gate": shared_gate,
                    "description": f"{name_b} có trọn vẹn kênh, trong khi {name_a} chỉ giữ Cổng {shared_gate}. {name_a} có thể cảm thấy phong cách cá nhân của mình bị hòa tan vào dòng năng lượng của {name_b}.",
                    "advice": f"{name_b} cần thấu hiểu và tôn trọng góc nhìn độc lập của {name_a}; {name_a} không nên xem đây là sự lấn lướt."
                })
            else:
                # Dominance: B có trọn kênh, A không có cổng nào
                dominance_b_channels.append({
                    "id": ch_id,
                    "name_vi": ch_info["name_vi"],
                    "dominant": name_b,
                    "receiver": name_a,
                    "description": f"{name_b} dẫn dắt hoàn toàn năng lượng Kênh {ch_info['name_vi']}. {name_a} tiếp nhận và học hỏi trường năng lượng này từ {name_b}.",
                    "advice": f"{name_b} truyền cảm hứng, {name_a} được mở rộng thế giới quan."
                })

    # Phân tích tỷ lệ Trung tâm Năng Lượng Hợp Đôi (9 Trung tâm)
    num_defined_composite = len(composite_defined_centers)
    num_undefined_composite = 9 - num_defined_composite
    dynamic_ratio_key = f"{num_defined_composite}-{num_undefined_composite}"

    dynamic_meanings = {
        "9-0": {
            "title": "9 - 0: Gắn Kết Khép Kín (Nowhere to Go)",
            "summary": "Toàn bộ 9 trung tâm đều được xác định khi hai bạn kết hợp. Một mối liên kết vô cùng mãnh liệt, cuốn hút và gắn bó chặt chẽ.",
            "advice": "Rất khó tách rời, nhưng dễ tạo cảm giác ngột ngạt nếu ở bên nhau 24/7. Cần dành cho nhau những khoảng không gian và sở thích riêng để cân bằng."
        },
        "8-1": {
            "title": "8 - 1: Cửa Sổ Trải Nghiệm Lý Tưởng (Have Some Fun)",
            "summary": "8 trung tâm được xác định và 1 trung tâm mở. Đây là tỷ lệ tương tác được đánh giá lý tưởng nhất trong Human Design.",
            "advice": "Đủ sự gắn kết vững chãi nhưng vẫn có một 'cửa sổ' mở ra thế giới bên ngoài để cùng khám phá, vui vẻ và làm mới tình cảm."
        },
        "7-2": {
            "title": "7 - 2: Đồng Hành Học Hỏi (Work to Do)",
            "summary": "7 trung tâm xác định và 2 trung tâm mở. Mối quan hệ mang tính thúc đẩy phát triển và học hỏi lẫn nhau rất cao.",
            "advice": "Hai bạn có nhiều chủ đề để cùng chia sẻ, hoàn thiện bản thân và bổ trợ nhau trong công việc lẫn cuộc sống thường nhật."
        },
        "6-3": {
            "title": "6 - 3: Độc Lập & Tự Do (Free Birds)",
            "summary": "6 trung tâm xác định và 3 trung tâm mở. Cả hai người giữ được mức độ độc lập cao về phong cách sống và tư duy.",
            "advice": "Mối quan hệ thoáng đạt, tôn trọng tự do cá nhân, cần chủ động chia sẻ nhiều hơn để duy trì sự gắn kết bền chặt."
        },
        "5-4": {
            "title": "5 - 4: Không Gian Rộng Mở",
            "summary": "5 trung tâm xác định và 4 trung tâm mở. Hai cá tính riêng biệt cùng đồng hành mà không làm xáo trộn bản chất của nhau.",
            "advice": "Cần xây dựng những mục tiêu và cam kết chung rõ ràng để định hướng cho mối quan hệ dài hạn."
        }
    }
    
    dynamic_info = dynamic_meanings.get(dynamic_ratio_key, {
        "title": f"{dynamic_ratio_key}: Động Lực Tương Tác",
        "summary": f"Có {num_defined_composite} trung tâm xác định và {num_undefined_composite} trung tâm mở khi hai bạn ở cạnh nhau.",
        "advice": "Tận dụng những điểm mạnh chung và tôn trọng sự tự do của nhau."
    })

    # Đánh giá chỉ số hòa hợp (Compatibility Score 0 - 100)
    score = 65
    score += len(electromagnetic_channels) * 6   # Sức hút nam châm
    score += len(companionship_channels) * 4     # Đồng điệu
    score -= (len(compromise_a_channels) + len(compromise_b_channels)) * 4 # Thỏa hiệp có thể gây xung đột
    if dynamic_ratio_key in ["8-1", "7-2"]:
        score += 8
    elif dynamic_ratio_key == "9-0":
        score += 5
    score = max(45, min(98, score))

    # Tương tác giữa 2 Nhóm năng lượng
    type_a_name = raw_a["type"]["name_vi"]
    type_b_name = raw_b["type"]["name_vi"]
    type_interaction = f"Tương tác giữa {type_a_name} ({name_a}) và {type_b_name} ({name_b}): Cần tôn trọng chiến lược sống của nhau. {name_a} nên vận dụng: '{raw_a['type']['strategy']['name']}', trong khi {name_b} nên vận dụng: '{raw_b['type']['strategy']['name']}'."

    return {
        "person_a": {
            "name": name_a,
            "type": type_a_name,
            "profile": raw_a["profile"]["profile"],
            "authority": raw_a["authority"]["name_vi"]
        },
        "person_b": {
            "name": name_b,
            "type": type_b_name,
            "profile": raw_b["profile"]["profile"],
            "authority": raw_b["authority"]["name_vi"]
        },
        "compatibility_score": score,
        "center_dynamic": {
            "ratio": dynamic_ratio_key,
            "title": dynamic_info["title"],
            "summary": dynamic_info["summary"],
            "advice": dynamic_info["advice"],
            "defined_centers_count": num_defined_composite,
            "undefined_centers_count": num_undefined_composite,
            "composite_defined_centers": list(composite_defined_centers)
        },
        "type_interaction": type_interaction,
        "channels": {
            "electromagnetic": electromagnetic_channels,
            "companionship": companionship_channels,
            "dominance": {
                f"{name_a}_dominant": dominance_a_channels,
                f"{name_b}_dominant": dominance_b_channels
            },
            "compromise": {
                f"{name_a}_compromised": compromise_b_channels,
                f"{name_b}_compromised": compromise_a_channels
            }
        }
    }
