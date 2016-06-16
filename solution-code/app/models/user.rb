class User < ActiveRecord::Base

  BCrypt::Engine.cost = 12

  validates :email, presence: true, uniqueness: true

  def self.confirm(email, password)
    user = User.find_by_email(email)
    user.authenticate(password)
  end

  has_secure_password

  ## refactor below with `has_secure_password`
  
  # validates :password_digest, presence: true
  # validates :password, confirmation: true

  # def authenticate(plain_text_password)
  #   BCrypt::Password.new(self.password_digest) == plain_text_password ? self : false
  # end

  # def password=(unencrypted_password)
  #   #raise scope of password to instance
  #   @password = unencrypted_password
  #   self.password_digest = BCrypt::Password.create(@password)
  # end

  # def password
  #   #get password, equivalent to `attr_reader :password`
  #   @password
  # end


end