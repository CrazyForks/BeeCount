// BeeCount store screenshot generator
// 9 主题 × 2 语言 × 2 设备 = 36 张设备截图 + 2 张 Play feature 横版图 = 38 张
//
// raw 截图按语言分目录（zh / en），切语言时贴对应语言的 app 截图，
// 让商店上架的截图里 app 内文也是对应语言（Apple/Google 都建议这样做）。
//
// 导出走 File System Access API（Chrome/Edge 直写本地目录）或 JSZip 打包下载。

// title 短而有力（4-8 字 / 1-3 词），sub 描述性长（5-10 词），字号差形成视觉层次。
//
// `androidOverride` 字段：仅在 device=android 时合并到 sub。Face ID 是 Apple
// 商标 / 功能，Android 上要换成"指纹"。其他字段（title 等）也可在这里覆盖。
// 字幕 + 顺序策略（卖点前置）：
// 商店缩略图前 3 张曝光最高，4 张卖点（home/open-source/ai/mine）3 张放在前 4 位，
// 中间穿插 analytics 功能展示避免连续卖点疲劳。最后一张 mine 用 Local-first 收尾。
//   #1 home (免费/无广告) → #2 open-source (开源) → #3 analytics (功能展示)
//   → #4 ai (OpenAI) → #5-#8 功能 → #9 mine (Local-first)
const themes = [
  {
    id: 'home',
    // 第一屏专攻最强 USP：开源 + 数据隐私。其他 8 张全部回归功能描述。
    // 截图本身（首页交易列表）作为"app 真实画面"佐证字幕承诺（看不到广告/付费墙）。
    file: '01-home.png',
    zh: { title: '开源透明 数据隐私', sub: '100% 免费 · 无广告 · 离线优先' },
    en: { title: 'Open-source, privacy-first', sub: '100% free · ad-free · offline-first' },
  },
  {
    id: 'open-source',
    // 截图标题就是"Cloud Service / 云服务"，tab 含 Offline/Backup/Cloud Sync。
    // 用"云服务"贴合截图标题，"你做主"承载差异化（多选项 vs 大厂锁定）。
    file: '02-open-source.png',
    zh: { title: '云服务 你做主', sub: 'iCloud · WebDAV · S3 · Supabase 自由选' },
    en: { title: 'Cloud, your way', sub: 'iCloud · WebDAV · S3 · Supabase — your choice' },
  },
  {
    id: 'analytics',
    // 截图主体：分类排行（条形进度条 住房/数码/购物...）+ 折线图（日支出趋势）。
    // "分类饼图"和"年度账单"在这张截图里没视觉证据，去掉。
    file: '03-analytics.png',
    zh: { title: '看清钱去哪了', sub: '分类排行 · 月度趋势 · 一目了然' },
    en: { title: 'See where money goes', sub: 'Categories ranked · monthly trend · at a glance' },
  },
  {
    id: 'ai',
    // 截图实际是"AI 助手对话页"：用户文字输入"bought coffee 35"→ AI 解析出
    // 金额/分类/时间。副标只描述截图能看到的：对话→自动识别→入账。"拍单识别"
    // 在这张截图里没视觉证据，已去掉。
    file: '04-ai.png',
    zh: { title: 'AI 智能记账', sub: '对话记账 · 自动识别 · 一键入账' },
    en: { title: 'AI smart logging', sub: 'Chat to log · AI detects · instant entry' },
  },
  {
    id: 'add',
    file: '05-add.png',
    zh: { title: '极速记一笔', sub: '40+ 分类 · 多账户 · 一秒入账' },
    en: { title: 'Instant entry', sub: '40+ categories · multi-account · 1-tap' },
  },
  {
    id: 'ledgers',
    file: '06-ledgers.png',
    zh: { title: '多账本管理', sub: '个人 · 家庭 · 出差 各自独立' },
    en: { title: 'Multi-ledger', sub: 'Personal · family · trip — separate' },
  },
  {
    id: 'tags',
    // 中文用截图首屏可见的 4 个商家标签（美团/京东/淘宝/星巴克）。
    // 英文之前用"Coffee/Shopping/Trips/Refunds"通用词，但跟截图（实际显示
    // Meituan/Starbucks/McDonald's/KFC/Costco）视觉对不上 — 改用截图里
    // 国际用户认识的品牌（Starbucks/McDonald's/KFC/Costco），字面 ↔ 视觉一致。
    file: '07-tags.png',
    zh: { title: '彩色标签 自动归类', sub: '美团 · 京东 · 淘宝 · 星巴克 一目了然' },
    en: { title: 'Color-coded tags', sub: "Starbucks · McDonald's · KFC · Costco — at a glance" },
  },
  {
    id: 'accounts',
    // 截图首屏三大数字：总资产 / 总负债 / 净资产 + 资产构成圆环图 + 多账户列表。
    // 之前副标"信用卡 · 借记 · 钱包"在中文截图里看不到信用卡（在画面外），改成
    // 截图首屏视觉证据最强的"总资产/总负债/净值"三件套。
    file: '08-accounts.png',
    zh: { title: '资产清晰 净值一屏', sub: '多账户 · 总资产 · 总负债 · 实时计算' },
    en: { title: 'Net worth at a glance', sub: 'Multi-account · assets · liabilities · auto-calculated' },
  },
  {
    id: 'mine',
    // 截图就是"我的"页 = 设置中心。主标"设置一处搞定"精准对应入口列表，
    // 比之前的"全功能管理"（抽象工具感）更贴合截图实际呈现。
    file: '09-mine.png',
    zh: { title: '设置一处搞定', sub: 'AI · 数据 · 预算 · 主题 · 自动化' },
    en: { title: 'All settings in one place', sub: 'AI · data · budget · theme · automation' },
  },
];

