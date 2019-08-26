class ChatRoomsController < ApplicationController
  skip_after_action :verify_policy_scoped


  def show
    @chat_room = ChatRoom.includes(messages: :user).find(params[:id])
    authorize @chat_room
  end
end
