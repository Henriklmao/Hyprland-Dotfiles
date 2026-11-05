// Firefox prefs for the minimal qutebrowser-like UI.
// user.js is applied on every startup, so keep this list short and UI-only.

// Load chrome/userChrome.css and chrome/userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Compact density, slim tab strip
user_pref("browser.uidensity", 1);
user_pref("browser.compactmode.show", true);

// Tabs live in the titlebar (one single top bar)
user_pref("browser.tabs.inTitlebar", 1);

// Narrow tabs and no space reserved for a close button
user_pref("browser.tabs.tabMinWidth", 60);
user_pref("browser.tabs.tabClipWidth", 60);

// Closing the last tab keeps the window open (qutebrowser-like)
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // omarchy-firefox-mode
