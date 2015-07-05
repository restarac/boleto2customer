# include MD5 gem, should be part of standard ruby install
require 'digest/md5'

class User < ActiveRecord::Base
  include Clearance::User

  has_many :boletos, dependent: :destroy

  def avatar_url
    hash = Digest::MD5.hexdigest(normalize_email)     
    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end
end
