class Coupon < ApplicationRecord
    validate_presence_of :name
    validate_presence_of :coupon_code
    validate_presence_of :value
    belongs_to :merchant
end