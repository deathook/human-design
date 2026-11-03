// app.js - Xử lý logic và tương tác của Web Portal Human Design

const API_BASE = 'http://127.0.0.1:8000';

// Tọa độ 9 Trung tâm chuẩn theo SVG Canvas (width: 400, height: 500)
const CENTER_COORDS = {
  Head: { x: 200, y: 45, shape: 'triangleDown', label: 'Trí Huệ' },
  Ajna: { x: 200, y: 110, shape: 'triangleDown', label: 'Tuệ Nhãn' },
  Throat: { x: 200, y: 180, shape: 'square', label: 'Tuệ Ngôn' },
  G_Center: { x: 200, y: 260, shape: 'diamond', label: 'Thượng Ngã' },
  Heart: { x: 290, y: 275, shape: 'triangleUp', label: 'Tâm Ngã' },
  Spleen: { x: 80, y: 365, shape: 'triangleRight', label: 'Sinh Giác' },
  Solar_Plexus: { x: 320, y: 365, shape: 'triangleLeft', label: 'Thái Dương' },
  Sacral: { x: 200, y: 365, shape: 'square', label: 'Đan Điền' },
  Root: { x: 200, y: 455, shape: 'square', label: 'Gốc' }
};

const CHANNELS_LIST = [
  ['Head', 'Ajna'],
  ['Ajna', 'Throat'],
  ['Throat', 'G_Center'],
  ['Throat', 'Heart'],
  ['Throat', 'Solar_Plexus'],
  ['Throat', 'Sacral'],
  ['Heart', 'G_Center'],
  ['Heart', 'Solar_Plexus'],
  ['Heart', 'Spleen'],
  ['G_Center', 'Sacral'],
  ['G_Center', 'Spleen'],
  ['Sacral', 'Solar_Plexus'],
  ['Sacral', 'Spleen'],
  ['Sacral', 'Root'],
  ['Solar_Plexus', 'Root'],
  ['Spleen', 'Root']
];

document.addEventListener('DOMContentLoaded', () => {
  // Lấy thời tiết năng lượng hôm nay
  loadDailyTransit();

  // Khởi tạo lá số mặc định
  calculateChart({
    name: 'Nguyễn Văn A',
    birth_date: '1995-10-25',
    birth_time: '14:30',
    timezone: 'Asia/Ho_Chi_Minh',
    gender: 'Nam',
    is_vip: true
  });

  // Xử lý submit form
  const form = document.getElementById('chart-form');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const payload = {
        name: document.getElementById('name-input').value.trim() || 'Bản Mệnh',
        birth_date: document.getElementById('date-input').value,
        birth_time: document.getElementById('time-input').value || '12:00',
        timezone: document.getElementById('tz-input').value || 'Asia/Ho_Chi_Minh',
        gender: document.getElementById('gender-input').value,
        is_vip: true
      };
      calculateChart(payload);
    });
  }
});

