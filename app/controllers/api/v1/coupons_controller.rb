class Api::V1::CouponsController < ApplicationController
  def index
    
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.new(coupon_params)
    coupon.save
    render json: CouponSerializer.new(coupon), status: :created
  end

  def show 
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def update 
    coupon = Coupon.find(params[:id])
      if !coupon_code[:merchant_id].nil?
          merchant = Merchant.find(coupon_params[:merchant_id])
          render json: ErrorSerializer.format_errors(["Invalid merchant"]), status: :not_found if merchant.nil?
      end
      coupon.update(coupon_params)
      coupon.save

      render json: CouponSerializer.new(coupon), status: :ok
  end

    private

    def coupon_params
        params.permit(:name, :coupon_code, :value, :status, :merchant_id)
    end
end