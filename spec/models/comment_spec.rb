require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    subject { build(:comment) }

    context 'contentが存在し、1000文字以内の場合' do
      it '有効であること' do
        expect(subject).to be_valid
      end
    end

    context 'contentが空の場合' do
      it '無効であること' do
        subject.content = nil
        expect(subject).to be_invalid
        expect(subject.errors[:content]).to include('を入力してください。')
      end
    end

    context 'contentが1001文字以上の場合' do
      it '無効であること' do
        subject.content = 'あ' * 1001
        expect(subject).to be_invalid
        expect(subject.errors[:content]).to include('は1000文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