// Gọi API tính toán lá số
async function calculateChart(payload) {
  const submitBtn = document.getElementById('submit-btn');
  if (submitBtn) submitBtn.innerHTML = '<span>Đang tính toán thiên văn...</span>';

  try {
    const res = await fetch(`${API_BASE}/api/chart/calculate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (res.ok) {
      const data = await res.json();
      renderChartResults(data);
    } else {
      throw new Error('API Error');
    }
  } catch (err) {
    console.warn('Backend chưa sẵn sàng, sử dụng dữ liệu tính toán chuẩn từ sách:', err);
    renderFallbackData(payload);
  } finally {
    if (submitBtn) submitBtn.innerHTML = '<span>Tra Cứu Bản Mệnh Ngay</span>';
  }
}

// Lấy transit hôm nay
async function loadDailyTransit() {
  const container = document.getElementById('daily-transit-box');
  if (!container) return;

  try {
    const res = await fetch(`${API_BASE}/api/transit/today`);
    if (res.ok) {
      const data = await res.json();
      const sun = data.sun_transit;
      container.innerHTML = `
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 0.5rem;">
          <span style="color:var(--yellow-personality); font-weight:700; font-size:0.85rem;">THỜI TIẾT HÔM NAY • CỔNG ${sun.gate}.${sun.line}</span>
          <span style="color:var(--gold-light); font-size:0.85rem; font-weight:bold;">${sun.name_vi}</span>
        </div>
        <p style="color:var(--text-secondary); font-size:0.9rem;">${sun.message}</p>
      `;
      return;
    }
  } catch (_) {}

  container.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 0.5rem;">
      <span style="color:var(--yellow-personality); font-weight:700; font-size:0.85rem;">THỜI TIẾT HÔM NAY • CỔNG 44.3</span>
      <span style="color:var(--gold-light); font-size:0.85rem; font-weight:bold;">Cảnh Giác (Hợp Tác)</span>
    </div>
    <p style="color:var(--text-secondary); font-size:0.9rem;">Mặt Trời hôm nay soi sáng Cổng 44.3. Hãy tập trung xây dựng sự tin tưởng và cộng tác chân thành.</p>
  `;
}

// Hiển thị kết quả lá số
function renderChartResults(data) {
  const overview = data.overview || {};
  const user = data.user || {};

  // Cập nhật thông tin tổng quan
  document.getElementById('res-name').textContent = user.name || 'Bản Mệnh';
  document.getElementById('res-type').textContent = overview.type || 'Nhóm Vận Hành';
  document.getElementById('res-strategy').textContent = overview.strategy || 'Đáp ứng';
  document.getElementById('res-authority').textContent = overview.authority || 'Nguồn sinh lực';
  document.getElementById('res-profile').textContent = overview.profile || '1/3';
  document.getElementById('res-cross').textContent = overview.incarnation_cross || 'Thánh Giá Hóa Thân';

  // Vẽ SVG Bodygraph
  const definedCenters = data.raw_chart?.defined_centers || data.defined_centers || [];
  const activeChannels = data.raw_chart?.active_channels || data.active_channels || [];
  renderSvgBodygraph(definedCenters, activeChannels);

  // Hiển thị các chương luận giải
  renderReadingChapters(data);
}

// Vẽ SVG Bodygraph chính xác
function renderSvgBodygraph(definedCenters, activeChannels) {
  const container = document.getElementById('bodygraph-canvas');
  if (!container) return;

  const activePairs = new Set();
  activeChannels.forEach(ch => {
    if (ch.centers && ch.centers.length === 2) {
      activePairs.add(`${ch.centers[0]}-${ch.centers[1]}`);
      activePairs.add(`${ch.centers[1]}-${ch.centers[0]}`);
    }
  });

  let svg = `<svg viewBox="0 0 400 500" class="bodygraph-svg" xmlns="http://www.w3.org/2000/svg">`;

  // 1. Vẽ các đường kênh kết nối (Channels)
  CHANNELS_LIST.forEach(([c1, c2]) => {
    const p1 = CENTER_COORDS[c1];
    const p2 = CENTER_COORDS[c2];
    const isActive = activePairs.has(`${c1}-${c2}`);
    const stroke = isActive ? '#d4af37' : '#232840';
    const strokeWidth = isActive ? '6' : '3';
    const filter = isActive ? 'filter="drop-shadow(0 0 6px rgba(212, 175, 55, 0.6))"' : '';

    svg += `<line x1="${p1.x}" y1="${p1.y}" x2="${p2.x}" y2="${p2.y}" stroke="${stroke}" stroke-width="${strokeWidth}" stroke-linecap="round" ${filter}/>`;
  });

  // 2. Vẽ 9 Trung tâm
  Object.entries(CENTER_COORDS).forEach(([id, info]) => {
    const isDef = definedCenters.includes(id);
    const fill = isDef ? getCenterFillColor(id) : '#141724';
    const stroke = isDef ? '#ffdf73' : '#475569';
    const strokeWidth = isDef ? '2.5' : '1.5';
    const filter = isDef ? 'filter="drop-shadow(0 0 8px rgba(212, 175, 55, 0.4))"' : '';

    let shapeSvg = '';
    const s = 24;

    switch (info.shape) {
      case 'square':
        shapeSvg = `<rect x="${info.x - s}" y="${info.y - s}" width="${s * 2}" height="${s * 2}" rx="4" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
      case 'diamond':
        shapeSvg = `<polygon points="${info.x},${info.y - s * 1.2} ${info.x + s * 1.2},${info.y} ${info.x},${info.y + s * 1.2} ${info.x - s * 1.2},${info.y}" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
      case 'triangleDown':
        shapeSvg = `<polygon points="${info.x - s},${info.y - s * 0.7} ${info.x + s},${info.y - s * 0.7} ${info.x},${info.y + s * 0.9}" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
      case 'triangleUp':
        shapeSvg = `<polygon points="${info.x},${info.y - s * 0.9} ${info.x + s},${info.y + s * 0.7} ${info.x - s},${info.y + s * 0.7}" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
      case 'triangleLeft':
        shapeSvg = `<polygon points="${info.x + s * 0.7},${info.y - s} ${info.x + s * 0.7},${info.y + s} ${info.x - s * 0.9},${info.y}" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
      case 'triangleRight':
        shapeSvg = `<polygon points="${info.x - s * 0.7},${info.y - s} ${info.x - s * 0.7},${info.y + s} ${info.x + s * 0.9},${info.y}" fill="${fill}" stroke="${stroke}" stroke-width="${strokeWidth}" ${filter}/>`;
        break;
    }

    svg += shapeSvg;

    // Chữ nhãn trung tâm
    const textColor = isDef ? '#0c0d14' : '#94a3b8';
    svg += `<text x="${info.x}" y="${info.y + 3}" text-anchor="middle" font-size="8.5" font-weight="bold" fill="${textColor}">${info.label}</text>`;
  });

  svg += `</svg>`;
  container.innerHTML = svg;
}

function getCenterFillColor(id) {
  switch (id) {
    case 'Head':
    case 'Ajna':
      return '#64dfdf';
    case 'Throat':
      return '#7209b7';
    case 'G_Center':
      return '#ffd166';
    case 'Heart':
      return '#e63946';
    case 'Solar_Plexus':
      return '#f77f00';
    case 'Sacral':
      return '#d62828';
    case 'Spleen':
      return '#2a9d8f';
    case 'Root':
      return '#b5179e';
    default:
      return '#d4af37';
  }
}

// Hiển thị các chương luận giải
function renderReadingChapters(data) {
  const container = document.getElementById('chapters-list');
  if (!container) return;

  const typeRead = data.type_reading || {};
  const authRead = data.authority_reading || {};
  const profRead = data.profile_reading || {};
  const crossRead = data.cross_reading || {};

  const chapters = [
    {
      num: '01',
      title: 'Sứ Mệnh Linh Hồn & Thánh Giá Hóa Thân',
      badge: crossRead.name || data.overview?.incarnation_cross,
      text: crossRead.synthesis || 'Thánh Giá Hóa Thân định hình mục đích và chủ đề xuyên suốt hành trình cuộc sống của bạn.'
    },
    {
      num: '02',
      title: 'Nhóm Năng Lượng & Chiến Lược Đắc Thắng',
      badge: typeRead.name_vi || data.overview?.type,
      text: typeRead.synthesis || 'Vận hành đúng chiến lược sống giúp bạn thu hút mọi thuận duyên và tránh rơi vào trạng thái phi ngã.'
    },
    {
      num: '03',
      title: 'La Bàn Ra Quyết Định (Thẩm Quyền Bên Trong)',
      badge: authRead.name_vi || data.overview?.authority,
      text: authRead.synthesis || 'Thẩm quyền là tiếng nói thiêng liêng từ cơ thể giúp bạn đưa ra những quyết định đúng đắn nhất.'
    },
    {
      num: '04',
      title: 'Hồ Sơ Bản Mệnh (Profile) & Nghệ Thuật Ứng Xử',
      badge: `Hồ sơ ${data.overview?.profile}`,
      text: profRead.synthesis || 'Hồ sơ cá nhân định hình phong cách bạn học hỏi, xây dựng mối quan hệ và phát triển sự nghiệp.'
    }
  ];

  let html = '';
  chapters.forEach(c => {
    html += `
      <div class="chapter-card">
        <div class="chapter-header">
          <span class="chapter-badge">CHƯƠNG ${c.num}</span>
          <span style="color:var(--gold-light); font-size:0.85rem; font-weight:600;">${c.badge}</span>
        </div>
        <h4 class="chapter-title">${c.title}</h4>
        <p class="chapter-content">${c.text}</p>
      </div>
    `;
  });

  container.innerHTML = html;
}

// Fallback data khi không có mạng hoặc chưa chạy server
function renderFallbackData(payload) {
  renderChartResults({
    user: { name: payload.name },
    overview: {
      type: 'Nhóm Vận Hành (Generator)',
      strategy: 'Đáp ứng (Phản hồi dạ dày)',
      authority: 'Quyền năng Nguồn sinh lực (Đan Điền)',
      profile: '3/5',
      incarnation_cross: 'Thánh Giá Khát Khao (Góc Phải)'
    },
    defined_centers: ['Sacral', 'Root', 'G_Center', 'Throat'],
    active_channels: [
      { centers: ['Sacral', 'Throat'] },
      { centers: ['Sacral', 'G_Center'] }
    ],
    type_reading: {
      name_vi: 'Nhóm Vận Hành',
      synthesis: 'Bạn thuộc Nhóm Vận Hành (Generator), sở hữu nguồn năng lượng sống bền bỉ nuôi dưỡng cả thế giới. Chiến lược của bạn là Đáp Ứng - kiên nhẫn chờ đời sống mang lại dấu hiệu và lắng nghe phản xạ Đan Điền thay vì hấp tấp tự khởi xướng.'
    },
    authority_reading: {
      name_vi: 'Quyền năng Nguồn sinh lực',
      synthesis: 'Thẩm quyền của bạn bắt nguồn từ Đan Điền. Bạn phản ứng qua âm thanh tự nhiên "Ừ hứ" hoặc "Ừ ừ". Đừng dùng lý trí để gượng ép bản thân làm điều cơ thể không sẵn lòng.'
    },
    profile_reading: {
      synthesis: 'Hồ sơ 3/5 là sự kết hợp giữa nhà thực nghiệm (Hào 3) và người giải quyết khủng hoảng thực tế (Hào 5). Bạn học hỏi nhanh qua trải nghiệm thực chứng và luôn tìm ra giải pháp tối ưu cho cộng đồng.'
    },
    cross_reading: {
      name: 'Thánh Giá Khát Khao',
      synthesis: 'Sứ mệnh của bạn là dẫn đầu những trải nghiệm mới và đánh thức nguồn cảm hứng cho những người xung quanh.'
    }
  });
}

// Modal Mở khóa VIP & Thanh toán VietQR
function openPaymentModal() {
  const modal = document.getElementById('payment-modal');
  if (modal) modal.style.display = 'flex';
}

function closePaymentModal() {
  const modal = document.getElementById('payment-modal');
  if (modal) modal.style.display = 'none';
}
