# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.nil?
        flash[:alert] = I18n.t "errors.messages.user_not_registered"
        redirect_to "/"
      elsif @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
        sign_in_and_redirect @user, event: :authentication
      else
        flash[:alert] = I18n.t "errors.messages.user_not_registered"
        redirect_to "/"
      end
    end
  end
end
