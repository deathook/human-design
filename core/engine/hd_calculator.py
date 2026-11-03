"""
hd_calculator.py - Bộ xử lý trung tâm tính toán lá số Human Design
Tích hợp thiên văn học, bản đồ Mandala 64 cổng, và cơ sở tri thức độc quyền từ sách "Human Design Cho Người Mới Bắt Đầu".
"""

import os
import json
from datetime import datetime
from typing import Dict, Any, List, Set
from collections import defaultdict, deque

from astronomy import calculate_planetary_positions
from mandala import ecliptic_to_gate_line, GATE_TO_CENTER

# Tải dữ liệu JSON nền tảng từ thư mục data
DATA_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data")

def load_json_data(filename: str) -> dict:
    filepath = os.path.join(DATA_DIR, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        return json.load(f)

TYPES_DATA = load_json_data("types.json")
AUTHORITIES_DATA = load_json_data("authorities.json")
DEFINITIONS_DATA = load_json_data("definitions.json")
CENTERS_DATA = load_json_data("centers.json")
PROFILES_DATA = load_json_data("profiles.json")
PROFILES_DICT = PROFILES_DATA.get("profiles", {})
LINES_DICT = PROFILES_DATA.get("lines", {})
CHANNELS_DATA = load_json_data("channels.json")
GATES_DATA = load_json_data("gates.json")

# Định nghĩa các trung tâm Động cơ (Motors)
MOTOR_CENTERS = {"Sacral", "Heart", "Solar_Plexus", "Root"}

class HumanDesignChart:
    """Lớp đối tượng đại diện cho một lá số Human Design hoàn chỉnh"""
    
    def __init__(self, raw_data: Dict[str, Any]):
        self.raw = raw_data
        self.type_id = raw_data["type"]["id"]
        self.type_name = raw_data["type"]["name_vi"]
        self.authority_id = raw_data["authority"]["id"]
        self.authority_name = raw_data["authority"]["name_vi"]
        self.profile_key = raw_data["profile"]["key"]
        self.definition_id = raw_data["definition"]["id"]
        self.defined_centers = raw_data["defined_centers"]
        self.undefined_centers = raw_data["undefined_centers"]
        self.active_channels = raw_data["active_channels"]
        self.active_gates = raw_data["active_gates"]

    def to_dict(self) -> Dict[str, Any]:
        return self.raw

def determine_type_and_strategy(
    defined_centers: Set[str],
    active_channels: List[Dict[str, Any]]
) -> Dict[str, Any]:
    """
    Xác định Nhóm Năng Lượng (Type) và Chiến Lược (Strategy) dựa trên đồ thị kết nối các trung tâm.
    Quy tắc từ sách:
    1. Có Đan Điền (Sacral) xác định:
       - Có dòng dẫn từ bất kỳ Động cơ nào (Sacral, Heart, Solar Plexus, Root) lên Tuệ Ngôn (Throat)
         => Khởi Xướng - Vận Hành (Manifesting Generator)
       - Không có dòng dẫn động cơ lên Tuệ Ngôn => Vận Hành (Generator)
    2. Không có Đan Điền (Sacral):
       - Không có trung tâm nào xác định (0 trung tâm) => Phản Chiếu (Reflector)
       - Có trung tâm xác định:
         - Có dòng dẫn từ Động cơ lên Tuệ Ngôn => Khởi Xướng (Manifestor)
         - Không có dòng dẫn Động cơ lên Tuệ Ngôn => Khai Vấn (Projector)
    """
    # Xây dựng đồ thị các trung tâm xác định được kết nối bởi kênh kích hoạt
    adj = defaultdict(list)
    for ch in active_channels:
        c1, c2 = ch["centers"][0], ch["centers"][1]
        adj[c1].append(c2)
        adj[c2].append(c1)
        
    # Kiểm tra xem có đường dẫn từ Động cơ nào lên Trung tâm Tuệ Ngôn (Throat) hay không
    throat_connected_to_motor = False
    if "Throat" in defined_centers:
        queue = deque(["Throat"])
        visited = {"Throat"}
        while queue:
            curr = queue.popleft()
            if curr in MOTOR_CENTERS:
                throat_connected_to_motor = True
                break
            for neighbor in adj[curr]:
                if neighbor in defined_centers and neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)

    is_sacral_defined = "Sacral" in defined_centers

    if is_sacral_defined:
        if throat_connected_to_motor:
            type_id = "Manifesting_Generator"
        else:
            type_id = "Generator"
    else:
        if len(defined_centers) == 0:
            type_id = "Reflector"
        elif throat_connected_to_motor:
            type_id = "Manifestor"
        else:
            type_id = "Projector"

    return TYPES_DATA[type_id]

