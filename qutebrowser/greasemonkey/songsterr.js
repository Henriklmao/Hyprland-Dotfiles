// ==UserScript==
// @name           🎸 Songsterr Ultimate (Premium Unlocked)
// @name:en        🎸 Songsterr Ultimate (Premium Unlocked)
// @name:fr        🎸 Songsterr Ultime (Premium Débloqué)
// @name:es        🎸 Songsterr Definitivo (Premium Desbloqueado)
// @name:de        🎸 Songsterr Ultimativ (Premium Freigeschaltet)
// @name:it        🎸 Songsterr Definitivo (Premium Sbloccato)
// @name:pt        🎸 Songsterr Supremo (Premium Desbloqueado)
// @name:pt-BR     🎸 Songsterr Supremo (Full Premium)
// @name:nl        🎸 Songsterr Ultiem (Premium Ontgrendeld)
// @name:pl        🎸 Songsterr Ostateczny (Premium Odblokowany)
// @name:ru        🎸 Songsterr Абсолютный (Премиум Разблокирован)
// @name:ja        🎸 Songsterr 究極 (プレミアム解除)
// @name:ko        🎸 Songsterr 궁극 (프리미엄 언락)
// @name:sv        🎸 Songsterr Ultimat (Premium Upplåst)
// @name:da        🎸 Songsterr Ultimativ (Premium Låst Op)
// @namespace    http://tampermonkey.net/
// @version      5.0.0
// @description                    Unlocks all Plus features (Speed, Loop, Solo, Mute, no pauses) + Native Export (.gp & .midi). (Tested on Zen Browser)
// @description:fr                 Débloque toutes les fonctionnalités Plus (Vitesse, Loop, Solo, Mute, sans pauses) + Téléchargement natif (.gp & .midi). (Testé sur Zen Browser)
// @description:es                 Desbloquea todas las funciones Plus (Velocidad, Bucle, Solo, Mute, sin pausas) + Descarga nativa (.gp y .midi). (Probado en Zen Browser)
// @description:de                 Schaltet alle Plus-Features frei (Geschwindigkeit, Loop, Solo, Mute, ohne Pausen) + Nativer Download (.gp & .midi). (Getestet auf Zen Browser)
// @description:it                 Sblocca tutte le funzioni Plus (Velocità, Loop, Solo, Mute, senza pause) + Download nativo (.gp e .midi). (Testato su Zen Browser)
// @description:pt                 Desbloqueia todos os recursos Plus (Velocidade, Loop, Solo, Mute, sem pausas) + Download nativo (.gp e .midi). (Testado no Zen Browser)
// @description:pt-BR              Desbloqueia tudo do Plus (Velocidade, Loop, Solo, Mute, sem pausas) + Export nativo (.gp & .midi). (Testado no Zen Browser)
// @description:nl                 Ontgrendelt alle Plus-functies (Snelheid, Loop, Solo, Mute, geen pauzes) + Native download (.gp & .midi). (Getest op Zen Browser)
// @description:pl                 Odblokowuje wszystkie funkcje Plus (Prędkość, Pętla, Solo, Mute, bez przerw) + Natywny eksport (.gp i .midi). (Testowane na Zen Browser)
// @description:ru                 Разблокирует все функции Plus (Скорость, Петля, Соло, Mute, без пауз) + Нативный экспорт (.gp и .midi). (Протестировано в Zen Browser)
// @description:ja                 Plusの全機能（速度、ループ、ソロ、ミュート、無停止）を解除 + ネイティブダウンロード（.gp & .midi）。(Zen Browserでテスト済み)
// @description:ko                 모든 Plus 기능 해제 (속도, 루프, 솔로, 뮤트, 멈춤 없음) + 네이티브 다운로드 (.gp & .midi). (Zen Browser에서 테스트됨)
// @description:sv                 Låser upp alla Plus-funktioner (Hastighet, Loop, Solo, Mute, inga pauser) + Naturlig export (.gp & .midi). (Testat på Zen Browser)
// @description:da                 Låser alle Plus-funktioner op (Hastighed, Loop, Solo, Mute, ingen pauser) + Naturlig download (.gp & .midi). (Testet på Zen Browser)
// @author       Goulagman
// @match        *://www.songsterr.com/*
// @require      https://cdn.jsdelivr.net/npm/@coderline/alphatab@1.8.1/dist/alphaTab.min.js
// @connect      dqsljvtekg760.cloudfront.net
// @connect      d3d3l6a6rcgkaf.cloudfront.net
// @grant        unsafeWindow
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @run-at       document-start
// @license      MIT
// @downloadURL https://update.greasyfork.org/scripts/564818/%F0%9F%8E%B8%20Songsterr%20Ultimate%20%28Premium%20Unlocked%29.user.js
// @updateURL https://update.greasyfork.org/scripts/564818/%F0%9F%8E%B8%20Songsterr%20Ultimate%20%28Premium%20Unlocked%29.meta.js
// ==/UserScript==
!function () {
  "use strict";
  // ==================================================
  // 1. LOGGING SYSTEM
  // Handles debug console logs and injects a UI toggle button.
  // ==================================================
  const LOG_KEY = "songsterr_debug_logging";
  let loggingEnabled = !1;
  try {
    loggingEnabled = "true" === localStorage.getItem(LOG_KEY);
  } catch (e) { }
  function sgdLog(level, prefix, ...args) {
    if (!loggingEnabled) return;
    const fullPrefix = prefix ? `[${prefix}]` : "[SGD]";
    "error" === level ? console.error(fullPrefix, ...args) : "warn" === level ? console.warn(fullPrefix, ...args) : console.log(fullPrefix, ...args);
  }
  function updateLogToggleUI() {
    const btn = document.getElementById("sgd-log-toggle");
    btn && (btn.innerHTML = `<span style="font-size: 16px;">📋</span> <span style="font-weight: 700;">Logging</span> <span style="font-size: 14px;">${loggingEnabled ? "ON" : "OFF"}</span>`,
      btn.title = loggingEnabled ? "Debug logging enabled (click to disable)" : "Debug logging disabled (click to enable)",
      btn.classList.toggle("active", loggingEnabled));
  }
  window.toggleSgdLogging = function () {
    loggingEnabled = !loggingEnabled;
    try {
      localStorage.setItem(LOG_KEY, loggingEnabled);
    } catch (e) { }
    console.log("🎸 Songsterr Ultimate — Logging " + (loggingEnabled ? "ENABLED" : "DISABLED")),
      updateLogToggleUI();
  }, new MutationObserver(() => {
    !function () {
      const targetDiv = document.querySelector(".Gl5687");
      if (!targetDiv || document.getElementById("sgd-log-toggle")) return;
      targetDiv.style.cssText = "display:flex!important;align-items:center!important;justify-content:center!important;width:100%!important;height:100%!important;";
      const btn = document.createElement("button");
      btn.id = "sgd-log-toggle", btn.className = "sgd-log-toggle-btn", btn.addEventListener("click", window.toggleSgdLogging),
        targetDiv.appendChild(btn), updateLogToggleUI();
    }();
  }).observe(document.documentElement, {
    childList: !0,
    subtree: !0
  }), console.log("🎸 Songsterr Ultimate — Active v5.0.0", loggingEnabled ? "(Debug logging ON)" : ""),
    function () {
      // ==================================================
      // 2. YOUTUBE AUDIO-ONLY MODE
      // Visually hides YouTube iframes to save bandwidth while keeping the audio. (TY パプリカ)
      // ==================================================
      let ytAudioOnlyMode = !1;
      try {
        ytAudioOnlyMode = "true" === localStorage.getItem("songsterr_yt_audio_only");
      } catch (e) { }
      function hideYouTubeIframes() {
        if (!ytAudioOnlyMode) return;
        const iframes = document.querySelectorAll("iframe"), keywords = /(player|video|youtube)/i;
        iframes.forEach(iframe => {
          const src = iframe.src || "";
          if ((src.includes("youtube.com") || src.includes("youtu.be")) && !iframe.classList.contains("songsterr-yt-hidden-iframe")) {
            iframe.classList.add("songsterr-yt-hidden-iframe");
            let currentParent = iframe.parentElement, level = 0;
            for (; currentParent && level < 5 && "BODY" !== currentParent.tagName && "HTML" !== currentParent.tagName;) {
              const className = "string" == typeof currentParent.className ? currentParent.className : "", idName = currentParent.id || "";
              (level < 2 || keywords.test(className) || keywords.test(idName)) && currentParent.classList.add("songsterr-yt-hidden-wrapper"),
                currentParent = currentParent.parentElement, level++;
            }
          }
        });
      }
      window.toggleYtAudioOnly = function () {
        ytAudioOnlyMode = !ytAudioOnlyMode;
        try {
          localStorage.setItem("songsterr_yt_audio_only", ytAudioOnlyMode);
        } catch (e) { }
        !function () {
          ytAudioOnlyMode ? hideYouTubeIframes() : (document.querySelectorAll(".songsterr-yt-hidden-iframe").forEach(el => el.classList.remove("songsterr-yt-hidden-iframe")),
            document.querySelectorAll(".songsterr-yt-hidden-wrapper").forEach(el => el.classList.remove("songsterr-yt-hidden-wrapper")));
          const btn = document.getElementById("yt-toggle-btn");
          btn && (btn.innerHTML = ytAudioOnlyMode ? "🎵" : "🎬", btn.title = ytAudioOnlyMode ? "Audio-only mode (click to show video)" : "Video visible (click for audio-only)",
            btn.classList.toggle("audio-only", ytAudioOnlyMode));
        }();
      }, hideYouTubeIframes();
      const observer = new MutationObserver(mutations => {
        let shouldCheck = !1;
        for (const mutation of mutations) if (mutation.addedNodes.length > 0 || "attributes" === mutation.type && "IFRAME" === mutation.target.tagName) {
          shouldCheck = !0;
          break;
        }
        shouldCheck && hideYouTubeIframes();
      });
      function startObserving() {
        document.body && (hideYouTubeIframes(), observer.observe(document.body, {
          childList: !0,
          subtree: !0,
          attributes: !0,
          attributeFilter: ["src"]
        }), sgdLog("log", "Songsterr YT Hider", "Started monitoring (Paprika version + toggle)"));
      }
      document.body ? startObserving() : document.addEventListener("DOMContentLoaded", startObserving);
    }(), function () {
      // ==================================================
      // 3. AUTOSCROLL & CSS FIXES
      // Prevents Songsterr from disabling native autoscroll and hiding overflow. (TY パプリカ)
      // ==================================================
      function fixCSS() {
        document.querySelectorAll("style").forEach(style => {
          const cssText = style.textContent;
          cssText.includes("body, html") && cssText.includes("overflow: auto !important") && (style.textContent = cssText.replace(/body,\s*html\s*\{\s*overflow:\s*auto\s*!important;\s*\}/g, ""));
        }), document.body.style.setProperty("overflow", "visible", "important"), document.documentElement.style.setProperty("overflow", "visible", "important");
      }
      function protectButton() {
        document.querySelectorAll('[data-id*="Autoscroll"]').forEach(btn => {
          const origId = btn.getAttribute("data-id");
          if (origId && origId.includes("Autoscroll") && !origId.includes("Auto-Scroll")) {
            const safeId = origId.replace("Autoscroll", "Auto-Scroll");
            btn.setAttribute("data-id", safeId), sgdLog("log", "Songsterr Native Restore", "Protected Autoscroll button from external setInterval overwrites."),
              btn.dispatchEvent(new MouseEvent("focus", {
                bubbles: !0
              })), btn.dispatchEvent(new MouseEvent("mouseover", {
                bubbles: !0
              }));
          }
        });
      }
      sgdLog("log", "Songsterr Native Restore", "Initializing native auto-scroll recovery..."),
        new MutationObserver(mutations => {
          let shouldFix = !1;
          for (const mutation of mutations) if (mutation.addedNodes.length > 0) {
            shouldFix = !0;
            break;
          }
          shouldFix && (fixCSS(), protectButton());
        }).observe(document.documentElement, {
          childList: !0,
          subtree: !0,
          attributes: !1
        }), setTimeout(() => {
          fixCSS(), protectButton();
        }, 500), setTimeout(() => {
          fixCSS(), protectButton();
        }, 2e3);
    }();
  // ==================================================
  // 4. PREMIUM FEATURES UNLOCK (STATE SPOOFING)
  // Bypasses the paywall by faking a 'Plus' user profile and hooking window.fetch.
  // ==================================================
  const PLUS_DATA_IDS = ["Speed", "Loop", "Solo", "Print"];
  try {
    localStorage.removeItem("persist:root");
  } catch (e) { }
  const targetWindow = "undefined" != typeof unsafeWindow ? unsafeWindow : window, MAGIC_ID = Math.floor(9e8 * Math.random()) + 1e8, MAGIC_PROFILE = {
    id: MAGIC_ID,
    uid: MAGIC_ID,
    email: `plususer${MAGIC_ID}@songsterr.com`,
    name: "Plus User (Unlocked)",
    plan: "plus",
    hasPlus: !0,
    permissions: [],
    subscription: {
      plan: {
        id: "plus"
      }
    },
    bonusPurchasedFeatures: [],
    signature: "patched_signature",
    hadPlusBeforeSE: !0
  }, fetchOriginal = targetWindow.fetch;
  function manageCacheSize() {
    if (window.__SGD_REVISION_CACHE.size >= 50) {
      const entries = Array.from(window.__SGD_REVISION_CACHE.entries());
      for (let i = 0; i < 10 && i < entries.length; i++) window.__SGD_REVISION_CACHE.delete(entries[i][0]);
      sgdLog("log", "SGD", `Cache cleanup: removed 10 old entries, size: ${window.__SGD_REVISION_CACHE.size}`);
    }
  }
  window.__SGD_REVISION_CACHE = new Map;
  // ==================================================
  // 5. FETCH INTERCEPTION (API CACHING)
  // Intercepts Songsterr API calls to cache the raw song JSON data for later export.
  // ==================================================
  const fetchHooked = async function (resource, options) {
    const url = "object" == typeof resource && resource instanceof Request ? resource.url : resource || "";
    if (url.includes("/auth/profile")) return new Response(JSON.stringify(MAGIC_PROFILE), {
      status: 200,
      headers: {
        "Content-Type": "application/json"
      }
    });
    if (url.includes("/api/songs/") || url.includes("/api/tab/") || url.includes("/api/song/")) try {
      const response = await fetchOriginal(resource, options), clonedResponse = response.clone(), data = await clonedResponse.json().catch(() => null);
      if (data && (data.revisions || data.revision || data.songId || data.id)) {
        const songId = data.songId || data.id || function (url) {
          const matches = url.match(/\/s(\d+)(?:\/|$)/) || url.match(/\/songs?\/(\d+)/);
          return matches ? matches[1] : null;
        }(url);
        songId && (manageCacheSize(), window.__SGD_REVISION_CACHE.set(String(songId), data),
          sgdLog("log", "SGD", "Cached revision data for song:", songId));
      }
      return response;
    } catch (err) {
      return fetchOriginal(resource, options);
    }
    return url.match(/(sentry|logs|analytics|useraudio)/i) ? new Response("{}", {
      status: 200
    }) : fetchOriginal(resource, options);
  };
  fetchHooked.toString = () => fetchOriginal.toString();
  try {
    Object.defineProperty(targetWindow, "fetch", {
      value: fetchHooked,
      writable: !1,
      configurable: !1
    }), sgdLog("log", "SGD", "✅ Fetch hook installed with protection");
  } catch (e) {
    sgdLog("error", "SGD", "Failed to install protected fetch hook:", e), targetWindow.fetch = fetchHooked;
  }
  new MutationObserver(() => {
    const el = document.getElementById("state");
    if (el) try {
      const text = el.textContent.trim();
      if (!text) return;
      const data = JSON.parse(text);
      data.user || (data.user = {}), data.user.hasPlus = !0, data.user.isLoggedIn = !0,
        data.user.profile = MAGIC_PROFILE, data.consent = {
          loading: !1,
          suite: "tcf",
          view: "none"
        };
      const patched = JSON.stringify(data);
      el.textContent !== patched && (el.textContent = patched);
    } catch (e) {
      sgdLog("warn", "SGD", "Failed to parse state JSON:", e.message);
    }
  }).observe(document.documentElement, {
    childList: !0,
    subtree: !0
  }), new MutationObserver(() => {
    const apptab = document.getElementById("apptab");
    if (apptab && "yes" === apptab.getAttribute("data-has-showroom")) {
      const showroom = document.getElementById("showroom"), tablature = document.getElementById("tablature");
      showroom && tablature && (tablature.parentElement === showroom && (apptab.insertBefore(tablature, showroom),
        sgdLog("log", "Showroom Fix", "Moved tablature out of showroom for proper rendering")),
        showroom.style.display = "none", showroom.style.visibility = "hidden", apptab.setAttribute("data-has-showroom", "fixed"),
        sgdLog("log", "Showroom Fix", "Forced transition to tab-only view"));
    }
  }).observe(document.documentElement, {
    childList: !0,
    subtree: !0
  }), // ==================================================
    // 6. CUSTOM CSS INJECTION
    // Styles the injected download buttons and hides ads.
    // ==================================================
    GM_addStyle('\n    /* ── Hide unwanted elements ────────────────────────────────────── */\n    section[data-consent="summary"],\n    div[class*="Consent"],\n    #onetrust-banner-sdk,\n    [id*="ad-"],\n    [class*="ad-"],\n    div[id^="div-gpt-ad"],\n    div[class*="Error"]\n    { display: none !important; visibility: hidden !important; }\n\n    /* ── IMPORTANT: Do NOT override body/html overflow - handled by Autoscroll Fix ── */\n    /* NOTE: Commented to not interfere with the showroom */\n    /* #apptab    { opacity: 1 !important; visibility: visible !important; } */\n\n    /* ── YouTube Audio-Only visually hidden elements ────────────────── */\n    .songsterr-yt-hidden-iframe {\n      opacity: 0 !important;\n      width: 0px !important;\n      height: 0px !important;\n      pointer-events: none !important;\n      position: absolute !important;\n      z-index: -9999 !important;\n      border: none !important;\n    }\n    .songsterr-yt-hidden-wrapper {\n      opacity: 0 !important;\n      width: 0px !important;\n      height: 0px !important;\n      min-width: 0px !important;\n      min-height: 0px !important;\n      margin: 0 !important;\n      padding: 0 !important;\n      border: none !important;\n      overflow: hidden !important;\n      background: transparent !important;\n      position: absolute !important;\n      pointer-events: none !important;\n      z-index: -9999 !important;\n    }\n\n    /* ── Our button wrapper ─────────────────────────────────────────── */\n    #sgd-wrapper {\n      display      : inline-flex;\n      align-items  : center;\n      gap          : 12px;\n    }\n\n    /* ── GP7 & MIDI buttons — styled to match Songsterr native dark UI ───── */\n    .sgd-btn {\n      display         : inline-flex;\n      align-items     : center;\n      justify-content : center;\n      gap             : 6px;\n      padding         : 0 12px;\n      height          : 36px;\n      border          : 1px solid #3a3a3a;\n      border-radius   : 6px;\n      font-size       : 13px;\n      font-weight     : 500;\n      cursor          : pointer;\n      white-space     : nowrap;\n      transition      : all 0.15s ease;\n      font-family     : -apple-system, BlinkMacSystemFont, \'Segoe UI\', sans-serif;\n      line-height     : 1;\n      letter-spacing  : -0.01em;\n      background      : #2a2a2a;\n      color           : #e5e5e5;\n    }\n    .sgd-btn:hover {\n      background : #3a3a3a;\n      border-color: #4a4a4a;\n    }\n    .sgd-btn:active {\n      background : #1a1a1a;\n    }\n    .sgd-btn:disabled {\n      opacity    : 0.4;\n      cursor     : not-allowed;\n    }\n    /* Primary action buttons (GP7) - blue accent matching Songsterr */\n    .sgd-btn-gp {\n      background : #2563eb;\n      color      : #fff;\n      border-color: #3b82f6;\n    }\n    .sgd-btn-gp:hover {\n      background : #1d4ed8;\n      border-color: #2563eb;\n    }\n    /* Secondary action buttons (MIDI) - neutral dark */\n    .sgd-btn-midi {\n      background : #404040;\n      color      : #e5e5e5;\n      border-color: #525252;\n    }\n    .sgd-btn-midi:hover {\n      background : #525252;\n      border-color: #626262;\n    }\n\n    /* ── YouTube toggle button — styled to match Songsterr dark UI ────────── */\n    #yt-toggle-btn {\n      display         : inline-flex;\n      align-items     : center;\n      justify-content : center;\n      width           : 36px;\n      height          : 36px;\n      border-radius   : 6px;\n      border          : 1px solid #3a3a3a;\n      background      : #2a2a2a;\n      color           : #a5a5a5;\n      cursor          : pointer;\n      font-size       : 16px;\n      transition      : all 0.15s ease;\n    }\n    #yt-toggle-btn:hover {\n      background : #3a3a3a;\n      color      : #e5e5e5;\n    }\n    #yt-toggle-btn.audio-only {\n      background : #16a34a;\n      color      : #fff;\n      border-color: #22c55e;\n    }\n    #yt-toggle-btn.audio-only:hover {\n      background : #15803d;\n      border-color: #16a34a;\n    }\n\n    /* ── Logging toggle button — styled to match Songsterr dark UI ────────── */\n    #sgd-log-toggle {\n      display: inline-flex;\n      align-items: center;\n      justify-content: center;\n      gap: 8px;\n      padding: 8px 16px;\n      border-radius: 6px;\n      font-size: 14px;\n      font-weight: 500;\n      font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', sans-serif;\n      cursor: pointer;\n      transition: all 0.15s ease;\n      min-width: 120px;\n      height: 36px;\n    }\n    #sgd-log-toggle.active {\n      background: #166534;\n      border: 1px solid #16a34a;\n      color: #fff;\n    }\n    #sgd-log-toggle.active:hover {\n      background: #15803d;\n    }\n    #sgd-log-toggle:not(.active) {\n      background: #7f1d1d;\n      border: 1px solid #dc2626;\n      color: #fff;\n    }\n    #sgd-log-toggle:not(.active):hover {\n      background: #991b1b;\n    }\n\n    /* ── Status toast ────────────────────────────────────────────────── */\n    #sgd-status {\n      bottom       : 20px;\n      left         : 50%;\n      transform    : translateX(-50%);\n      background   : rgba(15,23,42,.90);\n      color        : #e2e8f0;\n      font-size    : 12px;\n      font-weight  : 500;\n      padding      : 6px 16px;\n      border-radius: 20px;\n      z-index      : 99999;\n      pointer-events: none;\n      opacity      : 0;\n      transition   : opacity .25s;\n      font-family  : -apple-system, BlinkMacSystemFont, \'Segoe UI\', sans-serif;\n      white-space  : nowrap;\n    }\n    #sgd-status.visible { opacity: 1; }\n    #sgd-status.ok  { color: #86efac; }\n    #sgd-status.err { color: #fca5a5; }\n  '),
    // ==================================================
    // 7. INTERVAL PREMIUM UNLOCKER
    // Continuously removes the 'disabled' attribute from premium buttons in the UI.
    // ==================================================
    setInterval(() => {
      const printEl = document.querySelector('[data-id^="Print--"]');
      printEl && printEl.setAttribute("data-id", "Print--plus"), document.querySelectorAll('svg use[href*="lock"]').forEach(use => {
        const svg = use.closest("svg"), parent = svg?.closest("button");
        svg && svg.remove(), parent && (parent.removeAttribute("disabled"), parent.classList.remove("Cny223"),
          parent.style.pointerEvents = "auto");
      }), PLUS_DATA_IDS.forEach(id => {
        const el = document.querySelector(`[data-id*="${id}"]`);
        el && el.hasAttribute("disabled") && (el.removeAttribute("disabled"), el.classList.remove("Cny223"),
          el.style.pointerEvents = "auto");
      });
      const autoscrollEl = document.querySelector('[data-id*="Auto-Scroll"]');
      autoscrollEl && autoscrollEl.hasAttribute("disabled") && (autoscrollEl.removeAttribute("disabled"),
        autoscrollEl.classList.remove("Cny223"), autoscrollEl.style.pointerEvents = "auto"),
        document.querySelectorAll("button.Cny223").forEach(btn => {
          btn.removeAttribute("disabled"), btn.classList.remove("Cny223"), btn.style.pointerEvents = "auto";
        });
    }, 1e3);
  const consoleErrorOrig = console.error, CONSOLE_FILTERS = ["AudioContext", "source-map", "unreachable", "buffer", "Secure-YEC", "Aborted", "401"];
  console.error = function (...args) {
    const message = String(args[0] || "");
    (!CONSOLE_FILTERS.some(f => message.includes(f)) || message.includes("Songsterr") || message.includes("SGD")) && consoleErrorOrig.apply(console, args);
  };
  // ==================================================
  // 8. GP7 & MIDI EXPORT: API & CDN FETCHERS
  // Downloads the raw track parts from Songsterr's AWS CloudFront CDN.
  // ==================================================
  const CDN_BASE = "https://dqsljvtekg760.cloudfront.net", CDN_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    Accept: "application/json, text/plain, */*",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept-Encoding": "gzip, deflate, br",
    "sec-ch-ua": '"Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"Windows"',
    "sec-fetch-site": "same-site",
    "sec-fetch-mode": "cors",
    "sec-fetch-dest": "empty",
    Referer: "https://www.songsterr.com/",
    Origin: "https://www.songsterr.com",
    Connection: "keep-alive",
    "Cache-Control": "no-cache",
    Pragma: "no-cache"
  };
  async function fetchMetaFromAPI(songId) {
    const url = `https://www.songsterr.com/api/meta/${songId}?allowOwnUnpublished=true`;
    return sgdLog("log", "SGD Debug", `Fetching fresh metadata from API: ${url}`), new Promise((resolve, reject) => {
      GM_xmlhttpRequest({
        method: "GET",
        url: url,
        headers: {
          Accept: "application/json",
          Referer: "https://www.songsterr.com/",
          Origin: "https://www.songsterr.com"
        },
        responseType: "json",
        onload: res => {
          res.status >= 200 && res.status < 300 ? (sgdLog("log", "SGD Debug", "✅ API metadata fetched successfully"),
            resolve(res.response)) : reject(new Error(`API returned ${res.status}`));
        },
        onerror: err => reject(new Error(`Network error: ${err}`))
      });
    });
  }
  function fetchRevisionJson(url) {
    return new Promise((resolve, reject) => {
      GM_xmlhttpRequest({
        method: "GET",
        url: url,
        headers: CDN_HEADERS,
        responseType: "json",
        onload: res => {
          res.status >= 200 && res.status < 300 ? resolve(res.response) : reject(new Error(`HTTP ${res.status} — ${url}`));
        },
        onerror: err => reject(new Error(`Network error: ${JSON.stringify(err)}`))
      });
    });
  }
  function buildRevisionUrl(songId, revisionId, image, partId, cdnBase = CDN_BASE) {
    return `${cdnBase}/${songId}/${revisionId}/${image}/${partId}.json`;
  }
  function mapDuration(dur) {
    const D = alphaTab.model.Duration, bases = [D.Whole, D.Half, D.Quarter, D.Eighth, D.Sixteenth, D.ThirtySecond, D.SixtyFourth];
    if (!dur?.[0] || !dur?.[1]) return {
      duration: D.Quarter,
      dots: 0
    };
    const target = dur[0] / dur[1];
    let best = {
      duration: D.Quarter,
      dots: 0
    }, bestDelta = 1 / 0;
    for (const base of bases) {
      const bv = 1 / Number(base);
      for (const dots of [0, 1, 2]) {
        const dv = bv + (dots >= 1 ? bv / 2 : 0) + (dots >= 2 ? bv / 4 : 0), delta = Math.abs(dv - target);
        delta < bestDelta && (bestDelta = delta, best = {
          duration: base,
          dots: dots
        });
      }
    }
    return best;
  }
  function mapInstrument(id) {
    return 1024 === id ? {
      program: 0,
      isPercussion: !0
    } : {
      program: "number" == typeof id ? Math.min(Math.max(id, 0), 127) : 24,
      isPercussion: !1
    };
  }
  function isDrumTrackByName(name) {
    return !!name && /drum|percussion|drums|kit|dm|perc\b/i.test(name);
  }
  const DRUM_NOTE_REMAP = {
    92: 42
  };
  let _percMap = null;
  const VELOCITY_MAP = {
    ppp: alphaTab.model.DynamicValue.PPP,
    pp: alphaTab.model.DynamicValue.PP,
    p: alphaTab.model.DynamicValue.P,
    mp: alphaTab.model.DynamicValue.MP,
    mf: alphaTab.model.DynamicValue.MF,
    f: alphaTab.model.DynamicValue.F,
    ff: alphaTab.model.DynamicValue.FF,
    fff: alphaTab.model.DynamicValue.FFF
  }, HARMONIC_MAP = {
    natural: alphaTab.model.HarmonicType.Natural,
    artificial: alphaTab.model.HarmonicType.Artificial,
    pinch: alphaTab.model.HarmonicType.Pinch,
    tap: alphaTab.model.HarmonicType.Tap,
    semi: alphaTab.model.HarmonicType.Semi,
    feedback: alphaTab.model.HarmonicType.Feedback
  };
  function mapNote(nd, isPerc, numStrings, beatPalmMute) {
    const note = new alphaTab.model.Note;
    if (note.string = isPerc ? -1 : numStrings - (nd.string ?? 0), note.fret = nd.fret ?? 0,
      isPerc && (note.percussionArticulation = function (midiNote) {
        _percMap || (_percMap = function () {
          const score = new alphaTab.model.Score, mb = new alphaTab.model.MasterBar;
          score.addMasterBar(mb);
          const track = new alphaTab.model.Track;
          track.playbackInfo.primaryChannel = 9, track.playbackInfo.secondaryChannel = 9;
          const staff = new alphaTab.model.Staff;
          staff.isPercussion = !0, track.addStaff(staff);
          const bar = new alphaTab.model.Bar, voice = new alphaTab.model.Voice, beat = new alphaTab.model.Beat;
          beat.isEmpty = !0, voice.addBeat(beat), bar.addVoice(voice), staff.addBar(bar),
            score.addTrack(track);
          const settings = new alphaTab.Settings;
          score.finish(settings);
          const data = (new alphaTab.exporter.Gp7Exporter).export(score, settings), reimported = alphaTab.importer.ScoreLoader.loadScoreFromBytes(data, settings), map = new Map;
          return reimported.tracks[0].percussionArticulations.forEach((a, i) => {
            map.has(a.id) || map.set(a.id, i);
          }), map;
        }());
        const remapped = DRUM_NOTE_REMAP[midiNote] ?? midiNote, idx = _percMap.get(remapped);
        return void 0 !== idx ? idx : (sgdLog("warn", "SGD", `Unknown perc MIDI note: ${midiNote}, remapping to Closed Hi-Hat (42)`),
          _percMap.get(42) ?? 0);
      }(nd.fret ?? 0)), nd.tie && (note.isTieDestination = !0), nd.dead && (note.isDead = !0),
      nd.ghost && (note.isGhost = !0), nd.hp && (note.isHammerPullOrigin = !0), nd.staccato && (note.isStaccato = !0),
      beatPalmMute && (note.isPalmMute = !0), nd.accentuated && (note.accentuated = alphaTab.model.AccentuationType.Normal),
      nd.wideVibrato ? note.vibrato = alphaTab.model.VibratoType.Wide : nd.vibrato && (note.vibrato = alphaTab.model.VibratoType.Slight),
      nd.harmonic) {
      const ht = HARMONIC_MAP[nd.harmonic.toLowerCase()];
      "number" == typeof ht && (note.harmonicType = ht, "number" == typeof nd.harmonicFret && (note.harmonicValue = nd.harmonicFret));
    }
    if (nd.slide) {
      const s = nd.slide.toLowerCase(), Out = alphaTab.model.SlideOutType, In = alphaTab.model.SlideInType;
      "shift" === s ? note.slideOutType = Out.Shift : "legato" === s ? note.slideOutType = Out.Legato : "into_from_below" === s || "below" === s ? note.slideInType = In.IntoFromBelow : "into_from_above" === s ? note.slideInType = In.IntoFromAbove : "out_up" === s ? note.slideOutType = Out.OutUp : "out_down" !== s && "downwards" !== s || (note.slideOutType = Out.OutDown);
    }
    if (nd.bend?.points?.length > 0) {
      note.bendType = alphaTab.model.BendType.Custom;
      for (const pt of nd.bend.points) note.addBendPoint(new alphaTab.model.BendPoint(Math.round(pt.position), Math.round(pt.tone / 25)));
    }
    return note;
  }
  function mapBeat(bd, masterBar, isPerc, numStrings) {
    const beat = new alphaTab.model.Beat;
    bd.rest && (beat.isEmpty = !0);
    const dur = mapDuration(bd.duration);
    if (beat.duration = dur.duration, beat.dots = bd.dots ?? dur.dots, bd.text && (beat.text = bd.text),
      "number" == typeof bd.tuplet && bd.tuplet > 1) {
      const [n, d] = function (t) {
        const map = {
          3: [3, 2],
          5: [5, 4],
          6: [6, 4],
          7: [7, 4],
          9: [9, 8],
          10: [10, 8],
          12: [12, 8]
        };
        return map[t] ? map[t] : t > 1 ? [t, Math.pow(2, Math.floor(Math.log2(t)))] : [1, 1];
      }(bd.tuplet);
      beat.tupletNumerator = n, beat.tupletDenominator = d, "number" == typeof bd.type && bd.type > 0 && (beat.duration = mapDuration([1, bd.type]).duration,
        beat.dots = bd.dots ?? 0);
    }
    if ("string" == typeof bd.velocity) {
      const dyn = VELOCITY_MAP[bd.velocity.toLowerCase()];
      "number" == typeof dyn && (beat.dynamics = dyn);
    }
    if ("string" == typeof bd.pickStroke) {
      const ps = bd.pickStroke.toLowerCase();
      "down" === ps ? beat.pickStroke = alphaTab.model.PickStroke.Down : "up" === ps && (beat.pickStroke = alphaTab.model.PickStroke.Up);
    }
    bd.wideVibrato || bd.vibratoWithTremoloBar ? beat.vibrato = alphaTab.model.VibratoType.Wide : bd.vibrato && (beat.vibrato = alphaTab.model.VibratoType.Slight);
    for (const nd of bd.notes || []) nd.rest || "number" != typeof nd.fret || beat.addNote(mapNote(nd, isPerc, numStrings, bd.palmMute));
    return beat;
  }
  function fillWithRests(voice, masterBar) {
    const num = masterBar.timeSignatureNumerator || 4, dur = mapDuration([1, masterBar.timeSignatureDenominator || 4]);
    for (let i = 0; i < num; i++) {
      const rest = new alphaTab.model.Beat;
      rest.isEmpty = !0, rest.duration = dur.duration, rest.dots = dur.dots, voice.addBeat(rest);
    }
  }
  function buildTrack(score, entry, masterBarCount, channel) {
    const { trackMeta: trackMeta, revision: revision } = entry, playback = mapInstrument(trackMeta.instrumentId ?? revision.instrumentId), isPerc = playback.isPercussion || !!trackMeta.isDrums || !!revision.isDrums || isDrumTrackByName(trackMeta.title) || isDrumTrackByName(trackMeta.name) || isDrumTrackByName(revision.name), trackBarCount = Math.max(masterBarCount, revision.measures?.length || 0), track = new alphaTab.model.Track;
    track.name = trackMeta.title || trackMeta.name || revision.name || "Track", track.shortName = track.name.slice(0, 20),
      track.playbackInfo.program = isPerc ? 0 : playback.program, track.playbackInfo.primaryChannel = channel,
      track.playbackInfo.secondaryChannel = channel;
    const staff = new alphaTab.model.Staff;
    staff.isPercussion = isPerc;
    const tuning = revision.tuning || trackMeta.tuning;
    Array.isArray(tuning) && tuning.length > 0 && !isPerc && (staff.stringTuning = new alphaTab.model.Tuning("Custom", tuning, !1));
    const numStrings = Array.isArray(tuning) ? tuning.length : 6;
    let maxVoiceCount = 1;
    for (let i = 0; i < trackBarCount; i++) {
      const m = revision.measures?.[i];
      maxVoiceCount = Math.max(maxVoiceCount, m?.voices?.length || 0);
    }
    for (let mi = 0; mi < trackBarCount; mi++) {
      const bar = new alphaTab.model.Bar, m = revision.measures?.[mi], mb = score.masterBars[Math.min(mi, score.masterBars.length - 1)], voices = m?.voices || [];
      if (voices && 0 !== voices.length) {
        let hasValidVoice = !1;
        for (const sv of voices) {
          const v = new alphaTab.model.Voice, bts = sv?.beats || [];
          if (!bts || 0 === bts.length || sv?.rest) fillWithRests(v, mb); else {
            for (const bd of bts) bd && v.addBeat(mapBeat(bd, 0, isPerc, numStrings));
            0 === v.beats.length && fillWithRests(v, mb);
          }
          v.beats.length > 0 && (hasValidVoice = !0), bar.addVoice(v);
        }
        if (!hasValidVoice && 0 === bar.voices.length) {
          const v = new alphaTab.model.Voice;
          fillWithRests(v, mb), bar.addVoice(v);
        }
        for (let vi = bar.voices.length; vi < maxVoiceCount; vi++) {
          const rv = new alphaTab.model.Voice;
          fillWithRests(rv, mb), bar.addVoice(rv);
        }
      } else {
        const v = new alphaTab.model.Voice;
        fillWithRests(v, mb), bar.addVoice(v);
      }
      staff.addBar(bar);
    }
    track.addStaff(staff), score.addTrack(track);
  }
  function buildScore(meta, revisions) {
    const score = new alphaTab.model.Score;
    score.title = meta.title, score.artist = meta.artist, score.tab = "Songsterr Ultimate v5.0.0";
    const masterRev = revisions.reduce((best, cur) => (cur.revision?.measures?.length || 0) > (best.revision?.measures?.length || 0) ? cur : best).revision, masterBarCount = Math.max(1, revisions.reduce((m, e) => Math.max(m, e.revision?.measures?.length || 0), 0));
    !function (score, masterRev, count) {
      let sigNum = 4, sigDen = 4;
      for (let i = 0; i < count; i++) {
        const m = masterRev?.measures?.[i], s = m?.signature;
        Array.isArray(s) && 2 === s.length && s[0] && s[1] && ([sigNum, sigDen] = s);
        const mb = new alphaTab.model.MasterBar;
        if (mb.timeSignatureNumerator = sigNum, mb.timeSignatureDenominator = sigDen, m?.marker) {
          const text = "string" == typeof m.marker ? m.marker : m.marker?.text || "", sec = new alphaTab.model.Section;
          sec.marker = sec.text = text, mb.section = sec;
        }
        m?.repeatStart && (mb.isRepeatStart = !0), "number" == typeof m?.repeatCount && m.repeatCount > 0 && (mb.repeatCount = m.repeatCount),
          "number" == typeof m?.alternateEnding && m.alternateEnding > 0 && (mb.alternateEndings = m.alternateEnding),
          score.addMasterBar(mb);
      }
      const tempo = masterRev?.automations?.tempo;
      if (Array.isArray(tempo)) for (const pt of tempo) {
        const mb = score.masterBars[pt.measure];
        if (!mb) continue;
        const ratio = pt.position > 0 ? Math.max(0, Math.min(1, pt.position / (pt.type || 4))) : 0;
        mb.tempoAutomations.push(alphaTab.model.Automation.buildTempoAutomation(!1, ratio, pt.bpm, 2, !0));
      }
    }(score, masterRev, masterBarCount);
    let nextChannel = 0;
    for (const entry of revisions) {
      let channel;
      mapInstrument(entry.trackMeta.instrumentId ?? entry.revision.instrumentId).isPercussion || entry.trackMeta.isDrums || entry.revision.isDrums || isDrumTrackByName(entry.trackMeta.title) || isDrumTrackByName(entry.trackMeta.name) || isDrumTrackByName(entry.revision.name) ? channel = 9 : (9 === nextChannel && nextChannel++,
        channel = nextChannel++), buildTrack(score, entry, masterBarCount, channel);
    }
    const settings = new alphaTab.Settings;
    return score.finish(settings), {
      score: score,
      settings: settings
    };
  }
  let _toastTimer = null, _toast = null;
  function showStatus(msg, type = "", duration = 4500) {
    const t = (_toast || (_toast = document.createElement("div"), _toast.id = "sgd-status",
      document.body.appendChild(_toast)), _toast);
    t.textContent = msg, t.className = "visible " + type, clearTimeout(_toastTimer),
      duration > 0 && (_toastTimer = setTimeout(() => {
        t.className = "";
      }, duration));
  }
  // ==================================================
  // 12. DOWNLOAD ORCHESTRATOR
  // Coordinates the fetching, parsing, conversion and file downloading process.
  // ==================================================
  async function handleDownload(format, btnGP, btnMID) {
    sgdLog("log", "SGD Debug", "========================================"), sgdLog("log", "SGD Debug", `DOWNLOAD STARTED: format=${format}`),
      sgdLog("log", "SGD Debug", `Current URL: ${location.href}`), sgdLog("log", "SGD Debug", `Current path: ${location.pathname}`),
      sgdLog("log", "SGD Debug", "========================================"), btnGP.disabled = !0,
      btnMID.disabled = !0, showStatus("⏳ Reading page state…", "", 0);
    try {
      sgdLog("log", "SGD Debug", "Step 1: Reading page state...");
      const meta = await async function () {
        sgdLog("log", "SGD Debug", "Reading page state..."), sgdLog("log", "SGD Debug", "Current URL:", location.href),
          sgdLog("log", "SGD Debug", "Current path:", location.pathname);
        const urlMatch = location.pathname.match(/-s(\d+)$/), urlSongId = urlMatch ? urlMatch[1] : null;
        if (sgdLog("log", "SGD Debug", "SongId from URL:", urlSongId), !urlSongId) throw new Error("Could not extract songId from URL");
        const el = document.getElementById("state");
        if (el) try {
          const parsed = JSON.parse(el.textContent || el.innerText), cur = parsed?.meta?.current;
          if (cur?.songId && String(cur.songId) === String(urlSongId) && cur?.revisionId && cur?.image) return sgdLog("log", "SGD Debug", "✅ Using fresh DOM state"),
            function (cur) {
              const result = {
                songId: cur.songId,
                revisionId: cur.revisionId,
                image: cur.image,
                title: cur.title || "Song",
                artist: cur.artist || "Unknown Artist",
                tracks: Array.isArray(cur.tracks) ? cur.tracks : []
              };
              return sgdLog("log", "SGD Debug", "✅ State validated and extracted:", {
                songId: result.songId,
                revisionId: result.revisionId,
                title: result.title,
                artist: result.artist,
                trackCount: result.tracks.length,
                image: result.image
              }), sgdLog("log", "SGD Debug", "Tracks:", result.tracks.map(t => ({
                partId: t.partId,
                title: t.title,
                instrumentId: t.instrumentId
              }))), result;
            }(cur);
        } catch (e) {
          sgdLog("warn", "SGD", "Failed to parse DOM state:", e.message);
        }
        sgdLog("log", "SGD Debug", "DOM state stale, fetching from API..."), showStatus("⏳ Fetching fresh song data...", "", 0);
        try {
          const apiData = await fetchMetaFromAPI(urlSongId);
          if (!apiData?.revisionId || !apiData?.songId) throw new Error("API response missing required fields");
          const cur = apiData;
          sgdLog("log", "SGD Debug", "✅ API data received:", {
            songId: urlSongId,
            title: cur.title,
            artist: cur.artist,
            revisionId: cur.revisionId
          });
          const result = {
            songId: parseInt(urlSongId),
            revisionId: cur.revisionId,
            image: cur.image || cur.imageId || "",
            title: cur.title || "Song",
            artist: cur.artist || "Unknown Artist",
            tracks: Array.isArray(cur.tracks) ? cur.tracks : []
          };
          return window.__SGD_REVISION_CACHE && cur.revisions && (manageCacheSize(), window.__SGD_REVISION_CACHE.set(String(urlSongId), cur),
            sgdLog("log", "SGD Debug", "Cached revision data for song:", urlSongId)), result;
        } catch (apiErr) {
          throw sgdLog("error", "SGD Debug", "API fetch failed:", apiErr.message), new Error(`Failed to get song data: ${apiErr.message}. Please refresh the page.`);
        }
      }();
      sgdLog("log", "SGD Debug", `Got metadata: ${meta.artist} - ${meta.title} (${meta.tracks.length} tracks)`),
        showStatus(`⏳ Fetching ${meta.tracks.length} track(s) from CDN…`, "", 0), sgdLog("log", "SGD Debug", "Step 2: Fetching revisions...");
      const revisions = await async function (meta) {
        const { songId: songId, revisionId: revisionId, image: image, tracks: tracks } = meta;
        sgdLog("log", "SGD Debug", `fetchAllRevisions called: songId=${songId}, revisionId=${revisionId}, image=${image}`),
          sgdLog("log", "SGD Debug", `Total tracks in meta: ${tracks.length}`), tracks.length > 0 && (sgdLog("log", "SGD Debug", "First track keys:", Object.keys(tracks[0])),
            sgdLog("log", "SGD Debug", "First track:", JSON.stringify(tracks[0], null, 2).substring(0, 300)));
        const validTracks = tracks.map((t, idx) => ({
          ...t,
          partId: t.partId ?? idx
        })).filter(t => "number" == typeof t.partId).sort((a, b) => a.partId - b.partId);
        if (sgdLog("log", "SGD Debug", `Valid tracks (with partId): ${validTracks.length}`),
          validTracks.forEach(t => sgdLog("log", "SGD Debug", `Track: partId=${t.partId}, title=${t.title}`)),
          0 === validTracks.length) throw new Error("No valid tracks found in page metadata.");
        const cacheAvailable = window.__SGD_REVISION_CACHE && window.__SGD_REVISION_CACHE.size > 0;
        sgdLog("log", "SGD Debug", `API cache available: ${cacheAvailable}`);
        let cacheHits = 0, cdnHits = 0, failures = 0;
        const revisions = (await Promise.all(validTracks.map(async track => {
          if (sgdLog("log", "SGD Debug", `Processing track partId=${track.partId}`), cacheAvailable) {
            const cachedRevision = function (songId, revisionId, partId) {
              const cache = window.__SGD_REVISION_CACHE;
              if (sgdLog("log", "SGD Debug", `Cache lookup for songId=${songId}, revisionId=${revisionId}, partId=${partId}`),
                sgdLog("log", "SGD Debug", `Cache exists: ${!!cache}, Cache size: ${cache ? cache.size : 0}`),
                !cache || 0 === cache.size) return sgdLog("log", "SGD Debug", "Cache empty, skipping"),
                  null;
              const cachedData = cache.get(String(songId));
              if (!cachedData) return sgdLog("log", "SGD Debug", `No cached data for songId=${songId}. Available keys:`, Array.from(cache.keys())),
                null;
              if (sgdLog("log", "SGD Debug", `Found cached data for songId=${songId}, keys:`, Object.keys(cachedData)),
                cachedData.revisions && Array.isArray(cachedData.revisions)) {
                sgdLog("log", "SGD Debug", `Looking in cachedData.revisions (${cachedData.revisions.length} items)`);
                const revision = cachedData.revisions.find(r => String(r.revisionId || r.id) === String(revisionId));
                if (revision) return sgdLog("log", "SGD Debug", "Found revision in cachedData.revisions"),
                  revision;
              }
              if (cachedData.revision) return sgdLog("log", "SGD Debug", "Found revision in cachedData.revision"),
                cachedData.revision;
              if (cachedData.tracks && Array.isArray(cachedData.tracks)) {
                sgdLog("log", "SGD Debug", `Looking in cachedData.tracks (${cachedData.tracks.length} items)`);
                const track = cachedData.tracks.find(t => t.partId === partId);
                if (track && track.revision) return sgdLog("log", "SGD Debug", `Found revision in track.partId=${partId}`),
                  track.revision;
              }
              return sgdLog("log", "SGD Debug", `No revision found in cache for partId=${partId}`),
                null;
            }(songId, revisionId, track.partId);
            if (cachedRevision) return cacheHits++, sgdLog("log", "SGD Debug", `✅ CACHE HIT for partId=${track.partId}`),
            {
              trackMeta: track,
              revision: cachedRevision
            };
          }
          sgdLog("log", "SGD Debug", `Cache miss, trying CDN for partId=${track.partId}`);
          try {
            const revision = await async function (songId, revisionId, image, partId) {
              const primaryUrl = buildRevisionUrl(songId, revisionId, image, partId, CDN_BASE), fallbackUrl = buildRevisionUrl(songId, revisionId, image, partId, "https://d3d3l6a6rcgkaf.cloudfront.net");
              try {
                return await fetchRevisionJson(primaryUrl);
              } catch (primaryError) {
                sgdLog("warn", "SGD", `Primary CDN failed for part ${partId}, trying fallback...`);
              }
              try {
                const response = await fetchRevisionJson(fallbackUrl);
                return sgdLog("log", "SGD", `Fallback CDN succeeded for part ${partId}`), response;
              } catch (fallbackError) {
                throw new Error(`Both CDNs failed for part ${partId}`);
              }
            }(songId, revisionId, image, track.partId);
            return cdnHits++, sgdLog("log", "SGD Debug", `✅ CDN SUCCESS for partId=${track.partId}`),
            {
              trackMeta: track,
              revision: revision
            };
          } catch (err) {
            return failures++, sgdLog("warn", "SGD Debug", `❌ FAILED for partId=${track.partId}:`, err.message),
              null;
          }
        }))).filter(Boolean);
        if (sgdLog("log", "SGD Debug", `Fetch complete: ${revisions.length}/${validTracks.length} tracks`),
          sgdLog("log", "SGD Debug", `Stats: cacheHits=${cacheHits}, cdnHits=${cdnHits}, failures=${failures}`),
          0 === revisions.length) throw new Error("Could not fetch any track data. Both CDNs returned errors and no API data was intercepted. Try refreshing the page and playing the tab to populate the cache.");
        return revisions;
      }(meta);
      sgdLog("log", "SGD Debug", `Got ${revisions.length} revisions`), revisions.forEach((r, i) => {
        sgdLog("log", "SGD Debug", `Revision ${i}: track="${r.trackMeta.title}", measures=${r.revision?.measures?.length || 0}`);
      }), showStatus(`⚙️ Converting ${revisions.length} track(s) → ${format.toUpperCase()}…`, "", 0),
        sgdLog("log", "SGD Debug", "Step 3: Building and exporting...");
      const name = `${meta.artist} - ${meta.title}`.replace(/[^a-zA-Z0-9 _\-]/g, "").trim().replace(/\s+/g, "_") || "tab";
      let bytes, fileName, mime;
      sgdLog("log", "SGD Debug", `Sanitized filename: ${name}`), "gp" === format ? (sgdLog("log", "SGD Debug", "Exporting as GP7..."),
        bytes = function (meta, revisions) {
          const { score: score, settings: settings } = buildScore(meta, revisions);
          return (new alphaTab.exporter.Gp7Exporter).export(score, settings);
        }(meta, revisions), fileName = `${name}.gp`, mime = "application/gp") : (sgdLog("log", "SGD Debug", "Exporting as MIDI..."),
          bytes = function (meta, revisions) {
            const { score: score, settings: settings } = buildScore(meta, revisions), midiFile = new alphaTab.midi.MidiFile, handler = new alphaTab.midi.AlphaSynthMidiFileHandler(midiFile, !0);
            return new alphaTab.midi.MidiFileGenerator(score, settings, handler).generate(),
              midiFile.toBinary();
          }(meta, revisions), fileName = `${name}.mid`, mime = "audio/midi"), sgdLog("log", "SGD Debug", `Export complete: ${bytes.length} bytes`),
        sgdLog("log", "SGD Debug", "Step 4: Triggering download..."), function (bytes, fileName, mime) {
          const blob = new Blob([bytes], {
            type: mime
          }), url = URL.createObjectURL(blob), a = document.createElement("a");
          a.href = url, a.download = fileName, document.body.appendChild(a), a.click(), document.body.removeChild(a),
            URL.revokeObjectURL(url);
        }(bytes, fileName, mime), sgdLog("log", "SGD Debug", `✅ Download triggered: ${fileName}`),
        showStatus(`✅ "${fileName}" downloaded!`, "ok");
    } catch (err) {
      sgdLog("error", "SGD Debug", "❌ Download failed:", err), sgdLog("error", "SGD Debug", "Error stack:", err.stack),
        showStatus(`❌ ${err.message}`, "err", 7e3);
    } finally {
      btnGP.disabled = !1, btnMID.disabled = !1, sgdLog("log", "SGD Debug", "========================================\n");
    }
  }
  let _isPageTransitioning = !1, _injectionTimeout = null;
  // ==================================================
  // 11. UI INJECTION OBSERVER
  // Debounces UI injection to wait for Songsterr React app to be ready.
  // ==================================================
  function debouncedInjection() {
    _injectionTimeout && clearTimeout(_injectionTimeout), _injectionTimeout = setTimeout(() => {
      !function () {
        if (!/\/a\/wsa\/.+/.test(location.pathname)) return !1;
        if (document.getElementById("sgd-wrapper")?.isConnected) return !0;
        const cExport = document.getElementById("c-export");
        if (cExport) return cExport.replaceWith(createOurButtons()), sgdLog("log", "SGD", "✅ Injected (#c-export)"),
          !0;
        const ctrlExport = document.getElementById("control-export");
        if (ctrlExport) return (ctrlExport.closest("div") || ctrlExport.parentElement).replaceWith(createOurButtons()),
          sgdLog("log", "SGD", "✅ Injected (#control-export parent)"), !0;
        const nativeBtn = document.querySelector('[data-id*="Download"], [data-id*="Export"], [title*="Download tab"]');
        nativeBtn && ((nativeBtn.closest("div") || nativeBtn.parentElement).replaceWith(createOurButtons()),
          sgdLog("log", "SGD", "✅ Injected (fallback title/data-id)"));
      }(), _injectionTimeout = null;
    }, 100);
  }
  // ==================================================
  // 10. UI BUTTONS CREATION
  // Creates the Download GP7, MIDI and YT Audio Toggle buttons.
  // ==================================================
  function createOurButtons() {
    const wrapper = document.createElement("div");
    wrapper.id = "sgd-wrapper", wrapper.className = "B3a4pa B3agq5";
    let ytAudioOnlyMode = !1;
    try {
      ytAudioOnlyMode = "true" === localStorage.getItem("songsterr_yt_audio_only");
    } catch (e) { }
    const btnYT = document.createElement("button");
    btnYT.id = "yt-toggle-btn", btnYT.innerHTML = ytAudioOnlyMode ? "🎵" : "🎬", btnYT.title = ytAudioOnlyMode ? "Audio-only mode (click to show video)" : "Video visible (click for audio-only)",
      ytAudioOnlyMode && btnYT.classList.add("audio-only"), btnYT.addEventListener("click", () => {
        "function" == typeof toggleYtAudioOnly && toggleYtAudioOnly();
      });
    const btnGP = document.createElement("button");
    btnGP.className = "sgd-btn sgd-btn-gp", btnGP.innerHTML = "🎸 GP7", btnGP.title = "Download Guitar Pro 7 (.gp)";
    const btnMID = document.createElement("button");
    btnMID.className = "sgd-btn sgd-btn-midi", btnMID.innerHTML = "🎹 MIDI", btnMID.title = "Download MIDI (.mid)";
    const canDownload = () => !_isPageTransitioning || (showStatus("⏳ Page loading, please wait...", "", 2e3),
      !1);
    return btnGP.addEventListener("click", () => {
      canDownload() && handleDownload("gp", btnGP, btnMID);
    }), btnMID.addEventListener("click", () => {
      canDownload() && handleDownload("midi", btnGP, btnMID);
    }), wrapper.appendChild(btnYT), wrapper.appendChild(btnGP), wrapper.appendChild(btnMID),
      wrapper;
  }
  const btnObserver = new MutationObserver(() => {
    document.getElementById("sgd-wrapper")?.isConnected || debouncedInjection();
  });
  let _lastSongPath = location.pathname;
  // ==================================================
  // 13. SPA ROUTING HOOK
  // Handles Songsterr single-page-app navigation events to clean cache.
  // ==================================================
  function onSpaNavigate() {
    const currentPath = location.pathname;
    if (sgdLog("log", "SGD Debug", "SPA Navigation detected:", {
      from: _lastSongPath,
      to: currentPath
    }), currentPath !== _lastSongPath && (_isPageTransitioning = !0, sgdLog("log", "SGD Debug", "🚫 Page transition started, downloads blocked")),
      currentPath !== _lastSongPath) if (window.__SGD_REVISION_CACHE) {
        const oldSize = window.__SGD_REVISION_CACHE.size;
        window.__SGD_REVISION_CACHE.clear(), sgdLog("log", "SGD Debug", `✅ Cache cleared (${oldSize} entries) - song changed`);
      } else sgdLog("log", "SGD Debug", "No cache to clear"); else sgdLog("log", "SGD Debug", "Same path, cache preserved");
    _lastSongPath = currentPath, debouncedInjection(), setTimeout(() => debouncedInjection(), 500),
      setTimeout(() => debouncedInjection(), 1200), async function () {
        const urlMatch = location.pathname.match(/-s(\d+)$/), urlSongId = urlMatch ? urlMatch[1] : null;
        if (!urlSongId) return void (_isPageTransitioning = !1);
        const el = document.getElementById("state");
        if (el) try {
          const parsed = JSON.parse(el.textContent || el.innerText), cur = parsed?.meta?.current;
          if (String(cur?.songId) === String(urlSongId)) return _isPageTransitioning = !1,
            void sgdLog("log", "SGD Debug", "✅ Page ready (DOM), downloads enabled");
        } catch (e) {
          sgdLog("warn", "SGD", "Failed to parse DOM state during ready check:", e.message);
        }
        sgdLog("log", "SGD Debug", "DOM stale, checking via API...");
        try {
          const apiData = await fetchMetaFromAPI(urlSongId);
          sgdLog("log", "SGD Debug", "API response received, unblocking downloads"), apiData?.revisionId ? (_isPageTransitioning = !1,
            sgdLog("log", "SGD Debug", "✅ Page ready (API), downloads enabled"), showStatus("✅ Ready to download!", "ok", 1500)) : sgdLog("log", "SGD Debug", "❌ API response missing revisionId");
        } catch (err) {
          sgdLog("log", "SGD Debug", "API check failed:", err.message);
        }
      }();
  }
  const _pushState = history.pushState.bind(history);
  history.pushState = function (...a) {
    _pushState(...a), onSpaNavigate();
  };
  const _replaceState = history.replaceState.bind(history);
  history.replaceState = function (...a) {
    _replaceState(...a), onSpaNavigate();
  }, window.addEventListener("popstate", onSpaNavigate), function () {
    const go = () => {
      btnObserver.observe(document.body, {
        childList: !0,
        subtree: !0
      }), debouncedInjection();
    };
    document.body ? go() : document.addEventListener("DOMContentLoaded", go);
  }();
}();
