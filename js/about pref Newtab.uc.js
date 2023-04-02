// ==UserScript==
// @name            Start+Newtab in about:preferences#home
// @namespace       Reibies
// @version         1
// @description     Paste custom file:/// link into about:pref
// ==/UserScript==



(function () {
    const DEFAULT_NEW_TAB_URL = "about:newtab";
    var newTabURL = DEFAULT_NEW_TAB_URL;
    var prefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("");
  
    try {
      newTabURL = prefBranch.getCharPref("browser.newtab.url");
    } catch (e) {
      console.error("Error retrieving browser.newtab.url preference: " + e);
    }
  
    if (!newTabURL || newTabURL.trim() == "") {
      newTabURL = DEFAULT_NEW_TAB_URL;
    }
  
    function customNewTab() {
      var urlbar = window.document.getElementById("urlbar");
  
      if (urlbar && urlbar.getAttribute("focused") == "true") {
        urlbar.removeAttribute("focused");
      }
  
      if (urlbar && newTabURL.startsWith("file:///") && newTabURL.includes("/")) {
        var fileURI = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI(newTabURL, null, null);
        var fileURL = Components.classes["@mozilla.org/network/protocol;1?name=file"].createInstance(Components.interfaces.nsIFileProtocolHandler).getURLSpecFromFile(fileURI.QueryInterface(Components.interfaces.nsIFileURL).file);
        urlbar.value = fileURL + (fileURL.endsWith("/") ? "" : "/");
      }
    }
  
    AboutNewTab.newTabURL = newTabURL;
    gBrowser.tabContainer.addEventListener("TabOpen", customNewTab, false);
  })();
  