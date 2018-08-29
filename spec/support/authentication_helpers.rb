module AuthenticationHelpers
  def sign_in_as!(user, password='secret')
    visit '/login'
    within('#content') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_button 'Login'
    end
  end

  def sign_in_as_admin!(user, password='secret', start_path = '/admin')
    visit start_path
    within('#new_spree_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_button 'Login'
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Rack::Test::Methods, type: :feature
end
