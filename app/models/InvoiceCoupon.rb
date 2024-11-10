class InvoiceCoupon < ApplicationRecord
    belongs_to :invoice
    belongs_to :coupon
end