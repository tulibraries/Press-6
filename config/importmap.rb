# frozen_string_literal: true

pin "application", preload: "application"
pin "jquery" # @4.0.0
pin "bootstrap" # @5.3.8
pin "selectize", to: "selectize.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "trix" # @2.1.18
pin "hotkeys-js" # @4.0.3
pin "stimulus-use" # @0.52.3

pin "controllers", to: "controllers/index.js"
pin "jumble", to: "src/jumble.js"
pin "administrate-trix", to: "src/administrate-trix.js"
pin "legacy-libs", to: "src/legacy-libs.js"
pin "src/jquery", to: "src/jquery.js"
pin "src/common-libs", to: "src/common-libs.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
