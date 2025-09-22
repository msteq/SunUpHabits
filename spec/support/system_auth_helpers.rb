module SystemAuthHelpers
  def sign_in_as(user, password: 'password123')
    user.update!(password: password)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
    expect(page).to have_current_path(my_habits_path, ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemAuthHelpers, type: :system
end
