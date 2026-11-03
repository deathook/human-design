"""
test_engine.py - Bộ kiểm thử tự động toàn diện (Unit Tests) cho Core Engine Human Design
Kiểm tra độ chính xác thiên văn học, đồ thị Mandala, quy tắc phân loại nhóm năng lượng, 
thẩm quyền, định nghĩa liên kết và tương thích quan hệ.
"""

import sys
import os
import unittest
from datetime import datetime

# Đảm bảo đường dẫn import tới module engine
ENGINE_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "engine")
if ENGINE_DIR not in sys.path:
    sys.path.append(ENGINE_DIR)

from astronomy import calculate_planetary_positions, find_design_time
from mandala import ecliptic_to_gate_line, MANDALA_GATES
from hd_calculator import (
    calculate_chart,
    determine_type_and_strategy,
    determine_authority,
    determine_definition
)
from interpreter import generate_full_reading
from composite import calculate_composite

class TestHumanDesignCoreEngine(unittest.TestCase):

    def test_astronomy_solar_arc(self):
        """Kiểm tra góc cung Mặt Trời Thiết Kế luôn cách Mặt Trời Sinh chính xác 88.0 độ"""
        dt = datetime(1995, 8, 20, 14, 15)
        res = calculate_planetary_positions(dt, "Asia/Ho_Chi_Minh")
        p_sun = res["personality_longitudes"]["Sun"]
        d_sun = res["design_longitudes"]["Sun"]
        arc_diff = (p_sun - d_sun) % 360.0
        self.assertAlmostEqual(arc_diff, 88.0, delta=0.0001)

    def test_earth_and_nodes_opposition(self):
        """Kiểm tra Trái Đất luôn đối diện Mặt Trời 180° và Nút Nam đối diện Nút Bắc 180°"""
        dt = datetime(2002, 1, 10, 6, 0)
        res = calculate_planetary_positions(dt, "Asia/Ho_Chi_Minh")
        
        # Sun vs Earth
        p_sun = res["personality_longitudes"]["Sun"]
        p_earth = res["personality_longitudes"]["Earth"]
        self.assertAlmostEqual((p_earth - p_sun) % 360.0, 180.0, delta=0.0001)
        
        # North Node vs South Node
        n_node = res["personality_longitudes"]["North_Node"]
        s_node = res["personality_longitudes"]["South_Node"]
        self.assertAlmostEqual((s_node - n_node) % 360.0, 180.0, delta=0.0001)

    def test_mandala_coordinate_mapping(self):
        """Kiểm tra tọa độ Mandala bánh xe 64 cổng"""
        # Cổng 41 Hào 1 bắt đầu tại đúng 302.0°
        res_41 = ecliptic_to_gate_line(302.001)
        self.assertEqual(res_41["gate"], 41)
        self.assertEqual(res_41["line"], 1)

        # Cổng 41 kết thúc tại 302.0 + 5.625 = 307.625°
        # Cổng tiếp theo là Cổng 19 (MANDALA_GATES[1] = 19)
        res_19 = ecliptic_to_gate_line(307.630)
        self.assertEqual(res_19["gate"], 19)
        self.assertEqual(res_19["line"], 1)

    def test_type_determination_rules(self):
        """Kiểm tra quy tắc xác định 5 Nhóm Năng Lượng theo sách"""
        # 1. Reflector: 0 trung tâm xác định
        reflector_type = determine_type_and_strategy(set(), [])
        self.assertEqual(reflector_type["id"], "Reflector")

        # 2. Generator: Đan Điền xác định, không có động cơ lên Tuệ Ngôn
        # Ví dụ Kênh 5-15 (Sacral <-> G-Center)
        ch_5_15 = {"centers": ["Sacral", "G_Center"]}
        gen_type = determine_type_and_strategy({"Sacral", "G_Center"}, [ch_5_15])
        self.assertEqual(gen_type["id"], "Generator")

        # 3. Manifesting Generator: Đan Điền xác định VÀ có kênh động cơ lên Tuệ Ngôn
        # Ví dụ Kênh 20-34 (Throat <-> Sacral)
        ch_20_34 = {"centers": ["Throat", "Sacral"]}
        mg_type = determine_type_and_strategy({"Throat", "Sacral"}, [ch_20_34])
        self.assertEqual(mg_type["id"], "Manifesting_Generator")

        # 4. Manifestor: Đan Điền KHÔNG xác định, nhưng có động cơ nối lên Tuệ Ngôn
        # Ví dụ Kênh 21-45 (Heart <-> Throat)
        ch_21_45 = {"centers": ["Heart", "Throat"]}
        manifestor_type = determine_type_and_strategy({"Heart", "Throat"}, [ch_21_45])
        self.assertEqual(manifestor_type["id"], "Manifestor")

        # 5. Projector: Đan Điền KHÔNG xác định, không có động cơ lên Tuệ Ngôn, có trung tâm khác
        # Ví dụ Kênh 43-23 (Ajna <-> Throat)
        ch_43_23 = {"centers": ["Ajna", "Throat"]}
        proj_type = determine_type_and_strategy({"Ajna", "Throat"}, [ch_43_23])
        self.assertEqual(proj_type["id"], "Projector")

    def test_authority_hierarchy(self):
        """Kiểm tra thứ bậc ưu tiên 1 - 7 của Quyền Năng Ra Quyết Định"""
        # Ưu tiên 1: Có Thái Dương -> Luôn là Emotional bất kể các trung tâm khác
        auth_1 = determine_authority({"Solar_Plexus", "Sacral", "Spleen"}, [])
        self.assertEqual(auth_1["id"], "Emotional")

        # Ưu tiên 2: Không có Thái Dương, có Đan Điền -> Sacral
        auth_2 = determine_authority({"Sacral", "Spleen", "Heart"}, [])
        self.assertEqual(auth_2["id"], "Sacral")

        # Ưu tiên 3: Không có Thái Dương & Đan Điền, có Sinh Giác (Lách) -> Splenic
        auth_3 = determine_authority({"Spleen", "Heart", "G_Center"}, [])
        self.assertEqual(auth_3["id"], "Splenic")

        # Ưu tiên 4: Không có 3 trung tâm trên, có Tâm Ngã (Tim) -> Ego
        auth_4 = determine_authority({"Heart", "G_Center", "Throat"}, [])
        self.assertEqual(auth_4["id"], "Ego")

        # Ưu tiên 5: Chỉ có Thượng Ngã và Họng/Trí Huệ -> Self_Projected
        auth_5 = determine_authority({"G_Center", "Throat"}, [])
        self.assertEqual(auth_5["id"], "Self_Projected")

        # Ưu tiên 6: Chỉ có Đầu/Trán/Họng -> Environmental (Mental)
        auth_6 = determine_authority({"Head", "Ajna", "Throat"}, [])
        self.assertEqual(auth_6["id"], "Environmental")

        # Ưu tiên 7: 0 trung tâm xác định -> Lunar (Reflector)
        auth_7 = determine_authority(set(), [])
        self.assertEqual(auth_7["id"], "Lunar")

    def test_definition_components(self):
        """Kiểm tra phân loại Định nghĩa liên kết (Đơn, Đôi, Ba, Bốn)"""
        # 1 component liên thông -> Single
        ch_single = [{"centers": ["Throat", "Ajna"]}, {"centers": ["Ajna", "Head"]}]
        def_single = determine_definition({"Head", "Ajna", "Throat"}, ch_single)
        self.assertEqual(def_single["id"], "Single")

        # 2 components rời nhau -> Split
        ch_split = [{"centers": ["Throat", "Ajna"]}, {"centers": ["Root", "Sacral"]}]
        def_split = determine_definition({"Ajna", "Throat", "Root", "Sacral"}, ch_split)
        self.assertEqual(def_split["id"], "Split")

    def test_full_reading_synthesis(self):
        """Kiểm tra module Interpreter sinh báo cáo luận giải hoàn chỉnh chuẩn Tiếng Việt"""
        chart = calculate_chart(datetime(1993, 11, 10, 10, 30), "Asia/Ho_Chi_Minh")
        reading = generate_full_reading(chart)
        
        self.assertIn("overview", reading)
        self.assertIn("type_reading", reading)
        self.assertIn("authority_reading", reading)
        self.assertIn("profile_reading", reading)
        self.assertIn("centers_reading", reading)
        self.assertIn("channels_reading", reading)
        self.assertIn("gates_reading", reading)
        self.assertIn("cross_reading", reading)
        
        # Kiểm tra nội dung text luận giải không bị rỗng
        self.assertTrue(len(reading["type_reading"]["synthesis"]) > 50)
        self.assertTrue(len(reading["authority_reading"]["synthesis"]) > 30)

    def test_composite_compatibility(self):
        """Kiểm tra module Composite tính toán hợp đôi giữa 2 người"""
        chart_a = calculate_chart(datetime(1990, 5, 15, 8, 30), "Asia/Ho_Chi_Minh")
        chart_b = calculate_chart(datetime(1992, 10, 20, 15, 0), "Asia/Ho_Chi_Minh")
        
        comp = calculate_composite(chart_a, chart_b, "An", "Bình")
        self.assertIn("compatibility_score", comp)
        self.assertIn("center_dynamic", comp)
        self.assertIn("channels", comp)
        self.assertTrue(40 <= comp["compatibility_score"] <= 100)

if __name__ == "__main__":
    unittest.main()