// 取主题的 title/sub，按 device 套用 androidOverride。
function themeText(theme, lang, dev) {
  const base = theme[lang];
  if (dev === 'android' && theme.androidOverride?.[lang]) {
    return { ...base, ...theme.androidOverride[lang] };
  }
  return base;
}

/// raw 路径优先级：
///   1. raw/<lang>/android/<file>（仅 device=android 时尝试）
///   2. raw/<lang>/<file>
///   3. raw/<file>（向后兼容旧扁平结构）
///
/// 加 ?v=<page-load-timestamp> 防浏览器缓存：raw 文件改了之后，
/// 同一个 URL 用户刷新页面就能看到新内容（Chrome 默认会强缓存图片）。
const CACHE_BUST = `?v=${Date.now()}`;
function rawPath(theme, lang, dev) {
  if (dev === 'android') {
    return `../raw/${lang}/android/${theme.file}${CACHE_BUST}`;
  }
  return `../raw/${lang}/${theme.file}${CACHE_BUST}`;
}
function rawFallbackPath(theme, lang) {
  return `../raw/${lang}/${theme.file}${CACHE_BUST}`;
}
function rawFlatFallbackPath(theme) {
  return `../raw/${theme.file}${CACHE_BUST}`;
}

// App Store 6.5" slot 接受 1242×2688 或 1284×2778；选 1284×2778 做主（iPhone 12-13
// Pro Max 一代），覆盖度更广。6.1" 暂不出（ASC 当前不强制；6.5" 上传后 Apple 会
// 自动给小屏机型缩图，1 张顶 2 张）。
// Android Play 接受 ≥1080 宽，1080×2400 是当前主流手机比例。
//
// `ar` = device aspect-ratio（width/height），用来在 JS 端把 .device 写成显式像素，
// 避开 html2canvas 对 CSS `transform: translateX(-50%)` + `aspect-ratio` 的渲染 bug。
//
// `feature` = Google Play "Feature Graphic"，官方要求 1024×500（不是 1024×400），
// 横版 banner，没设备框，仅 brand + tagline 居中。
const devices = {
  '6.5': { w: 1284, h: 2778, ar: 1284 / 2778, kind: 'phone' },
  android: { w: 1080, h: 2400, ar: 1080 / 2400, kind: 'phone' },
  feature: { w: 1024, h: 500, ar: 1024 / 500, kind: 'feature' },
};

// 设备容器尺寸常量（百分比，相对 card）
const DEVICE_WIDTH_PCT = 0.78;
const DEVICE_BOTTOM_PCT = 0.07;

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => Array.from(document.querySelectorAll(sel));

// Feature Graphic 文案（横版 banner，BeeCount brand + 文案 + 4 chips）
// chips 突出 4 大卖点：本地优先 / 隐私 / 同步 / 开源
const FEATURE_COPY = {
  zh: {
    brand: 'BeeCount',
    brandSub: '蜜蜂记账',
    tagline: '你的数据，你做主',
    chips: ['本地优先', '真隐私', '真同步', '开源免费'],
  },
  en: {
    brand: 'BeeCount',
    brandSub: 'Privacy-first ledger',
    tagline: 'Your data, your way',
    chips: ['Local-first', 'Private', 'Real sync', 'Open & free'],
  },
};

