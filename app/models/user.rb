require 'digest/md5'

class User < ActiveRecord::Base
  include Clearance::User

  has_many :boletos, dependent: :destroy

  #Acts like `subordinates`
  has_many :sendable_customers, class_name: "User", foreign_key: "sender_user_id" 
  #Acts like `manager`
  belongs_to :sender_origin, class_name: "User"

  def send_boleto from_user, due_date, sender_origin_email
    sendable_user = User.find(to_user)
    sendable_user.boletos.create(due_date: due_date, sender_origin_email: current_user.email)
  end

  def avatar_url
    hash = Digest::MD5.hexdigest(normalize_email)     
    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end
end
