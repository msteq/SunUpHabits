require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user, password: "password123") }

  context "有効な情報でログインする場合" do
    it "ログインに成功し、my_habitsページへリダイレクトされる" do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password123"
      click_button "ログイン"
      expect(page).to have_current_path(my_habits_path)
    end
  end

  context "無効な情報でログインを試みた場合" do
    it "エラーメッセージが表示され、ログインに失敗する" do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "wrongpassword"
      click_button "ログイン"
      expect(page).to have_content("ログインに失敗しました。メールアドレスまたはパスワードが違います。")
    end
  end
end
