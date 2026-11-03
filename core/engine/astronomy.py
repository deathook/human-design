"""
astronomy.py - Module tính toán vị trí thiên văn chính xác cao cho Human Design
Sử dụng NASA JPL DE421 Ephemeris qua thư viện Skyfield.
"""

import os
import math
from datetime import datetime, timezone
import pytz
from skyfield.api import Loader
from skyfield.framelib import ecliptic_frame

# Đường dẫn thư mục assets chứa file de421.bsp
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(BASE_DIR, "assets")

load = Loader(ASSETS_DIR)
ts = load.timescale()
planets = load('de421.bsp')
earth = planets['earth']

# Bản đồ các hành tinh chính trong DE421
CELESTIAL_TARGETS = {
    'Sun': planets['sun'],
    'Moon': planets['moon'],
    'Mercury': planets['mercury'],
    'Venus': planets['venus'],
    'Mars': planets['mars barycenter'],
    'Jupiter': planets['jupiter barycenter'],
    'Saturn': planets['saturn barycenter'],
    'Uranus': planets['uranus barycenter'],
    'Neptune': planets['neptune barycenter'],
    'Pluto': planets['pluto barycenter'],
}

def calculate_lunar_nodes(jd: float, true_node: bool = True) -> float:
    """
    Tính kinh độ hoàng đạo của Nút Mặt Trăng (La Hầu / North Node).
    Sử dụng thuật toán thiên văn độ chính xác cao của Jean Meeus (Astronomical Algorithms).
    """
    T = (jd - 2451545.0) / 36525.0
    # Kinh độ trung bình của điểm nút tăng (Mean Ascending Node)
    omega = 125.0445479 - 1934.1362891 * T + 0.0020754 * (T ** 2) + (T ** 3) / 467441.0 - (T ** 4) / 60616000.0
    omega = omega % 360.0
    
    if not true_node:
        return omega
    
    # Hiệu chỉnh cho True Node (Nút thực):
    D = 297.8501921 + 445267.1114034 * T - 0.0018819 * (T ** 2) + (T ** 3) / 545868.0 - (T ** 4) / 113065000.0
    M = 357.5291092 + 35999.0502909 * T - 0.0001536 * (T ** 2) + (T ** 3) / 24490000.0
    M_prime = 134.9633964 + 477198.8675055 * T + 0.0087414 * (T ** 2) + (T ** 3) / 69699.0 - (T ** 4) / 14712000.0
    F = 93.2720950 + 483202.0175233 * T - 0.0036539 * (T ** 2) - (T ** 3) / 3526000.0 + (T ** 4) / 863310000.0

    def d2r(d):
        return math.radians(d)

    corr = (
        - 1.4979 * math.sin(d2r(2 * (D - F)))
        - 0.1500 * math.sin(d2r(M))
        - 0.1226 * math.sin(d2r(2 * D))
        + 0.1176 * math.sin(d2r(2 * F))
        - 0.0801 * math.sin(d2r(2 * (D - M_prime)))
    )
    return (omega + corr) % 360.0

def get_body_ecliptic_longitude(t, target_body) -> float:
    """Tính kinh độ hoàng đạo địa tâm biểu kiến (Geocentric Apparent Ecliptic Longitude)"""
    _, lon, _ = earth.at(t).observe(target_body).apparent().frame_latlon(ecliptic_frame)
    return lon.degrees % 360.0

def get_all_activations_longitudes(t, true_node: bool = True) -> dict:
    """
    Tính kinh độ hoàng đạo cho 13 thiên thể trong Human Design tại thời điểm t:
    Mặt Trời, Trái Đất, Mặt Trăng, Nút Bắc, Nút Nam, Thủy, Kim, Hỏa, Mộc, Thổ, Thiên Vương, Hải Vương, Diêm Vương.
    """
    longitudes = {}
    
    # 1. Mặt Trời (Sun)
    sun_lon = get_body_ecliptic_longitude(t, CELESTIAL_TARGETS['Sun'])
    longitudes['Sun'] = sun_lon
    
    # 2. Trái Đất (Earth) - Luôn đối diện Mặt Trời chính xác 180 độ
    longitudes['Earth'] = (sun_lon + 180.0) % 360.0
    
    # 3. Nút Bắc Mặt Trăng (North Node / La Hầu)
    north_node = calculate_lunar_nodes(t.tt, true_node=true_node)
    longitudes['North_Node'] = north_node
    
    # 4. Nút Nam Mặt Trăng (South Node / Kế Đô) - Luôn đối diện Nút Bắc 180 độ
    longitudes['South_Node'] = (north_node + 180.0) % 360.0
    
    # 5. Các hành tinh khác
    for body in ['Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto']:
        longitudes[body] = get_body_ecliptic_longitude(t, CELESTIAL_TARGETS[body])
        
    return longitudes

