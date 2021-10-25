class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i # const
  validates :email, uniqueness: { case_sensitive: false },
                    presence: true,
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :username, uniqueness: { case_sensitive: false },
                        presence: true,
                        length: { minimum: 3, maximum: 25 }
  has_secure_password

  # Вариант 1: Полное переопределение метода #as_json
  def as_json(options={})
    { :username => self.username, :id => self.id}  # НЕ включаем поле email
  end
end
