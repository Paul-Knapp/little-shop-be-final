class Coupon < ApplicationRecord
    validates :name, presence: true
    validates :coupon_code, presence: true, uniqueness: true
    validates :value, presence: true, numericality: { greater_than: 0}
    validates :status, presence: true, inclusion: { in: [ "active", "inactive"]}
    belongs_to :merchant
    has_many :invoice_coupons
    has_many :invoices, through: :invoice_coupons
end