require 'rails_helper'

RSpec.describe 'ログアウト', type: :system, js: true do
  let(:user) { create(:user) }

  it 'ログアウトするとトップへリダイレクトされ、未ログイン用のヘッダーが表示される' do
    sign_in_as(user)

    within('header nav') do
      accept_confirm { click_link 'ログアウト' }
    end

    within('header nav') do
      expect(page).to have_link('ログイン', href: new_user_session_path)
      expect(page).to have_no_link('ログアウト')
    end
  end
end
