class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teams, foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  has_many :teams, through: :assigns
  has_many :articles, dependent: :destroy
  has_many :agendas, dependent: :destroy

  mount_uploader :icon, ImageUploader

  def self.find_or_create_by_email(email)
    if email.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      user = find_or_initialize_by(email: email)
      if user.new_record?
        user.password = generate_password
        user.save
      end
      user
    else
      user
    end
  end

  def self.generate_password
    SecureRandom.hex(10)
  end
end
