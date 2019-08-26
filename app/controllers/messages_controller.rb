class MessagesController < ApplicationController
  skip_after_action :verify_policy_scoped
  def create
    @message = Message.new(message_params)
    authorize @message
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message.chat_room = @chat_room
    @message.user = current_user
    if @message.save
    #   ActionCable.server.broadcast("chat_room_#{@chat_room.id}", {
    #   message_partial: render(partial: "messages/message", locals: {message: @message, user_is_messages_author: false})
    # })
      respond_to do |format|
        format.html { redirect_to chat_room_path(@chat_room) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render "chat_rooms/show" }
        format.js
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :chat_room_id, :user_id)
  end
end
