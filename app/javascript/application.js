// app/javascript/application.js

import { Turbo } from "@hotwired/turbo-rails"  // Import Turbo for Hotwire
import "rails-ujs"  // Import rails-ujs for method override handling
import "controllers"  // Automatically load all Stimulus controllers

// Initialize rails-ujs (if it's not done automatically)
document.addEventListener("DOMContentLoaded", () => {
  Rails.start();  // Starts rails-ujs functionality
});
