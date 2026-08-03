/**
 * Visitor Tracker
 * 
 * Dùng 2 service free:
 * 1. GoatCounter (free hosted) - Dashboard analytics đẹp, aggregate stats
 * 2. Supabase (free tier) - Lưu chi tiết từng visitor (IP, device, location...)
 * 
 * ========== HƯỚNG DẪN SETUP ==========
 * 
 * BƯỚC 1: GoatCounter (2 phút)
 *   - Vào https://www.goatcounter.com → Sign up
 *   - Chọn "Code" (ví dụ: otd-portfolio)
 *   - Đổi GOATCOUNTER_CODE bên dưới thành code bạn chọn
 *   - Dashboard xem tại: https://otd-portfolio.goatcounter.com
 * 
 * BƯỚC 2: Supabase (5 phút)
 *   - Vào https://supabase.com → Sign up → New Project
 *   - Vào SQL Editor, chạy đoạn SQL ở file: backend/supabase-setup.sql
 *   - Vào Project Settings → API Keys
 *   - Dùng publishable key (sb_publishable_...) HOẶC legacy anon key (eyJhbG...)
 *   - Đổi SUPABASE_URL và SUPABASE_ANON_KEY bên dưới
 * 
 * =====================================
 */
(function () {
  // ============ CẤU HÌNH ============
  const GOATCOUNTER_CODE = 'ondat24';
  const SUPABASE_URL     = 'https://plxzjoukdpgzmjhxocpb.supabase.co';
  const SUPABASE_ANON_KEY = 'sb_publishable_IKpV7Y3y8Nr-DvbOY93NvA_VpZCO3RJ';
  // ===================================

  // --- 1. GoatCounter: Inject script tự động ---
  if (GOATCOUNTER_CODE !== 'YOUR_CODE') {
    const gc = document.createElement('script');
    gc.async = true;
    gc.dataset.goatcounter = `https://${GOATCOUNTER_CODE}.goatcounter.com/count`;
    gc.src = '//gc.zgo.at/count.js';
    document.head.appendChild(gc);
  }

  // --- 2. Supabase: Lưu chi tiết visitor ---
  if (SUPABASE_URL === 'YOUR_SUPABASE_URL') return; // Chưa config thì skip

  function getSessionId() {
    let sid = sessionStorage.getItem('_vsid');
    if (!sid) {
      sid = 'v_' + Date.now() + '_' + Math.random().toString(36).substring(2, 10);
      sessionStorage.setItem('_vsid', sid);
    }
    return sid;
  }

  async function getGeoInfo() {
    try {
      const res = await fetch('https://ipapi.co/json/');
      if (!res.ok) return {};
      const data = await res.json();
      return {
        ip: data.ip || null,
        country: data.country_name || null,
        city: data.city || null,
        region: data.region || null,
        timezone: data.timezone || null
      };
    } catch {
      return {};
    }
  }

  function getBrowserInfo() {
    const ua = navigator.userAgent;
    let browser = 'Unknown', os = 'Unknown', deviceType = 'desktop';

    // Browser detection
    if (ua.includes('Firefox/')) browser = 'Firefox';
    else if (ua.includes('Edg/')) browser = 'Edge';
    else if (ua.includes('OPR/') || ua.includes('Opera')) browser = 'Opera';
    else if (ua.includes('Chrome/')) browser = 'Chrome';
    else if (ua.includes('Safari/') && !ua.includes('Chrome')) browser = 'Safari';

    // OS detection
    if (ua.includes('Windows')) os = 'Windows';
    else if (ua.includes('Mac OS')) os = 'macOS';
    else if (ua.includes('Linux')) os = 'Linux';
    else if (ua.includes('Android')) os = 'Android';
    else if (ua.includes('iPhone') || ua.includes('iPad')) os = 'iOS';

    // Device type
    if (/Mobi|Android.*Mobile|iPhone/i.test(ua)) deviceType = 'mobile';
    else if (/iPad|Android(?!.*Mobile)|Tablet/i.test(ua)) deviceType = 'tablet';

    return { browser, os, device_type: deviceType };
  }

  async function trackVisitor() {
    try {
      if (sessionStorage.getItem('_vtracked')) return;

      const sessionId = getSessionId();
      const geo = await getGeoInfo();
      const { browser, os, device_type } = getBrowserInfo();

      const payload = {
        session_id: sessionId,
        ip: geo.ip,
        country: geo.country,
        city: geo.city,
        region: geo.region,
        timezone: geo.timezone,
        browser,
        os,
        device_type,
        screen_width: window.screen.width,
        screen_height: window.screen.height,
        language: navigator.language || null,
        referrer: document.referrer || null,
        page_url: window.location.href,
        user_agent: navigator.userAgent
      };

      // Xác định header dựa trên loại key
      const headers = {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_ANON_KEY,
        'Prefer': 'return=minimal'
      };
      // Legacy JWT key (eyJ...) cần thêm Authorization header
      if (SUPABASE_ANON_KEY.startsWith('eyJ')) {
        headers['Authorization'] = `Bearer ${SUPABASE_ANON_KEY}`;
      }

      await fetch(`${SUPABASE_URL}/rest/v1/visitors`, {
        method: 'POST',
        headers,
        body: JSON.stringify(payload)
      });

      sessionStorage.setItem('_vtracked', '1');
    } catch {
      // Silent fail
    }
  }

  // Track time spent on page (dùng fetch + keepalive thay sendBeacon vì cần headers)
  const pageLoadTime = Date.now();
  window.addEventListener('beforeunload', () => {
    const timeSpent = Math.round((Date.now() - pageLoadTime) / 1000);
    const sessionId = getSessionId();

    try {
      const headers = {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_ANON_KEY,
        'Prefer': 'return=minimal'
      };
      if (SUPABASE_ANON_KEY.startsWith('eyJ')) {
        headers['Authorization'] = `Bearer ${SUPABASE_ANON_KEY}`;
      }

      fetch(`${SUPABASE_URL}/rest/v1/page_views`, {
        method: 'POST',
        headers,
        body: JSON.stringify({
          session_id: sessionId,
          page_url: window.location.href,
          page_title: document.title,
          time_spent: timeSpent
        }),
        keepalive: true
      });
    } catch {
      // Silent fail
    }
  });

  // Run
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', trackVisitor);
  } else {
    trackVisitor();
  }
})();
