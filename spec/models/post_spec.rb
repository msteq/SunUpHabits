require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it 'contentがあれば有効であること' do
      post = build(:post)
      expect(post).to be_valid
    end

    it 'contentが空の場合、無効であること' do
      post = build(:post, content: nil)
      expect(post).to be_invalid
      expect(post.errors[:content]).to include('を入力してください。')
    end

    it 'contentが1001文字以上の場合、無効であること' do
      post = build(:post, content: 'あ' * 1001)
      expect(post).to be_invalid
      expect(post.errors[:content]).to include('は1000文字以内で入力してください')
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:habit) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_users).through(:likes).source(:user) }
  end

  describe 'クラスメソッド' do
    describe '.ransackable_attributes' do
      it '検索可能な属性を配列で返すこと' do
        expect(Post.ransackable_attributes).to match_array %w[content created_at id updated_at user_id]
      end
    end

    describe '.ransackable_associations' do
      it '検索可能なアソシエーションを配列で返すこと' do
        expect(Post.ransackable_associations).to match_array %w[user]
      end
    end
  end
end
