# config/importmap.rb

pin "application"
pin "@hotwired/turbo-rails", to: "https://cdn.jsdelivr.net/npm/@hotwired/turbo-rails@7.0.0/dist/turbo.min.js"
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.0.0/dist/stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "https://cdn.jsdelivr.net/npm/@hotwired/stimulus-loading@1.0.0/dist/stimulus-loading.js"
pin "rails-ujs", to: "https://cdn.jsdelivr.net/npm/rails-ujs@7.0.0/dist/rails-ujs.js"
pin_all_from "app/javascript/controllers", under: "controllers"
