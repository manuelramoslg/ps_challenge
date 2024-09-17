class ExamResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def index
    @exams = Exam.includes(user_exams: :user)
                 .where(user_exams: { status: :completed })
                 .order(end_date: :desc)
                 .page(params[:page])
                 .per(10)

    if params[:exam_title].present?
      @exams = @exams.where("title ILIKE ?", "%#{params[:exam_title]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      @exams = @exams.where(end_date: params[:start_date]..params[:end_date])
    end
  end

  def show
    @exam = Exam.find(params[:id])
    @user = User.find(params[:user_id])
    @user_exam = @exam.user_exams.completed.find_by(user: @user)

    if @user_exam.nil?
      redirect_to exam_results_path, alert: t("exam_results.show.not_found")
    end
  end

  private

  def authorize_user
    unless current_user.has_role?(:admin) || current_user.has_role?(:manager)
      redirect_to root_path, alert: t("unauthorized_access")
    end
  end
end
