class AvatarsController < ApplicationController

  def index
    @avatars = Avatar.all
  end
end
