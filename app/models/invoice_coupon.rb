class Invoice_Coupon < ApplicationRecord
    belongs_to :invoice
    belongs_to :coupon
end