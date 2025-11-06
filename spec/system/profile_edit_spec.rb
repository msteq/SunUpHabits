require 'rails_helper'

RSpec.describe 'プロフィール編集', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe '更新' do
    it '正しく入力すると更新に成功しマイページへ遷移する' do
      visit edit_user_registration_path

      fill_in 'ユーザー名', with: '新しい名前'
      fill_in 'メールアドレス', with: user.email
      click_button '保存'

      expect(page).to have_current_path(my_page_path, ignore_query: true)
      expect(page).to have_content('プロフィールを更新しました')
      expect(page).to have_content('新しい名前')

      user.reload
      expect(user.name).to eq '新しい名前'
    end

    it 'ユーザー名が空だと更新に失敗しエラーを表示する' do
      visit edit_user_registration_path

      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: user.email
      click_button '保存'

      expect(page).to have_current_path(user_registration_path, ignore_query: true)
      expect(page).to have_content('プロフィールの更新に失敗しました')
      expect(page).to have_content('ユーザー名を入力してください。')

      user.reload
      expect(user.name).not_to eq ''
    end

    it 'メールアドレスが不正だと更新に失敗しエラーを表示する' do
      visit edit_user_registration_path

      fill_in 'ユーザー名', with: user.name
      fill_in 'メールアドレス', with: 'invalid-email'
      click_button '保存'

      expect(page).to have_current_path(user_registration_path, ignore_query: true)
      expect(page).to have_content('プロフィールの更新に失敗しました')
      expect(page).to have_content('メールアドレスは有効ではありません。')

      user.reload
      expect(user.email).not_to eq 'invalid-email'
    end

    it '既存ユーザーと重複するメールアドレスだと更新に失敗する' do
      other = create(:user)
      conflict_email = other.email

      visit edit_user_registration_path
      fill_in 'ユーザー名', with: user.name
      fill_in 'メールアドレス', with: conflict_email
      click_button '保存'

      expect(page).to have_current_path(user_registration_path, ignore_query: true)
      expect(page).to have_content('プロフィールの更新に失敗しました')
      expect(page).to have_content('メールアドレスは既に存在します。')

      user.reload
      expect(user.email).not_to eq conflict_email
    end
  end

  describe '退会', js: true do
    it '確認して退会するとトップへ遷移しログアウト状態になる' do
      visit edit_user_registration_path

      accept_confirm('本当に退会しますか？この操作は元に戻せません。') do
        click_button '退会'
      end

      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content(I18n.t('devise.registrations.destroyed'))

      expect(User.exists?(user.id)).to be(false)

      within('header nav') do
        expect(page).to have_link('ログイン', href: new_user_session_path)
        expect(page).to have_no_link('ログアウト')
      end
    end

    it '確認ダイアログでキャンセルすると退会されない' do
      visit edit_user_registration_path

      dismiss_confirm('本当に退会しますか？この操作は元に戻せません。') do
        click_button '退会'
      end

      expect(page).to have_current_path(edit_user_registration_path, ignore_query: true)

      expect(User.exists?(user.id)).to be(true)

      within('header nav') do
        expect(page).to have_link('ログアウト')
      end
    end
  end
end
