class AnswersController < ApplicationController
  def create
    @answer = current_user.answers.build(params[:answer])
    if @answer.save
      return redirect_to question_path(@answer.question)
    end
        
    error = @answer.errors.first
	  flash[:notice] = "#{error[0]} #{error[1]}"
	  return redirect_to question_path(@answer.question)
  end
  
  # 投赞成票, ajax返回
  def vote_up
    answer = Answer.find_by_id(params[:id])
	  answer.vote_up_by!(current_user) if !answer.blank?
    render :status=>200, :json => answer
  end
  
  # 投反对票, ajax返回
  def vote_down
    answer = Answer.find_by_id(params[:id])
    answer.vote_down_by!(current_user) if !answer.blank?
    render :status=>200, :json => answer
  end

end
