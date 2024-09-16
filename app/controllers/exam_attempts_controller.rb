class ExamAttemptsController < ApplicationController
  before_action :set_exam
  before_action :authenticate_user!
  before_action :check_participant_role, only: [ :show, :result ]
  before_action :check_attempt_status, only: [ :start, :submit ]

  def start
    @user_exam = current_user.user_exams.create(exam: @exam, status: :in_progress)
    redirect_to exam_attempt_path(@exam), notice: t(".success")
  end

  def show
    @user_exam = current_user.user_exams.find_by(exam: @exam)
    if @user_exam.nil? || @user_exam.in_progress?
      @questions = @exam.questions.includes(:answers)
    else
      redirect_to result_exam_attempt_path(@exam), notice: t(".already_completed")
    end
  end

  def submit
    @user_exam = current_user.user_exams.find_by(exam: @exam)
    if @user_exam && @user_exam.in_progress?
      @user_exam.user_answers.destroy_all
      params[:answers].each do |question_id, answer_data|
        question = @exam.questions.find(question_id)
        @user_exam.user_answers.create(
          question: question,
          content: answer_data[:content]
        )
      end

      @user_exam.calculate_score
      redirect_to result_exam_attempt_path(@exam), notice: t(".success")
    else
      redirect_to exams_path, alert: t(".invalid")
    end
  end

  def result
    @user_exam = current_user.user_exams.find_by(exam: @exam)
    if @user_exam && @user_exam.completed?
      @total_score = @user_exam.total_score
      @user_answers = @user_exam.user_answers.includes(:question)
    else
      redirect_to exams_path, alert: t(".not_available")
    end
  end

  def assign
    email = params[:email]
    user = User.create_with(password: SecureRandom.hex(8)).find_or_create_by(email: email)
    user.add_role(:participant, @exam)
    user_exam = UserExam.find_or_create_by(exam: @exam, user: user)
    if user_exam.persisted?
      redirect_to exams_path(), notice: t(".index.success")
    else
      redirect_to exams_path(), alert: t(".index.error")
    end
  end

  private

  def set_exam
    @exam = Exam.find(params[:exam_id])
  end

  def check_attempt_status
    user_exam = current_user.user_exams.find_by(exam: @exam)
    if user_exam && user_exam.completed?
      redirect_to result_exam_attempt_path(@exam), alert: t(".already_completed")
    end
  end

  def check_participant_role
    unless current_user.has_role?(:participant, @exam) || current_user.has_role?(:admin)
      flash[:alert] = "You don't have permission to access this exam."
      redirect_to exams_path
    end
  end
end
