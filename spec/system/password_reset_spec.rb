require 'rails_helper'

RSpec.describe 'PasswordReset', type: :system do
  let!(:user) { create(:user) }

  before { clear_emails }

  it '登録済みメールにリセット用メールを送る' do
    visit new_user_password_path
    expect(page).to have_content('パスワードの再設定')

    fill_in 'メールアドレス', with: user.email
    expect {
      click_button '送信'
    }.to change { ActionMailer::Base.deliveries.size }.by(1)

    expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
  end

  it 'メール形式が不正だと送信されずエラーメッセージ' do
    visit new_user_password_path
    expect(page).to have_content('パスワードの再設定')

    fill_in 'メールアドレス', with: 'invalid-email'
    expect {
      click_button '送信'
    }.not_to change { ActionMailer::Base.deliveries.size }

    expect(page).to have_content('メールアドレスを確認してください。')
  end

  it 'メールのリンクからパスワードを変更できる' do
    visit new_user_password_path
    expect(page).to have_content('パスワードの再設定')

    fill_in 'メールアドレス', with: user.email
    click_button '送信'
    expect(ActionMailer::Base.deliveries.size).to eq 1

    link = reset_password_link_from(last_email)
    expect(link).to be_present
    visit link

    fill_in '新しいパスワード', with: 'newpass123'
    fill_in '新しいパスワード（確認）', with: 'newpass123'
    click_button '変更'

    expect(page).to have_current_path(my_habits_path)
    expect(page).to have_content(I18n.t('devise.passwords.updated'))
  end
end
