class User < ActiveRecord::Base

  attr_accessor :password, :terms
  attr_accessible :fullname, :username, :email, :fb_id, :password, :terms


  validates :fullname, :presence      => true,
                       :length        => { :within => 2..50 }

  validates :username, :presence      => true,
                       :uniqueness    => true,
                       :length        => { :within => 2..50 }

  validates :email,    :presence    => true,
                       :length      => {:minimum => 5, :maximum => 254},
                       :uniqueness  => true,
                       :format      => {:with => /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/}

  validates :password, :presence      => true,
                       :length        => { :within => 5..40 }

  validates_acceptance_of  :terms, :message => " - Accepting the Privacy Policy / Terms is mandatory for the registration!"


  has_many :notifications, :dependent => :destroy
  
  has_many :products, :through => :followers, :source => :product

  before_save :encrypt_password


  scope :admin, where(:admin => true)


  def to_param
    username
  end

  def image_url
    url = 'http://www.gravatar.com/avatar/'
    url += Digest::MD5.hexdigest(email.strip.downcase)
    url
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, coockie_salt)
    user = find_by_id(id)
    ( user && user.salt == coockie_salt ) ? user : nil
  end

  def update_from_fb_json (json_user)
    self.fullname = json_user['name']
    self.username = json_user['username']
    self.email = json_user['email']
    self.fb_id = json_user['id']
    self.password = create_random_value
  end

  private

    def create_random_value
      chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
      value = ""
      10.times { value << chars[rand(chars.size)] }
      value
    end

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def encrypt(string)
      p "#{salt}--#{string}"
      secure_hash("#{salt}--#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end