// 横版 banner（1024×500）布局：
//   左半（~430px 宽）：logo + brand + sub + tagline + 4 chips
//   右半（~570px 宽）：2 张手机截图前后错位（home 在前 / analytics 在后）
// 用真实 DOM 元素而不是 multiple background，避开 html2canvas 渲染坑。
function renderFeatureCard(card, lang) {
  const t = FEATURE_COPY[lang];
  const cardW = parseInt(card.style.width);
  const cardH = parseInt(card.style.height);

  card.classList.add('card-feature');
  const chipsHtml = t.chips.map((c) => `<span class="feature-chip">${c}</span>`).join('');
  card.innerHTML = `
    <div class="feature-content-zone">
      <div class="feature-logo-row">
        <img class="feature-logo" src="../../../logo_216.png" alt="BeeCount" />
        <div class="feature-brand-stack">
          <div class="feature-brand">${t.brand}</div>
          <div class="feature-brand-sub">${t.brandSub}</div>
        </div>
      </div>
      <div class="feature-tagline">${t.tagline}</div>
      <div class="feature-chips">${chipsHtml}</div>
    </div>
    <div class="feature-device feature-device-back">
      <img src="../raw/${lang}/03-analytics.png${CACHE_BUST}" alt="analytics"
           onerror="this.style.opacity='0';" />
    </div>
    <div class="feature-device feature-device-front">
      <img src="../raw/${lang}/01-home.png${CACHE_BUST}" alt="home"
           onerror="this.style.opacity='0';" />
    </div>
  `;

  // 文案区：左 50px 起，垂直居中
  const textZone = card.querySelector('.feature-content-zone');
  textZone.style.position = 'absolute';
  textZone.style.left = '50px';
  textZone.style.top = '50%';
  textZone.style.transform = 'translateY(-50%)';
  textZone.style.width = '430px';

  // 后置设备（统计图）：右侧偏左，稍小，靠后视觉
  const devBack = card.querySelector('.feature-device-back');
  devBack.style.position = 'absolute';
  devBack.style.right = '230px';
  devBack.style.top = '40px';
  devBack.style.width = '180px';
  devBack.style.height = '395px';

  // 前置设备（首页）：右侧偏右，稍大，靠前视觉
  const devFront = card.querySelector('.feature-device-front');
  devFront.style.position = 'absolute';
  devFront.style.right = '40px';
  devFront.style.top = '20px';
  devFront.style.width = '195px';
  devFront.style.height = '440px';

  // 两个设备的 img 自适应：cover + 顶部对齐，让首页头部信息突出
  card.querySelectorAll('.feature-device img').forEach((img) => {
    img.style.width = '100%';
    img.style.height = '100%';
    img.style.objectFit = 'cover';
    img.style.objectPosition = 'top';
    img.style.display = 'block';
  });
}

function renderPhoneCard(card, t, lang, dev, w, h) {
  const text = themeText(t, lang, dev);
  const primary = rawPath(t, lang, dev);
  const fallback1 = rawFallbackPath(t, lang);
  const fallback2 = rawFlatFallbackPath(t);
  // 装饰：3 个圆斑（"灯"）+ 3 颗 ✦ 星星。
  // 用真实 div / span 元素而不是 multiple background-image，
  // 避开 html2canvas 1.4.1 对多层 radial-gradient 的渲染坑。
  card.innerHTML = `
    <span class="d-glow d-glow-1"></span>
    <span class="d-glow d-glow-2"></span>
    <span class="d-glow d-glow-3"></span>
    <span class="d-star d-star-1">✦</span>
    <span class="d-star d-star-2">✧</span>
    <span class="d-star d-star-3">✦</span>
    <div class="header">
      <h1>${text.title}</h1>
      <h2>${text.sub}</h2>
    </div>
    <div class="device">
      <img src="${primary}" alt="${t.id}"
           data-fallback1="${fallback1}"
           data-fallback2="${fallback2}"
           onerror="var s=parseInt(this.dataset.step||'0');
                    if(s===0){this.dataset.step='1';this.src=this.dataset.fallback1;}
                    else if(s===1){this.dataset.step='2';this.src=this.dataset.fallback2;}
                    else{this.parentElement.classList.add('placeholder');
                      this.parentElement.innerHTML='&lt;div&gt;尝试过：&lt;br/&gt;raw/${lang}/android/${t.file}&lt;br/&gt;raw/${lang}/${t.file}&lt;br/&gt;raw/${t.file}&lt;br/&gt;均缺&lt;/div&gt;';}" />
    </div>
  `;
  // html2canvas 不正确处理 CSS `transform: translateX(-50%)` + `aspect-ratio`，
  // 这里给 .device 显式像素定位。
  const dW = Math.round(w * DEVICE_WIDTH_PCT);
  const dH = Math.round(dW / devices[dev].ar);
  const dLeft = Math.round((w - dW) / 2);
  const dBottom = Math.round(h * DEVICE_BOTTOM_PCT);
  const device = card.querySelector('.device');
  device.style.left = `${dLeft}px`;
  device.style.width = `${dW}px`;
  device.style.height = `${dH}px`;
  device.style.bottom = `${dBottom}px`;
  device.style.transform = 'none';
}

