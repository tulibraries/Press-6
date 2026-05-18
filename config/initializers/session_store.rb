# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: "_tupress_session", expire_after: 1.day
