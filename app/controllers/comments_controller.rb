class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
    @comment = current_user.comments.build(comment_params)
    @topic = @comment.topic

    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        format.json { render :show, status: :created, location: @comment }
        # JS形式でレスポンスを返します。
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @comment.user_id == current_user.id
      if @comment.update(comment_params)
        redirect_to topic_path(@comment.topic)
      else
        render :edit
      end
    else
      redirect_to root_path, notice: "不正な操作が行われました！"
    end
  end
  
  def destroy
    if @comment.user_id == current_user.id
      @comment.destroy
      
      #redirect_to blogs_path, notice: "ブログを削除しました！"
      respond_to do |format|
        format.js { render :index }
      end
    else 
      redirect_to root_path, notice: "不正な操作が行われました！"
    end
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  private
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end
end
