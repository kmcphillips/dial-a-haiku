class HomeController < ApplicationController
  def index
    render plain: "Dial-a-Haiku"
  end
end
