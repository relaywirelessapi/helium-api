# typed: false

module Users
  class RegistrationsController < Devise::RegistrationsController
    extend T::Sig

  protected

  sig { params(resource: User).returns(String) }
    def after_inactive_sign_up_path_for(resource)
      new_user_session_path
    end
  end
end
