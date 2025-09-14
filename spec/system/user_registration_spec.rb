require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  let(:user) { build(:user) }

  context '有効な情報を入力したとき' do
    it '登録に成功しマイ習慣ページへリダイレクトされる' do
      visit new_user_registration_path

      fill_in 'ユーザー名',         with: user.name
      fill_in 'メールアドレス',     with: user.email
      fill_in 'パスワード',         with: user.password
      fill_in 'パスワード（確認）', with: user.password_confirmation
      click_button '登録'

      expect(page).to have_current_path(my_habits_path)
      expect(page).to have_content('ユーザー登録が完了しました。')
    end
  end

  context '無効な情報を入力したとき' do
    it 'ユーザー名が空だとエラーになる' do
      visit new_user_registration_path

      fill_in 'ユーザー名',         with: ''
      fill_in 'メールアドレス',     with: user.email
      fill_in 'パスワード',         with: user.password
      fill_in 'パスワード（確認）', with: user.password_confirmation
      click_button '登録'

      expect(page).to have_current_path(user_registration_path)
      expect(page).to have_content('ユーザー名を入力してください。')
    end

    it 'メールアドレスが不正だとエラーになる' do
      visit new_user_registration_path

      fill_in 'ユーザー名',         with: user.name
      fill_in 'メールアドレス',     with: 'invalid-email'
      fill_in 'パスワード',         with: user.password
      fill_in 'パスワード（確認）', with: user.password_confirmation
      click_button '登録'

      expect(page).to have_content('メールアドレスは有効ではありません。')
    end

    it 'パスワード確認が一致しないとエラーになる' do
      visit new_user_registration_path

      fill_in 'ユーザー名',         with: user.name
      fill_in 'メールアドレス',     with: user.email
      fill_in 'パスワード',         with: user.password
      fill_in 'パスワード（確認）', with: 'mismatch'
      click_button '登録'

      expect(page).to have_content('パスワード（確認用）とパスワードの入力が一致しません')
    end

    it '既に登録済みのメールアドレスだとエラーになる' do
      create(:user, email: user.email)

      visit new_user_registration_path

      fill_in 'ユーザー名',         with: user.name
      fill_in 'メールアドレス',     with: user.email
      fill_in 'パスワード',         with: user.password
      fill_in 'パスワード（確認）', with: user.password_confirmation
      click_button '登録'

      expect(page).to have_content('メールアドレスは既に存在します。')
    end
  end
end
