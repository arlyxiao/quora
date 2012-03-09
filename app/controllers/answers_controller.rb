class AnswersController < ApplicationController
  def create
    @answer = current_user.answers.build(params[:answer])
    return redirect_to question_path(@answer.question) if @answer.save
        
    error = @answer.errors.first
	  flash[:notice] = "#{error[0]} #{error[1]}"
	  return redirect_to question_path(@answer.question)
  end

end
