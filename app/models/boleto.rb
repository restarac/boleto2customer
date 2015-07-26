class Boleto < ActiveRecord::Base
  belongs_to :user

  scope :from_user, -> user {where(sender_origin_email: user.email)}
  scope :to_user, -> user {where(user: user)}

  validates :due_date, :sender_origin_email, :user, :barcode, presence: true

  include GoogleApi

  def can_delete?
    false
  end
end
