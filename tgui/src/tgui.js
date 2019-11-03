// Temporarily import Ractive first to keep it from detecting ie8's object.defineProperty shim, which it misuses (ractivejs/ractive#2343).
import Ractive from "ractive";
Ractive.DEBUG = /minified/.test(() => {
  /* minified */
});

import "ie8";
import "babel-polyfill";
import "dom4";
import "html5shiv";

// Extend the Math builtin with our own utilities.
Object.assign(Math, require("util/math"));

// Set up the initialize function. This is either called below if JSON is provided
// inline, or called by the server if it was not.
import TGUI from "tgui.ract";

// This thing was a part of an old index.html
window.update = window.initialize = dataString => {
  const data = JSON.parse(dataString);
  // Initialize
  if (!window.tgui) {
    window.tgui = new TGUI({
      el: "#container",
      data() {
        const initial = data;
        return {
          constants: require("util/constants"),
          text: require("util/text"),
          config: initial.config,
          data: initial.data,
          adata: initial.data
        };
      }
    });
  }
  // Update
  if (window.tgui) {
    window.tgui.set("config", data.config);
    if (typeof data.data !== "undefined") {
      window.tgui.set("data", data.data);
      window.tgui.animate("adata", data.data);
    }
  }
};

// Try to find data in the page. If the JSON was inlined, load it.
const holder = document.getElementById("data");
const data = holder.textContent;
const ref = holder.getAttribute("data-ref");
if (data !== "{}") {
  window.initialize(data);
  holder.remove();
}

// Let the server know we're set up.
// This also sends data if it was not inlined.
// NOTE: This is currently handled by tgui-next. Only initialize if
// we were loaded by tgui-fallback.html.
import { act } from "util/byond";
import { loadCSS } from "fg-loadcss";

// hippie -- Yogs Key passthrough - so you can still do spaceman things when focused on a browser window

if (document.addEventListener && window.location) {
  // hey maybe some bozo is still using mega-outdated IE
  let anti_spam = []; // wow I wish I could use e.repeat but IE is dumb and doesn't have it.
  document.addEventListener("keydown", function(e) {
    if (
      e.target &&
      (e.target.localName == "input" || e.target.localName == "textarea")
    )
      return;
    if (e.defaultPrevented) return; // do e.preventDefault() to prevent this behavior.
    if (e.which) {
      if (!anti_spam[e.which]) {
        anti_spam[e.which] = true;
        window.location.href = "?__keydown=" + e.which;
      }
    }
  });
  document.addEventListener("keyup", function(e) {
    if (
      e.target &&
      (e.target.localName == "input" || e.target.localName == "textarea")
    )
      return;
    if (e.defaultPrevented) return;
    if (e.which) {
      anti_spam[e.which] = false;
      window.location.href = "?__keyup=" + e.which;
    }
  });
}

// hippie end

if (window.tguiFallback) {
  act(ref, "tgui:initialize");
  // Load fonts.
  loadCSS("v4shim.css");
  loadCSS("font-awesome.css");
} else {
  act(ref, "tgui:update");
}
