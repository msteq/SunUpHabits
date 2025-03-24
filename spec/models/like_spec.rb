require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    subject { create(:like) }

    context 'user_idとpost_idの組み合わせが一意の場合' do
      it '有効であること' do
        expect(subject).to be_valid
      end
    end

    context '同じユーザーが同じ投稿を複数回いいねした場合' do
      it '無効であること（重複禁止）' do
        duplicate_like = build(:like, user: subject.user, post: subject.post)
        expect(duplicate_like).to be_invalid
        expect(duplicate_like.errors[:user_id]).to include('は既に存在します。')
      end
    end

    context '異なるユーザーが同じ投稿にいいねした場合' do
      it '有効であること' do
        another_like = build(:like, post: subject.post, user: create(:user))
        expect(another_like).to be_valid
      end
    end

    context '同じユーザーが異なる投稿にいいねした場合' do
      it '有効であること' do
        another_like = build(:like, user: subject.user, post: create(:post))
        expect(another_like).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
