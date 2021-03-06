class TopicsController < ApplicationController
  before_action :authenticate_user!
	before_action :set_topic, only:[:show, :edit, :update, :destroy]

  def index
  	@topic = Topic.new
  	@topics = friend_topics
  end

  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
  end

  def new
  	@topic = Topic.new(topic_params)
  end

  def create
  	@topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
  	if @topic.save
  		redirect_to root_path, notice: "投稿しました！"
    else
      redirect_to root_path, notice: "投稿が失敗しました！"
  	end
  end

  def edit
  end

  def update
    if @topic.user_id == current_user.id
      if @topic.update(topic_params)
        redirect_to root_path, notice: "更新しました！"
      else
        redirect_to root_path, notice: "投稿が失敗しました！"
      end
    else
      redirect_to root_path, notice: "不正な操作が行われました！"
    end
  end

  def destroy
    if @topic.user_id == current_user.id
      @topic.destroy
      redirect_to root_path, notice: "削除しました！"
    else 
      redirect_to root_path, notice: "不正な操作が行われました！"
    end
  end

  private
	  def topic_params
	  	params.require(:topic).permit(:content)
	  end

	  def set_topic
	  	@topic = Topic.find(params[:id])
	  end

    def friend_topics
      topics = Topic.all.order(created_at: :desc)
      friends = current_user.friend
      timeline = []

      
      topics.each do |topic|
        timeline << topic if topic.user_id == current_user.id
        if friends.present?
          friends.each do |fri|
            timeline << topic if topic.user_id == fri.id
          end
        end
      end

      return timeline
    end

end
