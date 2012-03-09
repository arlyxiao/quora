class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end
  
  def create
    @question = current_user.questions.build(params[:question])
    return redirect_to @question if @question.save

    error = @question.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  def index
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end

end
