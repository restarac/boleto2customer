require 'digest/md5'

class User < ActiveRecord::Base
  include Clearance::User

  has_many :boletos, dependent: :destroy

  #Acts like `subordinates`
  has_many :sendable_customers, class_name: "User", foreign_key: "sender_user_id" 
  #Acts like `manager`
  belongs_to :sender_origin, class_name: "User", foreign_key: "sender_user_id" 

  def avatar_url
    hash = Digest::MD5.hexdigest(normalize_email)     
    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end
end