def determine_authority(defined_centers: Set[str], active_channels: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Xác định Thẩm Quyền Ra Quyết Định theo thứ bậc ưu tiên 1 - 7:
    1. Thái Dương (Solar Plexus)
    2. Nguồn sinh lực / Đan Điền (Sacral)
    3. Nhận thức Lách / Sinh Giác (Spleen)
    4. Bản ngã / Tâm Ngã (Heart/Ego)
    5. Danh tính / Thượng Ngã (G-Center / Self-Projected)
    6. Môi trường / Tâm trí (Mental / None)
    7. Chu kỳ Mặt trăng (Lunar Cycle - Reflector)
    """
    if "Solar_Plexus" in defined_centers:
        auth_id = "Emotional"
    elif "Sacral" in defined_centers:
        auth_id = "Sacral"
    elif "Spleen" in defined_centers:
        auth_id = "Splenic"
    elif "Heart" in defined_centers:
        auth_id = "Ego"
    elif "G_Center" in defined_centers:
        auth_id = "Self_Projected"
    elif len(defined_centers) > 0:
        auth_id = "Environmental"
    else:
        auth_id = "Lunar"
        
    return AUTHORITIES_DATA[auth_id]

def determine_definition(defined_centers: Set[str], active_channels: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Tính định nghĩa liên kết (Definition): Đơn, Đôi, Ba, Bốn hoặc Không liên kết.
    Dựa trên số lượng thành phần liên thông (Connected Components) giữa các trung tâm xác định.
    """
    if not defined_centers:
        return DEFINITIONS_DATA["None"]
        
    adj = defaultdict(list)
    for ch in active_channels:
        c1, c2 = ch["centers"][0], ch["centers"][1]
        adj[c1].append(c2)
        adj[c2].append(c1)
        
    visited = set()
    components_count = 0
    
    for center in defined_centers:
        if center not in visited:
            components_count += 1
            queue = deque([center])
            visited.add(center)
            while queue:
                curr = queue.popleft()
                for neighbor in adj[curr]:
                    if neighbor in defined_centers and neighbor not in visited:
                        visited.add(neighbor)
                        queue.append(neighbor)
                        
    if components_count == 1:
        def_id = "Single"
    elif components_count == 2:
        def_id = "Split"
    elif components_count == 3:
        def_id = "Triple_Split"
    elif components_count >= 4:
        def_id = "Quadruple_Split"
    else:
        def_id = "None"
        
    return DEFINITIONS_DATA[def_id]

def determine_incarnation_cross(
    p_sun_gate: int, p_sun_line: int,
    p_earth_gate: int,
    d_sun_gate: int,
    d_earth_gate: int
) -> Dict[str, Any]:
    """
    Tính Thánh Giá Hóa Thân (Incarnation Cross) từ 4 cổng Mặt Trời & Trái Đất.
    Góc phần tư (Right Angle, Left Angle, Juxtaposition) được quy định bởi Hào của Mặt Trời Ý Thức.
    """
    if p_sun_line in [1, 2, 3]:
        angle_type = "Góc Phải (Right Angle Cross)"
        destiny_type = "Số phận cá nhân (Personal Destiny) - Tự mình khám phá hành trình cuộc đời"
    elif p_sun_line == 4:
        angle_type = "Góc Phải / Tiếp giáp (Right Angle / Juxtaposition)"
        destiny_type = "Tiếp giáp hoặc chuyển tiếp - Kết nối cá nhân và cộng đồng"
    else: # 5, 6
        angle_type = "Góc Trái (Left Angle Cross)"
        destiny_type = "Số phận tương hỗ xã hội (Transpersonal Karma) - Hướng dẫn và tác động tới tha nhân"
        
    cross_gates_str = f"{p_sun_gate}/{p_earth_gate} | {d_sun_gate}/{d_earth_gate}"
    sun_gate_info = GATES_DATA.get(str(p_sun_gate), {})
    gate_name = sun_gate_info.get("name_vi", f"Cổng {p_sun_gate}")
    
    return {
        "name": f"Thánh Giá {gate_name} ({angle_type})",
        "angle": angle_type,
        "destiny": destiny_type,
        "gates": {
            "personality_sun": p_sun_gate,
            "personality_earth": p_earth_gate,
            "design_sun": d_sun_gate,
            "design_earth": d_earth_gate,
            "formula": cross_gates_str
        },
        "description": f"Sứ mệnh cuộc đời được dẫn lối bởi năng lượng trung tâm của Cổng {p_sun_gate} ({gate_name}) kết hợp sự vững chãi của Trái Đất và tiềm thức Thiết kế."
    }

def calculate_chart(birth_dt_local: datetime, tz_name: str = "Asia/Ho_Chi_Minh", true_node: bool = True) -> HumanDesignChart:
    """
    Hàm tính toán toàn diện biểu đồ Human Design (BodyGraph) từ ngày giờ sinh địa phương.
    """
    # 1. Tính toán thiên văn học
    astro_data = calculate_planetary_positions(birth_dt_local, tz_name=tz_name, true_node=true_node)
    
    # 2. Ánh xạ kinh độ của 13 hành tinh vào Cổng và Hào (Mandala)
    personality_activations = {}
    for planet, lon in astro_data["personality_longitudes"].items():
        gate_line = ecliptic_to_gate_line(lon)
        gate_info = GATES_DATA.get(str(gate_line["gate"]), {})
        personality_activations[planet] = {
            "planet": planet,
            "longitude": lon,
            "gate": gate_line["gate"],
            "line": gate_line["line"],
            "color": gate_line["color"],
            "tone": gate_line["tone"],
            "base": gate_line["base"],
            "gate_line_str": gate_line["gate_line_str"],
            "center_id": gate_line["center_id"],
            "zodiac": gate_line["zodiac_formatted"],
            "gate_name_vi": gate_info.get("name_vi", ""),
            "gate_keyword": gate_info.get("hexagram_title", "")
        }
        
    design_activations = {}
    for planet, lon in astro_data["design_longitudes"].items():
        gate_line = ecliptic_to_gate_line(lon)
        gate_info = GATES_DATA.get(str(gate_line["gate"]), {})
        design_activations[planet] = {
            "planet": planet,
            "longitude": lon,
            "gate": gate_line["gate"],
            "line": gate_line["line"],
            "color": gate_line["color"],
            "tone": gate_line["tone"],
            "base": gate_line["base"],
            "gate_line_str": gate_line["gate_line_str"],
            "center_id": gate_line["center_id"],
            "zodiac": gate_line["zodiac_formatted"],
            "gate_name_vi": gate_info.get("name_vi", ""),
            "gate_keyword": gate_info.get("hexagram_title", "")
        }

    # 3. Tổng hợp danh sách tất cả các cổng được kích hoạt
    active_gates_map = defaultdict(lambda: {"personality": [], "design": [], "is_active": True})
    
    for planet, act in personality_activations.items():
        g = act["gate"]
        active_gates_map[g]["personality"].append({
            "planet": planet,
            "line": act["line"]
        })
        
    for planet, act in design_activations.items():
        g = act["gate"]
        active_gates_map[g]["design"].append({
            "planet": planet,
            "line": act["line"]
        })

    active_gates_summary = {}
    for g, data in active_gates_map.items():
        g_info = GATES_DATA.get(str(g), {})
        is_p = len(data["personality"]) > 0
        is_d = len(data["design"]) > 0
        if is_p and is_d:
            activation_type = "both"  # Cả ý thức và vô thức
        elif is_p:
            activation_type = "personality"  # Ý thức (đen / vàng)
        else:
            activation_type = "design"  # Vô thức (đỏ / xanh)
            
        active_gates_summary[g] = {
            "gate": g,
            "name_vi": g_info.get("name_vi", f"Cổng {g}"),
            "hexagram_title": g_info.get("hexagram_title", ""),
            "center_id": GATE_TO_CENTER.get(g, ""),
            "activation_type": activation_type,
            "personality_activations": data["personality"],
            "design_activations": data["design"]
        }

    # 4. Xác định 36 Kênh: Kênh nào có cả 2 cổng đều được kích hoạt
    active_channels = []
    defined_centers_set = set()
    
    for ch_id, ch_info in CHANNELS_DATA.items():
        g1, g2 = ch_info["gates"][0], ch_info["gates"][1]
        if g1 in active_gates_summary and g2 in active_gates_summary:
            # Kênh này được kích hoạt hoàn toàn!
            c1, c2 = ch_info["centers"][0], ch_info["centers"][1]
            defined_centers_set.add(c1)
            defined_centers_set.add(c2)
            
            # Phân loại ý thức / vô thức của kênh
            g1_act = active_gates_summary[g1]["activation_type"]
            g2_act = active_gates_summary[g2]["activation_type"]
            if g1_act == "design" and g2_act == "design":
                channel_nature = "unconscious"
            elif g1_act == "personality" and g2_act == "personality":
                channel_nature = "conscious"
            else:
                channel_nature = "mixed"

            ch_dict = dict(ch_info)
            ch_dict["nature"] = channel_nature
            active_channels.append(ch_dict)

    # 5. Phân loại 9 Trung tâm (Defined vs Undefined)
    all_centers = list(CENTERS_DATA.keys())
    defined_centers_list = [c for c in all_centers if c in defined_centers_set]
    undefined_centers_list = [c for c in all_centers if c not in defined_centers_set]

    centers_summary = {}
    for c_id, c_info in CENTERS_DATA.items():
        is_def = c_id in defined_centers_set
        centers_summary[c_id] = {
            "id": c_id,
            "name_vi": c_info["name_vi"],
            "is_defined": is_def,
            "status": "Xác định (Đậm)" if is_def else "Mở / Chưa xác định (Trắng)",
            "defined_desc": c_info["defined_desc"],
            "undefined_desc": c_info["undefined_desc"],
            "key_question": c_info["key_question"],
            "active_gates_in_center": [g for g in c_info["gates"] if g in active_gates_summary]
        }

    # 6. Xác định Nhóm Năng Lượng (Type) và Chiến Lược (Strategy)
    type_info = determine_type_and_strategy(defined_centers_set, active_channels)

    # 7. Xác định Thẩm Quyền Ra Quyết Định (Authority)
    authority_info = determine_authority(defined_centers_set, active_channels)

    # 8. Xác định Hồ Sơ Cá Nhân (Profile)
    p_sun_line = personality_activations["Sun"]["line"]
    d_sun_line = design_activations["Sun"]["line"]
    profile_key = f"{p_sun_line}/{d_sun_line}"
    p_data = PROFILES_DICT.get(profile_key, {})
    profile_info = {
        "key": profile_key,
        "profile": profile_key,
        "name_vi": p_data.get("name", f"Hồ Sơ {profile_key}"),
        "conscious_line": p_sun_line,
        "unconscious_line": d_sun_line,
        "conscious_line_info": LINES_DICT.get(str(p_sun_line), {}),
        "unconscious_line_info": LINES_DICT.get(str(d_sun_line), {}),
        "geometry": p_data.get("geometry", ""),
        "summary": p_data.get("summary", ""),
        "career": p_data.get("career", ""),
        "relationship": p_data.get("relationship", "")
    }

    # 9. Xác định Định Nghĩa (Definition)
    definition_info = determine_definition(defined_centers_set, active_channels)

    # 10. Xác định Thánh Giá Hóa Thân (Incarnation Cross)
    p_sun_gate = personality_activations["Sun"]["gate"]
    p_earth_gate = personality_activations["Earth"]["gate"]
    d_sun_gate = design_activations["Sun"]["gate"]
    d_earth_gate = design_activations["Earth"]["gate"]
    incarnation_cross = determine_incarnation_cross(p_sun_gate, p_sun_line, p_earth_gate, d_sun_gate, d_earth_gate)

    chart_dict = {
        "birth_info": {
            "birth_local_str": astro_data["birth_local"].strftime("%Y-%m-%d %H:%M:%S %Z"),
            "personality_utc_str": astro_data["personality_utc"].strftime("%Y-%m-%d %H:%M:%S UTC"),
            "design_utc_str": astro_data["design_utc"].strftime("%Y-%m-%d %H:%M:%S UTC"),
            "timezone": tz_name
        },
        "type": type_info,
        "authority": authority_info,
        "profile": profile_info,
        "definition": definition_info,
        "incarnation_cross": incarnation_cross,
        "defined_centers": defined_centers_list,
        "undefined_centers": undefined_centers_list,
        "centers": centers_summary,
        "active_channels": active_channels,
        "active_gates": active_gates_summary,
        "activations": {
            "personality": personality_activations,
            "design": design_activations
        }
    }

    return HumanDesignChart(chart_dict)
