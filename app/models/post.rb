class Post < ApplicationRecord
  belongs_to :user
  belongs_to :habit
  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }

  def self.ransackable_attributes(auth_object = nil)
    %w[content created_at id updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
