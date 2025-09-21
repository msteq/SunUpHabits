require 'rails_helper'

RSpec.describe '未ログインアクセスのリダイレクト', type: :system do
  protected_paths = {
    'マイ習慣一覧'   => :my_habits_path,
    '習慣の新規作成' => :new_habit_path,
    '投稿一覧'       => :posts_path,
    '投稿の新規作成' => :new_post_path,
    'マイページ'     => :my_page_path
  }

  protected_paths.each do |label, helper|
    it "#{label}に未ログインでアクセスするとログイン画面へリダイレクトされる" do
      visit send(helper)
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_content('ログイン')
    end
  end
end