def find_design_time(birth_time_utc: datetime) -> datetime:
    """
    Tìm thời điểm Thiết Kế (Design / Vô thức) trước ngày sinh:
    Thời điểm mà kinh độ Mặt Trời đúng bằng (Kinh độ Mặt Trời khi sinh - 88.0 độ).
    Độ chính xác: Sai số dưới 0.00001 độ (~1/3 giây thời gian).
    """
    t_birth = ts.from_datetime(birth_time_utc)
    sun_birth_lon = get_body_ecliptic_longitude(t_birth, CELESTIAL_TARGETS['Sun'])
    target_sun_lon = (sun_birth_lon - 88.0) % 360.0
    
    # Khoảng tìm kiếm: Mặt Trời di chuyển ~0.9856 độ/ngày, khoảng 88 độ tương đương 86-92 ngày trước sinh
    jd_birth = t_birth.tt
    jd_low = jd_birth - 93.0
    jd_high = jd_birth - 85.0
    
    def angular_diff(jd: float) -> float:
        t_curr = ts.tt_jd(jd)
        s_lon = get_body_ecliptic_longitude(t_curr, CELESTIAL_TARGETS['Sun'])
        # Khoảng cách góc có dấu [-180, 180]
        return (s_lon - target_sun_lon + 180.0) % 360.0 - 180.0

    # Thuật toán tìm nghiệm lưỡng phân (Binary Search) kết hợp Secant
    for _ in range(40):
        jd_mid = (jd_low + jd_high) / 2.0
        diff = angular_diff(jd_mid)
        if abs(diff) < 1e-7:
            break
        if diff < 0:
            jd_low = jd_mid
        else:
            jd_high = jd_mid
            
    t_design = ts.tt_jd(jd_mid)
    return t_design.utc_datetime()

def calculate_planetary_positions(birth_dt_local: datetime, tz_name: str = "Asia/Ho_Chi_Minh", true_node: bool = True):
    """
    Hàm chính tính toán toàn bộ vị trí thiên văn cho cả Tính Cách (Personality) và Thiết Kế (Design).
    
    Args:
        birth_dt_local: datetime sinh (naive hoặc có tzinfo)
        tz_name: Tên múi giờ (mặc định 'Asia/Ho_Chi_Minh' cho Việt Nam)
        true_node: True nếu dùng Nút Thực, False nếu dùng Nút Trung Bình
        
    Returns:
        dict gồm:
            - personality_time_utc: datetime
            - design_time_utc: datetime
            - personality_longitudes: dict 13 thiên thể
            - design_longitudes: dict 13 thiên thể
    """
    # Xử lý múi giờ địa phương sang UTC
    local_tz = pytz.timezone(tz_name)
    if birth_dt_local.tzinfo is None:
        birth_dt_aware = local_tz.localize(birth_dt_local)
    else:
        birth_dt_aware = birth_dt_local.astimezone(local_tz)
        
    birth_utc = birth_dt_aware.astimezone(pytz.UTC)
    design_utc = find_design_time(birth_utc)
    
    t_personality = ts.from_datetime(birth_utc)
    t_design = ts.from_datetime(design_utc)
    
    personality_longitudes = get_all_activations_longitudes(t_personality, true_node=true_node)
    design_longitudes = get_all_activations_longitudes(t_design, true_node=true_node)
    
    return {
        "birth_local": birth_dt_aware,
        "personality_utc": birth_utc,
        "design_utc": design_utc,
        "personality_longitudes": personality_longitudes,
        "design_longitudes": design_longitudes
    }
