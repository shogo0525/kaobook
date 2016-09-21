class ConversationsController < ApplicationController
	before_action :authenticate_user!


	def index
		@friend_users = current_user.friend
		@conversations = Conversation.all
	end

	def create
	  if Conversation.between(params[:sender_id], params[:recipient_id]).present?
	    @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
	  else
	    @conversation = Conversation.create!(conversation_params)
	  end

	  redirect_to conversation_messages_path(@conversation)
	end

=begin
  def index
    @friend_users = current_user.friend
    @conversation = Conversation.new
  end

  def create
    if find_conversation
      redirect_to conversation_messages_path(find_conversation)
    else
      @conversation = Conversation.new(conversation_params)
      @conversation.sender_id = current_user.id
      @conversation.save
      redirect_to conversation_messages_path(@conversation)
    end
  end
=end

	private
	  def conversation_params
	    params.permit(:sender_id, :recipient_id)
	  end

	  def find_conversation
	    sender = Conversation.find_by(sender_id: current_user.id, recipient_id: params[:conversation][:recipient_id])
	    recipient = Conversation.find_by(sender_id: params[:conversation][:recipient_id] ,recipient_id: current_user.id)
	    conversation = sender || recipient
	  end
end
