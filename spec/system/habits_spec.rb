require 'rails_helper'

RSpec.describe '習慣', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe '新規作成' do
    it '正しく入力すると作成できる' do
      visit new_habit_path

      fill_in 'habit_title', with: '朝ジョギング'
      fill_in 'habit_goal', with: '30日連続で走る'
      fill_in 'habit_start_date', with: Date.current.to_s

      click_button '登録'

      expect(page).to have_content('新しい習慣を登録しました。')
      expect(page).to have_content('習慣の詳細')
      expect(page).to have_content('朝ジョギング')
      expect(page).to have_content('30日連続で走る')
    end

    it '未入力だとエラーになる' do
      visit new_habit_path

      fill_in 'habit_title', with: ''
      fill_in 'habit_goal', with: ''
      click_button '登録'

      expect(page).to have_content('習慣の登録に失敗しました。入力内容を確認してください。')
      expect(page).to have_content('習慣名を入力してください。')
      expect(page).to have_content('目標設定を入力してください。')
    end
  end

  describe '編集' do
    let!(:habit) { Habit.create!(user:, title: '英語', goal: '毎日10分', start_date: Date.current) }

    it '正しく更新できる' do
      visit edit_habit_path(habit)

      fill_in 'habit_title', with: '英語リスニング'
      fill_in 'habit_goal', with: '毎日15分'
      fill_in 'habit_start_date', with: Date.current.to_s

      click_button '更新'

      expect(page).to have_content('習慣が更新されました。')
      expect(page).to have_content('習慣の詳細')
      expect(page).to have_content('英語リスニング')
      expect(page).to have_content('毎日15分')
    end

    it '不正な入力だと更新に失敗する' do
      visit edit_habit_path(habit)

      fill_in 'habit_title', with: ''
      click_button '更新'

      expect(page).to have_content('習慣の更新に失敗しました。入力内容を確認してください。')
      expect(page).to have_content('習慣名を入力してください。')
    end
  end

  describe '削除', js: true do
    let!(:habit) { Habit.create!(user:, title: '筋トレ', goal: '腕立て', start_date: Date.current) }

    it '詳細から削除でき、一覧に戻る' do
      visit habit_path(habit)

      accept_confirm('本当に削除しますか？') do
        click_link '削除'
      end

      expect(page).to have_current_path(my_habits_path, ignore_query: true)
      expect(page).to have_content('習慣が削除されました。')
      expect(page).to have_no_content('筋トレ')
    end
  end

  describe '日次記録（達成/未達成）' do
    let!(:habit) { Habit.create!(user:, title: '読書', goal: '10分', start_date: Date.current) }

    it '達成を押すと投稿作成画面へ遷移する' do
      visit habit_path(habit)

      click_button '達成'

      expect(page).to have_current_path(new_post_path, ignore_query: true)
      expect(page).to have_content('本日を達成として記録しました！感じたことをシェアしましょう！')
      expect(page).to have_selector('textarea[name="post[content]"]')
    end

    it '未達成を押すと詳細に戻り、記録済み表示になる' do
      visit habit_path(habit)

      click_button '未達成'

      expect(page).to have_current_path(habit_path(habit), ignore_query: true)
      expect(page).to have_content('本日を未達成として記録しました。')
      expect(page).to have_content('本日は記録済みです。次の記録は明日以降可能です。')
    end
  end
end
