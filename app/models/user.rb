class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy
  has_many :api_keys
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i # const
  validates :email, uniqueness: { case_sensitive: false },
                    presence: true,
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :username, uniqueness: { case_sensitive: false },
                        presence: true,
                        length: { minimum: 3, maximum: 25 }
  has_secure_password
end