function render() {
  const lang = $('#lang').value;
  const dev = $('#device').value;
  const zoom = parseFloat($('#zoom').value);
  const { w, h, kind } = devices[dev];

  const root = $('#cards');
  root.innerHTML = '';

  // Feature graphic 是单卡（不分主题），其他设备按 6 主题渲染
  const items = kind === 'feature' ? [{ id: 'feature' }] : themes;

  items.forEach((t, idx) => {
    const num = String(idx + 1).padStart(2, '0');
    const wrap = document.createElement('div');
    wrap.style.transform = `scale(${zoom})`;
    wrap.style.transformOrigin = 'top center';
    wrap.style.width = `${w * zoom}px`;
    wrap.style.height = `${h * zoom}px`;
    wrap.style.flex = '0 0 auto';

    const card = document.createElement('div');
    card.className = 'card';
    card.dataset.device = dev;
    card.dataset.idx = num;
    card.style.width = `${w}px`;
    card.style.height = `${h}px`;

    if (kind === 'feature') {
      renderFeatureCard(card, lang);
    } else {
      renderPhoneCard(card, t, lang, dev, w, h);
    }

    wrap.appendChild(card);

    const label = document.createElement('div');
    label.className = 'card-label';
    const platformDir = PLATFORM_DIR[dev];
    label.textContent =
      kind === 'feature'
        ? `feature · ${platformDir}/feature-${lang}.png`
        : `#${num} · ${t.id} · ${platformDir}/${dev}-${lang}-${num}.png`;

    const col = document.createElement('div');
    col.style.display = 'flex';
    col.style.flexDirection = 'column';
    col.style.alignItems = 'center';
    col.appendChild(wrap);
    col.appendChild(label);

    root.appendChild(col);
  });
}

// 等所有 .card img 加载完（complete + naturalWidth>0）。3s 兜底放过。
async function waitForCardImages() {
  await new Promise((r) => setTimeout(r, 150));
  const imgs = $$('.card img');
  await Promise.all(
    imgs.map((img) =>
      img.complete && img.naturalWidth > 0
        ? Promise.resolve()
        : new Promise((r) => {
            const done = () => r();
            img.addEventListener('load', done, { once: true });
            img.addEventListener('error', done, { once: true });
            setTimeout(done, 3000);
          }),
    ),
  );
  await new Promise((r) => setTimeout(r, 100));
}

// App Store Connect 拒收带 alpha 的 PNG（"图像不能包含 alpha 通道或透明度"）。
// 双保险：
//   1. html2canvas backgroundColor 给实色（不再透明输出）
//   2. 把结果再画到新 canvas 上，先 fillRect 实色再 drawImage，保证 0 alpha
// 颜色用 #FCF7EA（phone 卡的 background-color fallback 同色）：
//   - 即使 html2canvas 没渲染出 background-image，整张图也是米色而不是白
//   - 与卡顶部色调一致，渲染缝隙融入无痕
// feature card 自己满覆盖深色，不会露出此色。
const FLATTEN_BG = '#FCF7EA';

async function captureCardBlob(card) {
  const canvas = await html2canvas(card, {
    scale: 1,
    useCORS: true,
    allowTaint: true,
    backgroundColor: FLATTEN_BG,
    logging: false,
    width: parseFloat(card.style.width),
    height: parseFloat(card.style.height),
    windowWidth: parseFloat(card.style.width),
    windowHeight: parseFloat(card.style.height),
  });

  const flat = document.createElement('canvas');
  flat.width = canvas.width;
  flat.height = canvas.height;
  const ctx = flat.getContext('2d', { alpha: false });
  ctx.fillStyle = FLATTEN_BG;
  ctx.fillRect(0, 0, flat.width, flat.height);
  ctx.drawImage(canvas, 0, 0);

  return new Promise((resolve) => flat.toBlob(resolve, 'image/png'));
}

