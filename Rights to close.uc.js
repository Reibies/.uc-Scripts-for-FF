// ==UserScript==
// @name            Rights to close JS
// @namespace       Reibies
// @include         main
// @version         1
// @description     Double right-click on page to close the current tab
// ==/UserScript==

(function() {
  var lastClickTime = {};
  var delay = 300;

  document.addEventListener('contextmenu', function(e) {
    var tab = gBrowser.selectedTab;
    var tabId = tab.id;

    if (lastClickTime[tabId] && new Date().getTime() - lastClickTime[tabId] < delay) {
      delete lastClickTime[tabId];
      gBrowser.removeTab(tab);
    } else {
      lastClickTime[tabId] = new Date().getTime();
    }
  }, false);
})();
