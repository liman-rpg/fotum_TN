require 'acceptance_helper'

feature 'Create question', %q{
  In order to ask a question
  As a authenticate user
  I want to create question
} do
  given(:user) { create(:user) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit root_path
    end

    scenario 'to create the correct question', js: true do
      click_on "Add Question"

      fill_in 'Title', with: 'New Question Title'
      fill_in 'Body', with: 'New Question Body'
      # save_and_open_page

      click_on 'Create'

      expect(page).to have_content "Question was successfully created."
      expect(page).to have_content "New Question Title"
      expect(page).to have_content "New Question Body"
    end

    scenario ' to create a non-valid question', js: true do
      click_on "Add Question"

      fill_in 'Title', with: nil
      fill_in 'Body', with: 'New Question Body'
      click_on 'Create'

      expect(page).to have_content "Titlecan't be blank"

      fill_in 'Title', with: 'New Question Title'
      fill_in 'Body', with: nil
      click_on 'Create'

      expect(page).to have_content "Bodycan't be blank"

      fill_in 'Title', with: 'New Question Title'
      fill_in 'Body', with: 'smal'
      click_on 'Create'

      expect(page).to have_content "Bodyis too short (minimum is 5 characters)"
    end
  end

  scenario 'Non authenticated user try create a question' do
    visit root_path

    expect(page).to_not have_content 'Add Question'
  end

  context 'multiple session' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit root_path
      end

      Capybara.using_session('quest') do
        visit root_path
      end

      Capybara.using_session('user') do
        click_on "Add Question"

        fill_in 'Title', with: 'New Question Title'
        fill_in 'Body', with: 'New Question Body'
        click_on 'Create'

        expect(page).to have_content "New Question Title"
        expect(page).to have_content "New Question Body"
      end

      Capybara.using_session('quest') do
        expect(page).to have_content "New Question Title"
      end
    end
  end
end
