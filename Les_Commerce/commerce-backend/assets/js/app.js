// Import Phoenix's client library
import "phoenix_html";
import {Socket} from "phoenix";
import {LiveSocket} from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Import custom modules
import LegacyStoreImporter from "./legacy_store_importer";
import Hooks from "./hooks";

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"});
window.addEventListener("phx:page-loading-start", _info => topbar.show(300));
window.addEventListener("phx:page-loading-stop", _info => topbar.hide());

// Define custom DOM events to interact with LiveView
const domHooks = {
  mounted() {
    // Flash messages auto-hide
    const flashMessages = document.querySelectorAll(".alert-dismissible");
    flashMessages.forEach(message => {
      setTimeout(() => {
        message.classList.add("opacity-0");
        setTimeout(() => message.remove(), 500);
      }, 4000);
    });
  }
};

// Connect if there are any LiveViews on the page
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      // Keep focus on form inputs when LiveView updates
      if (from.hasAttribute("phx-focused") && document.activeElement === from) {
        to.setAttribute("phx-focused", true);
        window.requestAnimationFrame(() => to.focus());
      }
      
      // Preserve scroll position in infinite scroll elements
      if (from.getAttribute("data-scroll-preserve") !== null) {
        const scrollTop = from.scrollTop;
        window.requestAnimationFrame(() => to.scrollTop = scrollTop);
      }
      
      // Initialize third-party libraries on new elements
      if (to.getAttribute("data-initialize-js") !== null) {
        window.requestAnimationFrame(() => initializeThirdPartyLibraries(to));
      }
      
      return true;
    }
  }
});

// Custom event handlers for LiveView
window.addEventListener("phx:add-to-cart", (e) => {
  const { productId, productName } = e.detail;
  
  // Show toast notification
  const toast = document.createElement("div");
  toast.className = "fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg transform transition-transform duration-500 ease-in-out";
  toast.innerHTML = `<div class="flex items-center"><svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> ${productName} added to cart</div>`;
  document.body.appendChild(toast);
  
  // Animate toast in and out
  setTimeout(() => toast.classList.add("translate-y-2"), 100);
  setTimeout(() => {
    toast.classList.remove("translate-y-2");
    toast.classList.add("-translate-y-full");
    setTimeout(() => toast.remove(), 500);
  }, 3000);
});

// Function to initialize third-party libraries
function initializeThirdPartyLibraries(element) {
  // Initialize tooltips
  if (element.querySelectorAll("[data-tooltip]").length > 0) {
    // Tooltip initialization code would go here
  }
  
  // Initialize any other third-party libraries as needed
}

// Connect to the server
liveSocket.connect();

// Initialize custom modules
document.addEventListener("DOMContentLoaded", () => {
  // Initialize the legacy store importer
  LegacyStoreImporter.init();
  
  // Initialize any global JS functionality
  domHooks.mounted();
});

// Make LiveSocket available for debugging in browser console
window.liveSocket = liveSocket;
