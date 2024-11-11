require "rails_helper"

describe "Merchant Coupon endpoints", :type => :request do 

  it "can CREATE a Coupon" do 
    merchant = Merchant.create!(name: "Test Merchant")
    name = "Buy One Get One 50"
    coupon_code = "BOGO50"
    value = 10.00
    status = "active"
    body = {
      name: name,
      coupon_code: coupon_code,
      value: value,
      status: status
    }

    post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:created)

    
  end

  it  "can SHOW a Coupon" do 
    merchant = Merchant.create!(name: "Test Merchant")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
    get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"
    binding.pry
    
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data][:type]).to eq("coupon")
    expect(json[:data][:id]).to eq(coupon.id.to_s)
  end
end