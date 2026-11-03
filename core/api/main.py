"""
main.py - FastAPI Server cung cấp REST API cho toàn bộ hệ thống Human Design
Phục vụ ứng dụng Mobile (Flutter Android/iOS) và Website Portal.
"""

import sys
import os
from datetime import datetime
from typing import Optional, Dict, Any, List
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field

# Thêm đường dẫn engine vào sys.path
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENGINE_DIR = os.path.join(BASE_DIR, "engine")
DATA_DIR = os.path.join(BASE_DIR, "data")
WEB_DIR = os.path.join(os.path.dirname(BASE_DIR), "web")
if ENGINE_DIR not in sys.path:
    sys.path.append(ENGINE_DIR)

from hd_calculator import (
    calculate_chart,
    TYPES_DATA,
    AUTHORITIES_DATA,
    DEFINITIONS_DATA,
    CENTERS_DATA,
    PROFILES_DATA,
    CHANNELS_DATA,
    GATES_DATA
)
from interpreter import generate_full_reading
from composite import calculate_composite
from astronomy import calculate_planetary_positions
from mandala import ecliptic_to_gate_line

app = FastAPI(
    title="Human Design Core API",
    description="Hệ thống lõi tính toán và luận giải Human Design chuẩn sách 'Human Design Cho Người Mới Bắt Đầu' - TH Group",
    version="1.0.0"
)

# Cấu hình CORS để ứng dụng Flutter và Web truy cập thuận tiện
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request Models
class BirthInfoRequest(BaseModel):
    name: str = Field(..., description="Họ và tên", example="Nguyễn Văn A")
    birth_date: str = Field(..., description="Ngày sinh định dạng YYYY-MM-DD", example="1995-10-25")
    birth_time: str = Field("12:00", description="Giờ sinh định dạng HH:MM", example="14:30")
    timezone: str = Field("Asia/Ho_Chi_Minh", description="Múi giờ địa phương", example="Asia/Ho_Chi_Minh")
    gender: Optional[str] = Field("Khác", description="Giới tính (Nam, Nữ, Khác)", example="Nam")
    is_vip: Optional[bool] = Field(False, description="Cờ mở khóa luận giải VIP chuyên sâu")

class CompositeRequest(BaseModel):
    person_a: BirthInfoRequest
    person_b: BirthInfoRequest

@app.get("/")
def read_root():
    return {
        "status": "online",
        "service": "Human Design Core API",
        "author": "TH Group - Tinh Hoa Bản Mệnh",
        "version": "1.0.0",
        "docs_url": "/docs",
        "web_portal": "/portal"
    }

if os.path.exists(WEB_DIR):
    app.mount("/static-web", StaticFiles(directory=WEB_DIR), name="static-web")

    @app.get("/portal")
    def serve_portal():
        return FileResponse(os.path.join(WEB_DIR, "index.html"))

@app.post("/api/chart/calculate")
def calculate_user_chart(req: BirthInfoRequest):
    """
    Tính toán lá số Human Design đầy đủ và sinh báo cáo luận giải chi tiết
    """
    try:
        dt_str = f"{req.birth_date} {req.birth_time}"
        birth_dt = datetime.strptime(dt_str, "%Y-%m-%d %H:%M")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Định dạng ngày giờ không hợp lệ (cần YYYY-MM-DD và HH:MM): {str(e)}")

    try:
        chart = calculate_chart(birth_dt, tz_name=req.timezone)
        reading = generate_full_reading(chart)
        
        # Thêm thông tin người dùng
        response = {
            "user": {
                "name": req.name,
                "birth_date": req.birth_date,
                "birth_time": req.birth_time,
                "timezone": req.timezone,
                "gender": req.gender,
                "is_vip": req.is_vip
            },
            **reading
        }
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi tính toán lá số: {str(e)}")

@app.post("/api/chart/composite")
def calculate_relationship_compatibility(req: CompositeRequest):
    """
    So sánh hai lá số và phân tích tương thích quan hệ (Hợp đôi)
    """
    try:
        dt_a = datetime.strptime(f"{req.person_a.birth_date} {req.person_a.birth_time}", "%Y-%m-%d %H:%M")
        dt_b = datetime.strptime(f"{req.person_b.birth_date} {req.person_b.birth_time}", "%Y-%m-%d %H:%M")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Định dạng ngày giờ không hợp lệ: {str(e)}")

    try:
        chart_a = calculate_chart(dt_a, tz_name=req.person_a.timezone)
        chart_b = calculate_chart(dt_b, tz_name=req.person_b.timezone)
        composite_result = calculate_composite(chart_a, chart_b, req.person_a.name, req.person_b.name)
        return composite_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi tính toán biểu đồ hợp đôi: {str(e)}")

@app.get("/api/transit/today")
def get_daily_transit(tz: str = "Asia/Ho_Chi_Minh"):
    """
    Tính toán thời tiết năng lượng hiện tại (Daily Transit) trên vòng tròn Mandala
    """
    try:
        now_dt = datetime.now()
        astro_now = calculate_planetary_positions(now_dt, tz_name=tz)
        
        transit_activations = []
        for planet, lon in astro_now["personality_longitudes"].items():
            g_line = ecliptic_to_gate_line(lon)
            g_info = GATES_DATA.get(str(g_line["gate"]), {})
            transit_activations.append({
                "planet": planet,
                "gate": g_line["gate"],
                "line": g_line["line"],
                "gate_name_vi": g_info.get("name_vi", f"Cổng {g_line['gate']}"),
                "zodiac": g_line["zodiac_formatted"],
                "high_frequency": g_info.get("high_frequency", ""),
                "low_frequency": g_info.get("low_frequency", "")
            })

        sun_act = next(a for a in transit_activations if a["planet"] == "Sun")
        
        return {
            "date": now_dt.strftime("%Y-%m-%d %H:%M"),
            "sun_transit": {
                "gate": sun_act["gate"],
                "line": sun_act["line"],
                "name_vi": sun_act["gate_name_vi"],
                "high_frequency": sun_act["high_frequency"],
                "low_frequency": sun_act["low_frequency"],
                "message": f"Mặt Trời hôm nay quá cảnh tại Cổng {sun_act['gate']}.{sun_act['line']} ({sun_act['gate_name_vi']}). Năng lượng hướng về tần số: {sun_act['high_frequency']}."
            },
            "all_transits": transit_activations
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi tính toán thời tiết năng lượng hôm nay: {str(e)}")

@app.get("/api/reference/{category}")
def get_reference_data(category: str):
    """
    Tra cứu kho kiến thức Human Design theo chuyên mục:
    - types: 5 Nhóm Năng Lượng
    - authorities: 7 Quyền Năng
    - definitions: 5 Định Nghĩa
    - centers: 9 Trung Tâm
    - profiles: 12 Hồ Sơ Cá Nhân & 6 Hào
    - channels: 36 Kênh Năng Lượng
    - gates: 64 Cổng
    """
    cat_lower = category.lower()
    if cat_lower == "types":
        return TYPES_DATA
    elif cat_lower == "authorities":
        return AUTHORITIES_DATA
    elif cat_lower == "definitions":
        return DEFINITIONS_DATA
    elif cat_lower == "centers":
        return CENTERS_DATA
    elif cat_lower == "profiles":
        return PROFILES_DATA
    elif cat_lower == "channels":
        return CHANNELS_DATA
    elif cat_lower == "gates":
        return GATES_DATA
    else:
        raise HTTPException(status_code=404, detail=f"Không tìm thấy chuyên mục '{category}'. Các mục hợp lệ: types, authorities, definitions, centers, profiles, channels, gates")
