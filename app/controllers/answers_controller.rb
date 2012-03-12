class AnswersController < ApplicationController
  respond_to :js, :json, :html, :xml
  def create
    @answer = current_user.answers.build(params[:answer])
    return redirect_to question_path(@answer.question) if @answer.save
        
    error = @answer.errors.first
	  flash[:notice] = "#{error[0]} #{error[1]}"
	  return redirect_to question_path(@answer.question)
  end
  
  # 投赞成票, ajax返回
  def agree
    @answer = Answer.find(params[:format])
		current_user.agree(@answer)

	  #respond_to do |format|
    #  format.js { render :content_type => 'text/javascript'  }
    #end

  end
  
  # 投反对票, ajax返回
  def disagree
    answer = Answer.find(params[:format])
	  current_user.disagree(answer)
  end

end
