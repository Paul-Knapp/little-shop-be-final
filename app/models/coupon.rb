class Coupon < ApplicationRecord
    validates_presence_of :name, presence: true
    validates_presence_of :coupon_code, presence: true
    validates_presence_of :value, presence: true
    belongs_to :merchant
    has_many :invoice_coupons
    has_many :invoices, through: :invoice_coupons
end