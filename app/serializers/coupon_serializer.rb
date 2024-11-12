class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :coupon_code, :value, :status

  attribute :usage_count do |coupon|
    coupon.usage_count
  end
end
