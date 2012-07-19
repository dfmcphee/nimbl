class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @tasks = current_user.tasks
  end
end