function downloadBlob(blob, name) {
  const link = document.createElement('a');
  link.download = name;
  link.href = URL.createObjectURL(blob);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  setTimeout(() => URL.revokeObjectURL(link.href), 60000);
}

function setBtnState(text, disabled = true) {
  for (const id of ['export-current', 'export-all']) {
    const b = $(`#${id}`);
    b.disabled = disabled;
    if (disabled) b.dataset.savedText ||= b.textContent;
    if (text != null) b.textContent = text;
    if (!disabled && b.dataset.savedText) {
      b.textContent = b.dataset.savedText;
      delete b.dataset.savedText;
    }
  }
}

function ensureJSZip() {
  if (typeof JSZip === 'undefined') {
    alert(
      'JSZip 没加载成功（CDN 网络？）\n' +
        '建议：\n' +
        '1) 检查网络，重新刷新页面\n' +
        '2) 或在 BeeCount 仓库根目录跑 `python3 -m http.server 8000`\n' +
        '   然后浏览器访问 http://localhost:8000/assets/store/screenshots/templates/index.html',
    );
    return false;
  }
  return true;
}

// File System Access API（Chrome / Edge / Safari 16.4+）：让用户挑一次目录，
// 直接把文件写进去，不走 Downloads。不支持的浏览器返回 null → 走 zip 下载。
// 用户取消选目录返回 'cancelled' → 整个导出 abort。
let lastDirHandle = null;
async function pickOutputDir() {
  if (!('showDirectoryPicker' in window)) return null;
  if (lastDirHandle) {
    try {
      const perm = await lastDirHandle.queryPermission({ mode: 'readwrite' });
      if (perm === 'granted') return lastDirHandle;
      const re = await lastDirHandle.requestPermission({ mode: 'readwrite' });
      if (re === 'granted') return lastDirHandle;
    } catch (_) {
      lastDirHandle = null;
    }
  }
  try {
    const handle = await window.showDirectoryPicker({
      mode: 'readwrite',
      id: 'beecount-screenshots-output',
      startIn: 'documents',
    });
    lastDirHandle = handle;
    return handle;
  } catch (e) {
    if (e.name === 'AbortError') return 'cancelled';
    return null;
  }
}

