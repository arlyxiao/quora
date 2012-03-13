class AnswerCommentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  
  def pre_load
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
    @comment = Comment.find(params[:id]) if params[:id]
  end
  
  def create
    @comment = @answer.comments.build(params[:comment])
    @comment.creator = current_user
    if !@comment.save
      error = @comment.errors.first
      flash[:error] = "#{error[0]} #{error[1]}"
    end
    redirect_to :back
  end
  
  def reply
  end
  
  def do_reply
    answer = @comment.model
    reply_comment = answer.comments.build(params[:comment])
    reply_comment.reply_comment_id = @comment.id
    reply_comment.creator = current_user
    if reply_comment.save
      return redirect_to :back
    end
    error = reply_comment.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to :back
  end
end
