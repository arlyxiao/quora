class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end
  
  def create
    @question = current_user.asked_questions.build(params[:question])
    return redirect_to @question if @question.save

    error = @question.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end
  
  # 当前用户发起的问题
  def byme
    @questions = current_user.asked_questions
  end
  
  # 当前用户回答过的问题列表
  def answered
    @questions = current_user.answered_questions
  end

end
