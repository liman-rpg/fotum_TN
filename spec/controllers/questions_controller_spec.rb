require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array for all questions' do
      expect(assigns(:questions)).to match_array(question)
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question.id } }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe "GET #new" do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
  end

  describe "GET #edit" do
    sign_in_user
    before { get :edit, params: { id: question.id } }

    it 'assigns an edit Question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe "POST #create" do
    sign_in_user

    context 'with valid attributes' do
      let(:create_valid_question) { post :create, params: { question: attributes_for(:question) } }

      it "save new question in database" do
        expect{ create_valid_question }.to change(Question, :count).by(+1)
      end

      it "associated with the user" do
        expect { create_valid_question }.to change(@user.questions, :count).by(+1)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, params: { question: attributes_for(:invalid_question) } }

      it "don't save new question in database" do
        expect{ create_invalid_question }.to_not change(Question, :count)
      end

      it "not associated with the user" do
        expect { create_invalid_question }.to_not change(@user.questions, :count)
      end
    end
  end

  describe "POST #update" do
    sign_in_user

    let(:question)              { create(:question, user: @user) }
    let(:update_valid_question) { post :update, params: { id: question.id, user: @user, question: { title: 'New Title', body: 'New Body'}, format: :js } }

    before { update_valid_question }

    context 'with valid attributes' do
      it 'assigns request the question to @question' do
        expect(assigns(:question)).to eq question
      end

      it "update question's params in database" do
        question.reload
        expect(question.title).to eq "New Title"
        expect(question.body).to eq "New Body"
      end
    end

    context 'with invalid attributes' do
      let(:update_invalid_question) { post :update, params: { id: question.id, question: attributes_for(:invalid_question), user: @user, format: :js } }
      before { update_invalid_question }

      it "don't update question's params in database" do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    let(:delete_question) { delete :destroy, params: { id: question.id } }

    context 'author' do
      let(:question) { Question.create!(title: 'ExampleTitle', body: 'ExampleBody', user_id: @user.id) }

      it 'delete question from database' do
        question
        expect{ delete_question }.to change(Question, :count).by(-1)
      end
    end

    context 'not author' do
      it 'does not remove a question from the database' do
        question
        expect{ delete_question }.to_not change(Question, :count)
      end
    end
  end
end
