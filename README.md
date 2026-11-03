# HỆ THỐNG TRA CỨU & LUẬN GIẢI HUMAN DESIGN (TINH HOA BẢN MỆNH)

Hệ thống tra cứu, tính toán thiên văn chính xác cao và luận giải Human Design (Nhân Khí Học) độc quyền theo nội dung cuốn sách:
**"Human Design Cho Người Mới Bắt Đầu"** - Tác giả & Biên soạn: **TH Group - Tinh Hoa Bản Mệnh • Ngô Xuân Hội**.

---

## 🏛️ CẤU TRÚC DỰ ÁN TỔNG THỂ

```
C:\HumanDesign\
├── core/                         # BỘ LÕI TÍNH TOÁN & CƠ SỞ TRI THỨC (PYTHON)
│   ├── assets/
│   │   └── de421.bsp             # NASA JPL Planetary Ephemeris chính xác cao
│   ├── data/                     # Cơ sở tri thức trích xuất từ sách (JSON)
│   │   ├── types.json            # 5 Nhóm năng lượng (Khởi Xướng, Vận Hành, Khởi Xướng Vận Hành, Khai Vấn, Phản Chiếu)
│   │   ├── authorities.json      # 7 Quyền năng bên trong (Thái Dương, Đan Điền, Sinh Giác, Bản Ngã, Danh Tính...)
│   │   ├── definitions.json      # 5 Định nghĩa liên kết (Đơn, Đôi, Ba, Bốn, Không liên kết)
│   │   ├── centers.json          # 9 Trung tâm (Trí Huệ, Tuệ Nhãn, Tuệ Ngôn, Thượng Ngã, Tâm Ngã...)
│   │   ├── profiles.json         # 12 Hồ sơ cá nhân (1/3, 1/4, 2/4, 2/5, 3/5, 3/6, 4/6...) & 6 Hào
│   │   ├── channels.json         # 36 Kênh năng lượng (Nhóm, Dòng mạch, Lời khuyên)
│   │   └── gates.json            # 64 Cổng Mandala (Tần số cao, Tần số thấp, Tiếng nói nội tâm)
│   ├── engine/                   # Module thuật toán
│   │   ├── astronomy.py          # Tính tọa độ 13 thiên thể & Điểm Thiết Kế (-88.0° Solar Arc)
│   │   ├── mandala.py            # Bánh xe Mandala 64 cổng (Aquarius 02°00'00"), Hào, Sắc thái
│   │   ├── hd_calculator.py      # Xây dựng BodyGraph, Đồ thị Motor-Throat, Định nghĩa, Thánh Giá
│   │   ├── interpreter.py        # Biên dịch 8 chương báo cáo luận giải chuẩn văn phong sách
│   │   └── composite.py          # Phân tích hợp đôi: Nam châm (Electromagnetic), Đồng điệu, Áp đảo, Thỏa hiệp
│   ├── api/                      # REST API Server (FastAPI)
│   │   └── main.py               # Endpoints tính lá số, so hợp đôi, transit hôm nay, tra cứu
│   └── tests/
│       └── test_engine.py        # Bộ kiểm thử tự động Unit Tests (100% Passed)
│
├── mobile/                       # ỨNG DỤNG DI ĐỘNG (FLUTTER ANDROID / IOS)
│   ├── lib/
│   │   ├── main.dart             # Điều hướng 5 tab giao diện chuẩn Tử Vi - Thần Số Học
│   │   ├── theme/app_theme.dart  # Theme Midnight Cosmic Dark & Metallic Gold sang trọng
│   │   ├── models/chart_data.dart# Model dữ liệu lá số
│   │   ├── services/api_service.dart # Kết nối API & chế độ ngoại tuyến Fallback
│   │   ├── widgets/
│   │   │   ├── bodygraph_view.dart      # CustomPainter Canvas 9 trung tâm & 36 kênh tương tác
│   │   │   └── center_detail_sheet.dart # Modal BottomSheet tra cứu chi tiết trung tâm & câu hỏi gỡ điều kiện hóa
│   │   └── screens/
│   │       ├── home_screen.dart         # Tab 1: Vận Trình Hôm Nay & Thời tiết vũ trụ
│   │       ├── bodygraph_screen.dart    # Tab 2: Biểu đồ BodyGraph & Kích hoạt 13 hành tinh
│   │       ├── vip_reading_screen.dart  # Tab 3: Luận Giải VIP 6 Chương Chuyên Sâu & Mở khóa
│   │       ├── composite_screen.dart    # Tab 4: So Hợp Đôi & Đo chỉ số hòa hợp
│   │       └── profiles_screen.dart     # Tab 5: Quản lý hồ sơ đã lưu & Bách khoa thư
│
└── web/                          # WEB PORTAL (LANDING PAGE, TRA CỨU & THANH TOÁN VIETQR)
    ├── index.html                # Giao diện web tra cứu lá số & cổng thanh toán VIP
    ├── styles.css                # CSS Cosmic Dark Mode cao cấp
    └── app.js                    # Tương tác SVG Bodygraph và kết nối API
```

---

## 🚀 HƯỚNG DẪN KHỞI CHẠY HỆ THỐNG

### 1. Khởi động Backend Core API & Web Portal
Mở PowerShell hoặc Command Prompt:
```powershell
cd C:\HumanDesign
.\start_server.bat
```
Hoặc:
```powershell
cd C:\HumanDesign\core\api
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
- **API Docs (Swagger)**: `http://localhost:8000/docs`
- **Web Portal**: `http://localhost:8000/portal`

### 2. Khởi động Ứng Dụng Di Động Flutter (Android / iOS / Desktop)
Mở cửa sổ dòng lệnh thứ hai:
```powershell
cd C:\HumanDesign\mobile
flutter run
```
- Hỗ trợ chạy trên Android Emulator, thiết bị Android thật qua USB, Chrome Web hoặc Windows App.

---

## 💎 CÁC TÍNH NĂNG THƯƠNG MẠI (MONETIZATION)

1. **Gói Mở Khóa Luận Giải VIP (199.000 VNĐ / Trọn đời)**:
   - Tích hợp cổng thanh toán VietQR / Chuyển khoản ngân hàng tự động.
   - Luận giải toàn diện 6 chương chuyên sâu từ sứ mệnh, chiến lược, thẩm quyền, hồ sơ đến giải phóng điều kiện hóa.
2. **So Năng Lượng Hợp Đôi**:
   - Phân tích tương thích tình cảm, hôn nhân, đối tác kinh doanh dựa trên 4 loại kênh (Bù trừ, Đồng điệu, Dẫn dắt, Thỏa hiệp) và tỷ lệ 9 trung tâm (9-0, 8-1, 7-2, 6-3, 5-4).
3. **Thời Tiết Năng Lượng Hằng Ngày (Daily Transit)**:
   - Theo dõi sự di chuyển của Mặt Trời qua 64 cổng, nhắc nhở tần số cao và câu hỏi chiêm nghiệm trong ngày.
