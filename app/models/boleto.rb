class Boleto < ActiveRecord::Base
  belongs_to :user

  scope :from_user, -> user {where(sender_origin_email: user.email).order('id asc').limit(10)}
  scope :to_user, -> user {where(user: user).order('id asc').limit(10)}
  scope :find_for_this_user, -> user, boleto_id { where("(user_id = ? OR sender_origin_email = ? ) AND id = ?" , user, user.email, boleto_id) }

  validates :due_date, :sender_origin_email, :user, :barcode, presence: true

  include GoogleApi

  def can_delete?
    false
  end

  def sender_email
    user.email if !user.nil?
  end

  def sender
    user
  end

  def formated_due_date
    due_date.strftime("%d/%m/%Y")
  end

  def origin_email
    sender_origin_email
  end
end
