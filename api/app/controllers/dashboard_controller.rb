# typed: strict

class DashboardController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!

  sig { void }
  def show
  end
end
