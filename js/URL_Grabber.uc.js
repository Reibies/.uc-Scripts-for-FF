// ==UserScript==
// @name            URL Grabber
// @namespace       Reibies
// @version         1
// @description     Right click the URL to auto copy it.
// ==/UserScript==

// Define a function to copy the current URL to clipboard
function copyCurrentURL() {
    var url = window.gBrowser.currentURI.spec;
    var clipboard = Components.classes["@mozilla.org/widget/clipboardhelper;1"].getService(Components.interfaces.nsIClipboardHelper);
    clipboard.copyString(url);
}

// Add a listener to the URL bar
var urlbar = document.getElementById("urlbar");
urlbar.addEventListener("contextmenu", copyCurrentURL, false);
