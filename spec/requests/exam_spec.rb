require 'rails_helper'

RSpec.describe "Exams", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:participant) { create(:user, :participant) }
  let(:exam) { create(:exam) }

  describe "GET /exams" do
    context "when user is admin" do
      before { sign_in admin }

      it "returns all exams" do
        create_list(:exam, 3)
        get exams_path
        expect(response).to have_http_status(:ok)
        expect(assigns(:exams).count).to eq(Exam.count)
      end

      it "returns JSON when requested" do
        create_list(:exam, 3)
        get exams_path, params: { format: :json }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body).length).to eq(Exam.count)
      end
    end

    context "when user is manager" do
      before { sign_in manager }

      it "returns all exams" do
        create_list(:exam, 3)
        get exams_path
        expect(response).to have_http_status(:ok)
        expect(assigns(:exams).count).to eq(Exam.count)
      end
    end

    context "when user is participant" do
      before { sign_in participant }

      it "returns only assigned exams" do
        create_list(:exam, 3)
        participant.add_role(:participant, Exam.first)
        get exams_path
        expect(response).to have_http_status(:ok)
        expect(assigns(:exams).count).to eq(1)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login page" do
        get exams_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /exams/:id" do
    context "when user is authenticated" do
      before { sign_in admin }

      it "returns the exam" do
        get exam_path(exam)
        expect(response).to have_http_status(:ok)
        expect(assigns(:exam)).to eq(exam)
      end

      it "returns JSON when requested" do
        get exam_path(exam), params: { format: :json }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['id']).to eq(exam.id)
      end
    end

    context "when exam doesn't exist" do
      before { sign_in admin }

      it "returns not found" do
        get exam_path(id: 9999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /exams/new" do
    context "when user is admin" do
      before { sign_in admin }

      it "returns a new exam form" do
        get new_exam_path
        expect(response).to have_http_status(:ok)
        expect(assigns(:exam)).to be_a_new(Exam)
      end
    end

    context "when user is participant" do
      before { sign_in participant }

      it "redirects to root path" do
        get new_exam_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You don't have permission to perform this action.")
      end
    end
  end

  describe "POST /exams" do
    context "when user is admin" do
      before { sign_in admin }

      context "with valid parameters" do
        let(:valid_params) { { exam: attributes_for(:exam) } }

        it "creates a new exam" do
          expect {
            post exams_path, params: valid_params
          }.to change(Exam, :count).by(1)
          expect(response).to have_http_status(:created)
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { exam: attributes_for(:exam, title: nil) } }

        it "does not create a new exam" do
          expect {
            post exams_path, params: invalid_params
          }.not_to change(Exam, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is participant" do
      before { sign_in participant }

      it "does not create a new exam and redirects to root path" do
        expect {
          post exams_path, params: { exam: attributes_for(:exam) }
        }.not_to change(Exam, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You don't have permission to perform this action.")
      end
    end
  end

  describe "PUT /exams/:id" do
    context "when user is admin" do
      before { sign_in admin }

      context "with valid parameters" do
        let(:new_attributes) { { title: "Updated Exam Title" } }

        it "updates the exam" do
          put exam_path(exam), params: { exam: new_attributes }
          exam.reload
          expect(exam.title).to eq("Updated Exam Title")
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { { title: nil } }

        it "does not update the exam" do
          put exam_path(exam), params: { exam: invalid_attributes }
          exam.reload
          expect(exam.title).not_to be_nil
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when user is participant" do
      before { sign_in participant }

      it "does not update the exam and redirects to root path" do
        original_title = exam.title
        put exam_path(exam), params: { exam: { title: "New Title" } }
        exam.reload
        expect(exam.title).to eq(original_title)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You don't have permission to perform this action.")
      end
    end
  end

  describe "DELETE /exams/:id" do
    context "when user is admin" do
      before { sign_in admin }

      it "destroys the exam" do
        exam_to_delete = create(:exam)
        expect {
          delete exam_path(exam_to_delete)
        }.to change(Exam, :count).by(-1)
        expect(response).to redirect_to(exams_url)
        expect(flash[:notice]).to eq(I18n.t("exams.destroy.success"))
      end
    end

    context "when user is participant" do
      before { sign_in participant }

      it "does not destroy the exam and redirects to root path" do
        exam_to_delete = create(:exam)
        expect {
          delete exam_path(exam_to_delete)
        }.not_to change(Exam, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You don't have permission to perform this action.")
      end
    end
  end
end
