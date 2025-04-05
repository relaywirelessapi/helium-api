# typed: false

class ApplicationController < ActionController::Base
  extend T::Sig

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  sig { params(resource_or_scope: T.untyped).returns(String) }
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
