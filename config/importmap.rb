# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "local-time", to: "https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js" #original
pin "@popperjs/core", to: "http://unpkg.com/@popperjs/core@2.11.6/dist/esm/index.js"

#pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2"
#pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
#https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js

#pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.js" #Aqui viene corregido el error del dropdown pero no viene el MODAL
