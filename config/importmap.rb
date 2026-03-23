# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "ticket_toggle", to: "ticket_toggle.js"
#これがあることで、ticket_toggle.jsの場所を指定している。これがないと、application.jsでimportしても、ticket_toggle.jsが見つからないため、エラーになる。