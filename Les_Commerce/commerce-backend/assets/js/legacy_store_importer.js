/**
 * Legacy Store Importer
 * 
 * This module handles the client-side functionality for importing legacy stores.
 * It provides functions to validate URLs, initiate the import process, and
 * display the import progress.
 */

const LegacyStoreImporter = {
  /**
   * Initialize the legacy store importer
   * @param {Object} options - Configuration options
   */
  init(options = {}) {
    this.options = {
      importButtonSelector: '[phx-click="import_legacy_store"]',
      urlInputSelector: 'input[name="legacy_store_url"]',
      progressContainerSelector: '#import-progress',
      ...options
    };
    
    this.bindEvents();
  },
  
  /**
   * Bind event listeners to DOM elements
   */
  bindEvents() {
    document.addEventListener('click', (event) => {
      // Check if the clicked element is the import button
      if (event.target.matches(this.options.importButtonSelector) || 
          event.target.closest(this.options.importButtonSelector)) {
        event.preventDefault();
        
        // Get the URL from the input field
        const urlInput = document.querySelector(this.options.urlInputSelector);
        if (urlInput && urlInput.value) {
          this.importStore(urlInput.value);
        } else {
          this.showError('Please enter a valid store URL');
        }
      }
    });
  },
  
  /**
   * Validate a URL
   * @param {string} url - The URL to validate
   * @returns {boolean} - Whether the URL is valid
   */
  validateUrl(url) {
    try {
      const parsedUrl = new URL(url);
      return ['http:', 'https:'].includes(parsedUrl.protocol);
    } catch (e) {
      return false;
    }
  },
  
  /**
   * Import a legacy store
   * @param {string} url - The URL of the legacy store
   */
  importStore(url) {
    // Validate the URL
    if (!this.validateUrl(url)) {
      this.showError('Please enter a valid URL (e.g., https://your-store.com)');
      return;
    }
    
    // Show loading state
    this.showLoading();
    
    // Send the import request to the server
    fetch('/api/legacy-store/import', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.getCsrfToken()
      },
      body: JSON.stringify({ url })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Redirect to the progress page
        window.location.href = `/legacy-store/import/progress/${data.store_id}`;
      } else {
        this.showError(data.error || 'Failed to import store');
      }
    })
    .catch(error => {
      console.error('Error importing store:', error);
      this.showError('An error occurred while importing the store');
    })
    .finally(() => {
      this.hideLoading();
    });
  },
  
  /**
   * Show a loading indicator
   */
  showLoading() {
    const button = document.querySelector(this.options.importButtonSelector);
    if (button) {
      button.disabled = true;
      button.innerHTML = '<svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Importing...';
    }
  },
  
  /**
   * Hide the loading indicator
   */
  hideLoading() {
    const button = document.querySelector(this.options.importButtonSelector);
    if (button) {
      button.disabled = false;
      button.textContent = 'Import';
    }
  },
  
  /**
   * Show an error message
   * @param {string} message - The error message to display
   */
  showError(message) {
    // Create a flash message element
    const flashContainer = document.createElement('div');
    flashContainer.className = 'fixed top-4 right-4 z-50 max-w-sm';
    
    const flashMessage = document.createElement('div');
    flashMessage.className = 'bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-md';
    flashMessage.innerHTML = `
      <div class="flex items-center">
        <div class="py-1">
          <svg class="h-6 w-6 text-red-500 mr-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <div>
          <p class="font-medium">${message}</p>
        </div>
      </div>
    `;
    
    flashContainer.appendChild(flashMessage);
    document.body.appendChild(flashContainer);
    
    // Remove the flash message after 5 seconds
    setTimeout(() => {
      flashContainer.remove();
    }, 5000);
  },
  
  /**
   * Get the CSRF token from the meta tag
   * @returns {string} - The CSRF token
   */
  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
  }
};

// Initialize the legacy store importer when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  LegacyStoreImporter.init();
});

export default LegacyStoreImporter;
