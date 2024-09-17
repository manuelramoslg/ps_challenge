class ExamsController < ApplicationController
  before_action :set_exam, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin_or_manager, except: [ :index ]

  def index
    if current_user.has_role?(:admin) || current_user.has_role?(:manager)
      @exams = Exam.all
    else
      @exams = Exam.where(id: current_user.roles.where(resource_type: "Exam").map(&:resource_id))
    end

    @exams = @exams.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          exams: @exams,
          total_pages: @exams.total_pages,
          current_page: @exams.current_page,
          total_count: @exams.total_count
        }
      }
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

  def authorize_admin_or_manager
    unless current_user.has_any_role?(:admin, :manager)
      flash[:alert] = "You don't have permission to perform this action."
      redirect_to root_path
    end
  end
end
