require "rails_helper"

describe "Merchant Coupon endpoints", :type => :request do 

  it  "can SHOW a Coupon" do 
    merchant = Merchant.create!(name: "Test Merchant")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00)
    get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

    expect(response).to have_http_status(:ok)
  end
end