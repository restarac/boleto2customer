class Boleto < ActiveRecord::Base
  belongs_to :user

  validates :due_date, presence: true

  include GoogleApi
end
