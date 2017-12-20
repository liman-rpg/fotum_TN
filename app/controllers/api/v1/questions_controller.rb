class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :answers]

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def answers
    @answers = @question.answers
    respond_with @answers
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end