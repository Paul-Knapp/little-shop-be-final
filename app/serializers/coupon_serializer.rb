class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :coupon_code, :value, :status
end
