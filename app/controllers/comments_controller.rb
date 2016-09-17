class CommentsController < ApplicationController
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
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.js { render :edit }
    end
  end
  
  def destroy
    #@comment = current_user.comments.build(comment_params)
    @comment = Comment.find(params[:id])
    @comment.destroy
    
    #redirect_to blogs_path, notice: "ブログを削除しました！"
    respond_to do |format|
      format.js { render :index }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end
end
