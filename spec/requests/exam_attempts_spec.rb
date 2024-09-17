require 'rails_helper'

RSpec.describe ExamAttemptsController, type: :controller do
  let(:user) { create(:user, :participant) }
  let(:admin) { create(:user, :admin) }
  let(:exam) { create(:exam, :with_questions) }
  let(:user_exam) { create(:user_exam, user: user, exam: exam) }

  before do
    sign_in user
  end

  describe 'POST #start' do
    context 'when user has not started the exam' do
      it 'creates a new user_exam and redirects to exam attempt path' do
        post :start, params: { exam_id: exam.id }
        expect(response).to redirect_to(exam_attempt_path(exam))
        expect(flash[:notice]).to eq(I18n.t('exam_attempts.start.success'))
        expect(UserExam.last.status).to eq('in_progress')
      end
    end

    context 'when user has already completed the exam' do
      before do
        create(:user_exam, user: user, exam: exam, status: :completed)
      end

      it 'redirects to result path' do
        post :start, params: { exam_id: exam.id }
        expect(response).to redirect_to(result_exam_attempt_path(exam))
        expect(flash[:alert]).to eq(I18n.t('exam_attempts.already_completed'))
      end
    end
  end

  describe 'GET #show' do
    context 'when user has an in-progress exam' do
      before do
        create(:user_exam, user: user, exam: exam, status: :in_progress)
      end

      it 'shows the exam questions' do
        get :show, params: { exam_id: exam.id }
        expect(response).to be_successful
        expect(assigns(:questions)).to eq(exam.questions)
      end
    end

    context 'when user has completed the exam' do
      before do
        create(:user_exam, user: user, exam: exam, status: :completed)
      end

      it 'redirects to result path' do
        get :show, params: { exam_id: exam.id }
        expect(response).to redirect_to(result_exam_attempt_path(exam))
        expect(flash[:notice]).to eq(I18n.t('exam_attempts.show.already_completed'))
      end
    end
  end

  describe 'POST #submit' do
    let!(:question1) { create(:question, exam: exam) }
    let!(:question2) { create(:question, exam: exam) }

    context 'when user submits valid answers' do
      it 'creates user answers and calculates score' do
        user_exam = create(:user_exam, user: user, exam: exam, status: :in_progress)
        post :submit, params: {
          exam_id: exam.id,
          answers: {
            question1.id => { content: 'Answer 1' },
            question2.id => { content: 'Answer 2' }
          }
        }
        expect(response).to redirect_to(result_exam_attempt_path(exam))
        expect(flash[:notice]).to eq(I18n.t('exam_attempts.submit.success'))
        expect(user_exam.reload.status).to eq('completed')
        expect(user_exam.user_answers.count).to eq(2)
      end
    end

    context 'when user submits for a non-existent or completed exam' do
      it 'redirects to exams path with an error' do
        post :submit, params: { exam_id: exam.id, answers: {} }
        expect(response).to redirect_to(exams_path)
        expect(flash[:alert]).to eq(I18n.t('exam_attempts.submit.invalid'))
      end
    end
  end

  describe 'GET #result' do
    context 'when user has completed the exam' do
      before do
        create(:user_exam, :completed, user: user, exam: exam)
      end

      it 'shows the exam result' do
        get :result, params: { exam_id: exam.id }
        expect(response).to be_successful
        expect(assigns(:total_score)).to be_present
      end
    end

    context 'when user has not completed the exam' do
      it 'redirects to exams path with an error' do
        get :result, params: { exam_id: exam.id }
        expect(response).to redirect_to(exams_path)
        expect(flash[:alert]).to eq(I18n.t('exam_attempts.result.not_available'))
      end
    end
  end

  describe 'POST #assign' do
    before do
      sign_in admin
    end

    context 'when assigning to a new user' do
      it 'creates a new user and assigns the exam' do
        post :assign, params: { exam_id: exam.id, email: 'new_user@example.com' }
        expect(response).to redirect_to(exams_path)
        expect(flash[:notice]).to eq(I18n.t('exam_attempts.index.success'))
        new_user = User.find_by(email: 'new_user@example.com')
        expect(new_user).to be_present
        expect(new_user.has_role?(:participant, exam)).to be true
      end
    end

    context 'when assigning to an existing user' do
      let!(:existing_user) { create(:user) }

      it 'assigns the exam to the existing user' do
        post :assign, params: { exam_id: exam.id, email: existing_user.email }
        expect(response).to redirect_to(exams_path)
        expect(flash[:notice]).to eq(I18n.t('exam_attempts.index.success'))
        expect(existing_user.has_role?(:participant, exam)).to be true
      end
    end
  end
end
