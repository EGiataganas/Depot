class Order < ActiveRecord::Base
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]
  validates :name, :address, :email, presence: true
  validates :pay_tupe, inclusion: PAYMENT_TYPES
end
