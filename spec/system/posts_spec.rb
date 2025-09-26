require 'rails_helper'

RSpec.describe '投稿', type: :system do
  let(:user)  { create(:user) }
  let!(:habit) { create(:habit, user: user, title: '英語', goal: '10分', start_date: Date.current) }

  before do
    sign_in_as(user)
  end

  describe '一覧/詳細表示' do
    let!(:my_post)     { create(:post, user: user, content: '自分の投稿です') }
    let!(:others_post) { create(:post, content: '他人の投稿です') }

    it '投稿一覧に自分と他人の投稿が表示される' do
      visit posts_path
      expect(page).to have_content('投稿一覧')
      expect(page).to have_content('自分の投稿です')
      expect(page).to have_content('他人の投稿です')
    end

    it '投稿詳細を表示できる' do
      visit post_path(my_post)
      expect(page).to have_content('投稿の詳細')
      expect(page).to have_content(user.name)
      expect(page).to have_content('自分の投稿です')
    end
  end

  describe '新規作成' do
    it '正しく入力すると作成に成功し一覧へ遷移する' do
      visit new_post_path(habit_id: habit.id)

      fill_in 'post_content', with: '今日は10分やりました！'
      click_button '投稿'

      expect(page).to have_current_path(posts_path, ignore_query: true)
      expect(page).to have_content('投稿が完了しました！')
      expect(page).to have_content('今日は10分やりました！')
    end

    it '内容が空だと作成に失敗しエラーを表示する' do
      visit new_post_path(habit_id: habit.id)
      fill_in 'post_content', with: ''
      click_button '投稿'

      expect(page).to have_content('投稿に失敗しました。内容を確認してください。')
    end
  end

  describe 'コメント' do
    let!(:post_record) { create(:post, content: 'コメント対象の投稿') }

    it 'コメントを作成できる' do
      visit post_path(post_record)
      fill_in 'comment_content', with: 'ナイス！'
      click_button '送信'

      expect(page).to have_current_path(post_path(post_record), ignore_query: true)
      expect(page).to have_content('コメントを投稿しました。')
      expect(page).to have_content('ナイス！')
    end

    it 'コメントが空だと作成に失敗しエラーを表示する' do
      visit post_path(post_record)
      fill_in 'comment_content', with: ''
      click_button '送信'

      expect(page).to have_current_path(post_path(post_record), ignore_query: true)
      expect(page).to have_content('コメントの投稿に失敗しました。内容を確認してください。')
    end

    it '自分のコメントを削除できる', js: true do
      visit post_path(post_record)
      fill_in 'comment_content', with: '消すコメント'
      click_button '送信'
      expect(page).to have_content('消すコメント')

      accept_confirm { click_link '削除' }

      expect(page).to have_current_path(post_path(post_record), ignore_query: true)
      expect(page).to have_content('コメントを削除しました。')
      expect(page).to have_no_content('消すコメント')
    end

    it '他人のコメントには削除リンクが表示されない' do
      other_user = create(:user)
      create(:comment, post: post_record, user: other_user, content: '他人のコメント')

      visit post_path(post_record)
      expect(page).to have_no_link('削除')
    end
  end

  describe 'いいね', js: true do
    let!(:post_record) { create(:post, content: 'いいね対象の投稿') }

    it 'いいねの付与・解除でカウントが増減する' do
      visit post_path(post_record)

      within "#like_button_#{post_record.id}" do
        click_button 'いいね'
        expect(page).to have_text('1')

        click_button 'いいね'
        expect(page).to have_no_text('1')
      end
    end
  end

  describe '検索' do
    let!(:p1) { create(:post, user: user, content: '読書をした') }
    let!(:p2) { create(:post, content: '勉強をした') }

    it 'キーワードで絞り込める' do
      visit posts_path
      fill_in 'q_content_or_user_name_cont', with: '読書'
      click_button '検索'

      expect(page).to have_content('読書をした')
      expect(page).to have_no_content('勉強をした')
    end
  end
end
