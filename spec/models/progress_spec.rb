require 'rails_helper'

RSpec.describe Progress, type: :model do
  let(:progress) { build(:progress) }

  describe 'バリデーション' do
    it 'habit、date、statusがあれば有効であること' do
      expect(progress).to be_valid
    end

    it 'dateが空の場合、無効であること' do
      progress.date = nil
      expect(progress).to be_invalid
      expect(progress.errors[:date]).to include('を入力してください。')
    end

    it '同じhabit内でdateが重複した場合、無効であること' do
      habit = create(:habit)
      create(:progress, habit: habit, date: Date.new(2025, 3, 20))
      progress_duplicate = build(:progress, habit: habit, date: Date.new(2025, 3, 20))
      expect(progress_duplicate).to be_invalid
      expect(progress_duplicate.errors[:date]).to include('は既に存在します。')
    end

    it '異なるhabitで同じdateを登録する場合、有効であること' do
      create(:progress, date: Date.new(2025, 3, 20)) # 別のhabit
      new_progress = build(:progress, date: Date.new(2025, 3, 20))
      expect(new_progress).to be_valid
    end

    it 'statusが空の場合、無効であること' do
      progress.status = nil
      expect(progress).to be_invalid
      expect(progress.errors[:status]).to include('を入力してください。')
    end

    it 'statusが『達成』『未達成』以外の場合、無効であること' do
      progress.status = '途中'
      expect(progress).to be_invalid
      expect(progress.errors[:status]).to include('は一覧にありません')
    end

    it 'statusが『達成』の場合、有効であること' do
      progress.status = '達成'
      expect(progress).to be_valid
    end

    it 'statusが『未達成』の場合、有効であること' do
      progress.status = '未達成'
      expect(progress).to be_valid
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:habit) }
  end
end
