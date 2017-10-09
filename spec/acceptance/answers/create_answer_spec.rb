require 'acceptance_helper'

feature 'Create answer', %q{
  In order to get answer from questions
  Authenticate user
  I want to create answer
} do
  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try create answer' do
      fill_in 'Body Answer', with: 'BodyTestAnswer'
      click_on 'Create Answer'

      expect(page).to have_content 'BodyTestAnswer'
      expect(page).to have_content 'Body Answer'
      expect(current_path).to eq question_path(question)
    end

    # Не пойму как отобразить сообщения об ошибках  '= f.error_notification'
    # Если делать редирект, они стираются.

    # scenario 'try create nill answer' do
    #   fill_in 'Body Answer', with: ''
    #   click_on 'Reply'

    #   expect(page).to have_content "Body can't be blank"
    # end

    # scenario 'try create short answer (:body)' do
    #   fill_in 'Body Answer', with: 'SML'
    #   click_on 'Reply'

    #   expect(page).to have_content "Body is too short (minimum is 5 characters)"
    # end
  end

  scenario 'Unauthenticate user try create answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea#answer_body'
  end
end