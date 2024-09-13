class ExamsController < ApplicationController
  before_action :set_exam, only: [ :show, :edit, :update, :destroy ]

  def index
    @exams = Exam.all
    respond_to do |format|
      format.html
      format.json { render json: @exams }
    end
  end

  def show
    @exam = Exam.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @exam }
    end
  end

  def new
    @exam = Exam.new
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: @exam.to_json(include: { questions: { include: :answers } }) }
    end
  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      render json: @exam, status: :created
    else
      render json: @exam.errors, status: :unprocessable_entity
    end
  end

  def update
    if @exam.update(exam_params)
      render json: @exam, status: :ok
    else
      render json: { errors: @exam.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to exams_url, notice: t("exams.destroy.success") }
      format.json { head :no_content }
    end
  end

  private

  def exam_params
    params.require(:exam).permit(
      :title, :start_date, :end_date,
      questions_attributes: [ :id, :content, :question_type, :points, :evaluable, :_destroy,
        answers_attributes: [ :id, :content, :correct, :_destroy ] ]
    )
  end

  def set_exam
    @exam = Exam.find_by(id: params[:id])
    render json: { error: t("exams.not_found") }, status: :not_found unless @exam
  end
end
