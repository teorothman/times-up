class PlayerChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    player = User.find(params[:id])
    stream_for player
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
