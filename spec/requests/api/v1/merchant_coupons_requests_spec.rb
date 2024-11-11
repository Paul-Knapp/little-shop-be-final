require "rails_helper"

describe "Merchant Coupon endpoints", :type => :request do 

  describe "CREATE coupon" do
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
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:coupon_code]).to eq(coupon_code)
  end

  it "can display an error when fields are missing" do
    merchant = Merchant.create!(name: "Test Merchant")
    coupon_code = "BOGO50"
    status = "active"
    body = {
      coupon_code: coupon_code,
      status: status
    }

    post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
    json = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to have_http_status(:unprocessable_entity)

  end

  it "cant create coupons with non unique coupon_codes" do 
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
    expect(response).to have_http_status(:created)

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
    expect(response).to_not have_http_status(:created)
  end

  it "cant create active coupons if merchant has 5 active coupons" do
    merchant = Merchant.create!(name: "Test Merchant")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO5", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOG", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BO", value: 10.00, status: "active")

    name = "Buy One Get One 50"
    coupon_code = "BOGOFAIL"
    value = 10.00
    status = "active"
    body = {
      name: name,
      coupon_code: coupon_code,
      value: value,
      status: status
    }

    post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
    expect(response).to_not have_http_status(:created)
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "can create active coupons if merchant has inactive coupons" do 
    merchant = Merchant.create!(name: "Test Merchant")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "inactive")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO5", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOG", value: 10.00, status: "active")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BO", value: 10.00, status: "active")

    name = "Buy One Get One 50"
    coupon_code = "BOGOFAIL"
    value = 10.00
    status = "active"
    body = {
      name: name,
      coupon_code: coupon_code,
      value: value,
      status: status
    }

    post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
    expect(response).to have_http_status(:created)
    expect(response).to_not have_http_status(:unprocessable_entity)
  end
end

  it  "can SHOW a Coupon" do 
    merchant = Merchant.create!(name: "Test Merchant")
    coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
    get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"
  
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data][:type]).to eq("coupon")
    expect(json[:data][:id]).to eq(coupon.id.to_s)
  end

  describe "Merchant coupons INDEX" do
    it "can INDEX a merchants coupons" do 
      merchant1 = Merchant.create!(name: "Test Merchant1")
      merchant2 = Merchant.create!(name: "Test Merchant2")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
      coupon2 = merchant2.coupons.create!(name: "Buy One Get One 20", coupon_code: "BOGO20", value: 10.00, status: "active")
      coupon3 = merchant2.coupons.create!(name: "Buy One Get One 25", coupon_code: "BOGO25", value: 10.00, status: "active")
  
      get "/api/v1/merchants/#{merchant1.id}/coupons"
      json1 = JSON.parse(response.body, symbolize_names: true)
  
  
      get "/api/v1/merchants/#{merchant2.id}/coupons"
      json2 = JSON.parse(response.body, symbolize_names: true)
    
      expect(json1[:data][0][:attributes][:name]).to eq("Buy One Get One 50")
      expect(json2[:data][0][:attributes][:name]).to eq("Buy One Get One 20")
      expect(json2[:data][1][:attributes][:name]).to eq("Buy One Get One 25")
    end

    it "can desplay an error when the Merchant doesnt exist" do
      merchant1 = Merchant.create!(name: "Test Merchant1")
      merchant2 = Merchant.create!(name: "Test Merchant2")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
      coupon2 = merchant2.coupons.create!(name: "Buy One Get One 20", coupon_code: "BOGO20", value: 10.00, status: "active")
      coupon3 = merchant2.coupons.create!(name: "Buy One Get One 25", coupon_code: "BOGO25", value: 10.00, status: "active")

      get "/api/v1/merchants/10000/coupons"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "it can UPDATE coupons" do
    it "can update coupons when givin correct information" do 
      merchant = Merchant.create!(name: "Test Merchant")
      coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
      name = "Buy One Get One 984"
      coupon_code = "BOGOFAIL"
      value = 10.00
      status = "active"
      body = {
        name: name,
        coupon_code: coupon_code,
        value: value,
        status: status
      }
      patch"/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: body, as: :json
      updated = JSON.parse(response.body, symbolize_names: true)

      expect(updated[:data][:attributes][:name]).to eq("Buy One Get One 984")
    end

    it "can show an ERROR when invalid Merchant is givin" do
      merchant = Merchant.create!(name: "Test Merchant")
      coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
      name = "Buy One Get One 984"
      coupon_code = "BOGOFAIL"
      value = 10.00
      status = "active"
      body = {
        name: name,
        coupon_code: coupon_code,
        value: value,
        status: status
      }
      patch"/api/v1/merchants/30000/coupons/#{coupon.id}", params: body, as: :json
      updated = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
    end

    it "can show an ERROR when invalid Coupon is givin" do
      merchant = Merchant.create!(name: "Test Merchant")
      coupon = merchant.coupons.create!(name: "Buy One Get One 50", coupon_code: "BOGO50", value: 10.00, status: "active")
      name = "Buy One Get One 984"
      coupon_code = "BOGOFAIL"
      value = 10.00
      status = "active"
      body = {
        name: name,
        coupon_code: coupon_code,
        value: value,
        status: status
      }
      patch"/api/v1/merchants/#{merchant.id}/coupons/300", params: body, as: :json
      updated = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
    end
  end
end