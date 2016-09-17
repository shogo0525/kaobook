class TopicsController < ApplicationController
  before_action :authenticate_user!
	before_action :set_topic, only:[:show, :edit, :update, :destroy]

  def index
  	@topic = Topic.new
  	@topics = Topic.order(created_at: :desc)
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
    if @topic.update(topic_params)
      redirect_to root_path, notice: "更新しました！"
    else
      redirect_to root_path, notice: "投稿が失敗しました！"
    end
  end

  def destroy
		@topic.destroy
    redirect_to root_path, notice: "削除しました！"
  end

  private
	  def topic_params
	  	params.require(:topic).permit(:content)
	  end

	  def set_topic
	  	@topic = Topic.find(params[:id])
	  end
end
