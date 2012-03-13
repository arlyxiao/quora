class QuestionCommentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  
  def pre_load
    @question = Question.find(params[:question_id]) if params[:question_id]
    @comment = Comment.find(params[:id]) if params[:id]
  end
  
  def create
    @comment = @question.comments.build(params[:comment])
    @comment.creator = current_user
    if !@comment.save
      error = @comment.errors.first
      flash[:error] = "#{error[0]} #{error[1]}"
    end
    redirect_to :back
  end
  

  def do_reply
    question = @comment.model
    reply_comment = question.comments.build(params[:comment])
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
