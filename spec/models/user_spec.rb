require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  context 'バリデーション' do
    it 'name、email、passwordがあれば有効であること' do
      expect(subject).to be_valid
    end

    it 'nameが空の場合、無効であること' do
      subject.name = nil
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to include('を入力してください。')
    end

    it 'emailが空の場合、無効であること' do
      subject.email = nil
      expect(subject).to be_invalid
      expect(subject.errors[:email]).to include('を入力してください。')
    end

    it '重複したemailの場合、無効であること（大文字小文字を区別しない）' do
      create(:user, email: subject.email.upcase)
      expect(subject).to be_invalid
      expect(subject.errors[:email]).to include('は既に存在します。')
    end

    it 'パスワードが6文字未満なら無効であること' do
      subject.password = '12345'
      subject.password_confirmation = '12345'
      expect(subject).to be_invalid
      expect(subject.errors[:password]).to include('は6文字以上で入力してください。')
    end
  end

  context 'アソシエーション' do
    it { should have_many(:habits).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_posts).through(:likes).source(:post) }
    it { should have_one_attached(:profile_image) }
  end

  context '.from_omniauthメソッドのテスト' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'testuser@example.com',
          name: 'Test User'
        }
      )
    end

    it '既存ユーザーがいる場合、新規作成せずにそのユーザーを返すこと' do
      existing_user = create(:user, provider: 'google_oauth2', uid: '123456789', email: 'testuser@example.com')
      expect {
        user = User.from_omniauth(auth)
        expect(user).to eq existing_user
      }.not_to change(User, :count)
    end

    it '既存ユーザーがいない場合、新しいユーザーを作成すること' do
      expect {
        user = User.from_omniauth(auth)
        expect(user.name).to eq 'Test User'
        expect(user.email).to eq 'testuser@example.com'
        expect(user.provider).to eq 'google_oauth2'
        expect(user.uid).to eq '123456789'
      }.to change(User, :count).by(1)
    end
  end

  context '.ransackable_attributesメソッドのテスト' do
    it '検索可能な属性を正しく返すこと' do
      expect(User.ransackable_attributes).to match_array %w[name email id created_at updated_at]
    end
  end
end
