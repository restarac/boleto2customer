require 'digest/md5'

class User < ActiveRecord::Base
  include Clearance::User

  has_many :boletos, dependent: :destroy

  #Acts like `subordinates`
  has_many :sendable_customers, class_name: "User", foreign_key: "sender_user_id" 
  #Acts like `manager`
  belongs_to :sender_origin, class_name: "User", foreign_key: "sender_user_id" 

  def has_sender?
    !sender_origin.nil?
  end

  def sender_email
    sender_origin.email if has_sender?
  end

  def sender_id
    sender_origin.id if has_sender?
  end

  def update_sender current_user, sender_origin_id
    user = User.find(current_user.id)
    user.sender_origin = User.find(sender_origin_id)
    user.save
  end

  def avatar_url
    hash = Digest::MD5.hexdigest(normalize_email)     
    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end
end
