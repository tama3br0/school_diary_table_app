# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "controllers", to: "controllers.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Chart.js と日付アダプターのピン
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"
pin "chartjs-adapter-date-fns", to: "https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@2.0.0"
