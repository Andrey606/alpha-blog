class UserSerializer < SimpleUserSerializer
  attributes :email

  has_many :articles

end