// 解析嵌套路径 'apple/6.5-zh-01.png' -> 先 getDirectoryHandle('apple', {create})，
// 再写文件 '6.5-zh-01.png'。支持任意层级。
async function writeFilesToDir(dirHandle, items, onProgress) {
  for (let i = 0; i < items.length; i++) {
    const { name, blob } = items[i];
    const parts = name.split('/');
    let currentDir = dirHandle;
    for (let j = 0; j < parts.length - 1; j++) {
      currentDir = await currentDir.getDirectoryHandle(parts[j], { create: true });
    }
    const fileName = parts[parts.length - 1];
    const fileHandle = await currentDir.getFileHandle(fileName, { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(blob);
    await writable.close();
    onProgress?.(i + 1, items.length);
  }
}

async function deliverItems(items, zipName) {
  const dirHandle = await pickOutputDir();
  if (dirHandle === 'cancelled') return;

  if (dirHandle) {
    setBtnState('写入文件 0...');
    await writeFilesToDir(dirHandle, items, (done, total) =>
      setBtnState(`写入文件 ${done}/${total}...`),
    );
    alert(
      `已写入 ${items.length} 张到 "${dirHandle.name}/"\n` +
        '（首次选目录建议直接选 assets/store/screenshots/output/，下次会记住）',
    );
  } else {
    if (!ensureJSZip()) return;
    setBtnState('打包 zip 中...');
    const zip = new JSZip();
    items.forEach(({ name, blob }) => zip.file(name, blob));
    const zipBlob = await zip.generateAsync({ type: 'blob', compression: 'STORE' });
    downloadBlob(zipBlob, zipName);
    alert(
      '浏览器不支持直接写本地目录（File System Access API），已打成 zip 下载。\n' +
        '推荐用 Chrome/Edge + 通过 http://localhost:... 访问以启用直写。',
    );
  }
}

// 输出按平台分到子目录：
//   apple/6.5-{lang}-{nn}.png        — App Store iPhone 6.5"
//   google-play/android-{lang}-{nn}.png — Google Play Android 截图
//   google-play/feature-{lang}.png   — Google Play Feature Graphic
const PLATFORM_DIR = {
  '6.5': 'apple',
  'android': 'google-play',
  'feature': 'google-play',
};

function makeNames(dev, lang, count) {
  const dir = PLATFORM_DIR[dev];
  if (devices[dev].kind === 'feature') return [`${dir}/feature-${lang}.png`];
  return Array.from({ length: count }, (_, i) =>
    `${dir}/${dev}-${lang}-${String(i + 1).padStart(2, '0')}.png`,
  );
}

async function exportCurrent() {
  const lang = $('#lang').value;
  const dev = $('#device').value;
  const oldZoom = $('#zoom').value;
  $('#zoom').value = '1';
  render();
  await waitForCardImages();

  const cards = $$('.card');
  setBtnState(`截图 0/${cards.length}...`);
  try {
    const items = [];
    const names = makeNames(dev, lang, cards.length);
    for (let i = 0; i < cards.length; i++) {
      setBtnState(`截图 ${i + 1}/${cards.length}...`);
      const blob = await captureCardBlob(cards[i]);
      items.push({ name: names[i], blob });
    }
    await deliverItems(items, `beecount-${dev}-${lang}.zip`);
  } finally {
    setBtnState(null, false);
    $('#zoom').value = oldZoom;
    render();
  }
}

async function exportAll() {
  const oldLang = $('#lang').value;
  const oldDev = $('#device').value;
  const oldZoom = $('#zoom').value;
  $('#zoom').value = '1';

  // 计算总数：phone 设备 × 6 主题 + feature 设备 × 1，再 × 2 语言
  const phoneCount = Object.values(devices).filter((d) => d.kind === 'phone').length;
  const featureCount = Object.values(devices).filter((d) => d.kind === 'feature').length;
  const total = 2 * (phoneCount * themes.length + featureCount);

  setBtnState(`截图 0/${total}...`);
  try {
    const items = [];
    let count = 0;
    for (const lang of ['zh', 'en']) {
      $('#lang').value = lang;
      for (const dev of Object.keys(devices)) {
        $('#device').value = dev;
        render();
        await waitForCardImages();
        const cards = $$('.card');
        const names = makeNames(dev, lang, cards.length);
        for (let i = 0; i < cards.length; i++) {
          count++;
          setBtnState(`截图 ${count}/${total}...`);
          const blob = await captureCardBlob(cards[i]);
          items.push({ name: names[i], blob });
        }
      }
    }
    const date = new Date().toISOString().slice(0, 10);
    await deliverItems(items, `beecount-screenshots-${date}.zip`);
  } finally {
    setBtnState(null, false);
    $('#lang').value = oldLang;
    $('#device').value = oldDev;
    $('#zoom').value = oldZoom;
    render();
  }
}

// 记住下拉选择（lang / device / zoom）。刷新页面后自动恢复上次的值，
// 避免每次都得重选"中文 / 6.5 / 0.3x"。
const STORAGE_KEY = 'beecount-screenshots-selections';

function loadSelections() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return;
    const saved = JSON.parse(raw);
    for (const id of ['lang', 'device', 'zoom']) {
      const el = $(`#${id}`);
      if (saved[id] != null && el && [...el.options].some((o) => o.value === saved[id])) {
        el.value = saved[id];
      }
    }
  } catch (_) {
    /* localStorage 不可用 / JSON 损坏，忽略，回退到 HTML 默认值 */
  }
}

function saveSelections() {
  try {
    localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify({
        lang: $('#lang').value,
        device: $('#device').value,
        zoom: $('#zoom').value,
      }),
    );
  } catch (_) {
    /* 隐私模式可能禁止 localStorage，忽略 */
  }
}

['lang', 'device', 'zoom'].forEach((id) =>
  $(`#${id}`).addEventListener('change', () => {
    saveSelections();
    render();
  }),
);
$('#export-current').addEventListener('click', exportCurrent);
$('#export-all').addEventListener('click', exportAll);

// 注意：exportAll/exportCurrent 内部临时改 .value 后又恢复，那些改动通过赋值
// 不会触发 'change' 事件，所以不会污染 localStorage —— 只有用户手动改下拉
// 才会被记住，符合直觉。
loadSelections();
render();
