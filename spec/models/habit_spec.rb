require 'rails_helper'

RSpec.describe Habit, type: :model do
  let(:fixed_today) { Date.new(2025, 3, 20) }
  let(:habit) { build(:habit, start_date: fixed_today) }

  before do
    allow(Date).to receive(:today).and_return(fixed_today)
  end

  describe 'バリデーション' do
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

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:progresses).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe 'インスタンスメソッド' do
    let(:habit) { create(:habit, start_date: fixed_today) }

    describe '#continuous_days' do
      before do
        create(:progress, habit: habit, date: fixed_today, status: '達成')
        create(:progress, habit: habit, date: fixed_today - 1.day, status: '達成')
        create(:progress, habit: habit, date: fixed_today - 2.days, status: '達成')
        create(:progress, habit: habit, date: fixed_today - 3.days, status: '未達成')
      end

      it '連続達成日数を正しく計算すること' do
        expect(habit.continuous_days).to eq(3)
      end
    end

    describe '#achieved_days_last_30_days' do
      before do
        (0..9).each do |i|
          create(:progress, habit: habit, date: fixed_today - i.days, status: '達成')
        end
      end

      it '直近30日間の達成日数を正しく計算すること' do
        expect(habit.achieved_days_last_30_days).to eq(10)
      end
    end

    describe '#progress_rate' do
      before do
        (0..14).each do |i|
          create(:progress, habit: habit, date: fixed_today - i.days, status: '達成')
        end
      end

      it '進捗率を正しく計算すること' do
        expect(habit.progress_rate).to eq(50)
      end
    end
  end
end
