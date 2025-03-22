require 'rails_helper'

RSpec.describe Habit, type: :model do
  let(:habit) { build(:habit) }

  context 'バリデーション' do
    it 'title、goal、start_dateがあれば有効であること' do
      expect(habit).to be_valid
    end

    it 'titleが空の場合、無効であること' do
      habit.title = nil
      expect(habit).to be_invalid
      expect(habit.errors[:title]).to include('を入力してください。')
    end

    it 'titleが256文字以上の場合、無効であること' do
      habit.title = 'あ' * 256
      expect(habit).to be_invalid
      expect(habit.errors[:title]).to include('は255文字以内で入力してください')
    end

    it 'goalが空の場合、無効であること' do
      habit.goal = nil
      expect(habit).to be_invalid
      expect(habit.errors[:goal]).to include('を入力してください。')
    end

    it 'goalが256文字以上の場合、無効であること' do
      habit.goal = 'あ' * 256
      expect(habit).to be_invalid
      expect(habit.errors[:goal]).to include('は255文字以内で入力してください')
    end

    it 'start_dateが空の場合、無効であること' do
      habit.start_date = nil
      expect(habit).to be_invalid
      expect(habit.errors[:start_date]).to include('を入力してください。')
    end
  end

  context 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:progresses).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
  end

  context 'インスタンスメソッド' do
    describe '#continuous_days' do
      let(:habit) { create(:habit) }
      let(:today) { Date.new(2025, 3, 20) } # テストで使う日付を明示的に固定する

      before do
        create(:progress, habit: habit, date: today, status: '達成')
        create(:progress, habit: habit, date: today - 1.day, status: '達成')
        create(:progress, habit: habit, date: today - 2.days, status: '達成')
        create(:progress, habit: habit, date: today - 3.days, status: '未達成')
      end

      it '連続達成日数を正しく計算すること' do
        allow(Date).to receive(:today).and_return(today)
        expect(habit.continuous_days).to eq(3)
      end
    end

    describe '#achieved_days_last_30_days' do
      let(:habit) { create(:habit) }

      before do
        # 過去30日のうち、10日間を達成状態にする
        (0..9).each do |i|
          create(:progress, habit: habit, date: Date.today - i.days, status: '達成')
        end
      end

      it '直近30日間の達成日数を正しく計算すること' do
        expect(habit.achieved_days_last_30_days).to eq(10)
      end
    end

    describe '#progress_rate' do
      let(:habit) { create(:habit) }

      before do
        # 直近30日間のうち15日達成にする
        (0..14).each do |i|
          create(:progress, habit: habit, date: Date.today - i.days, status: '達成')
        end
      end

      it '進捗率を正しく計算すること' do
        expect(habit.progress_rate).to eq(50) # 15/30日で50%
      end
    end
  end
end
