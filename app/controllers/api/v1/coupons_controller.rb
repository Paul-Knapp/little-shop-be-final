class Api::V1::CouponsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    
    if Merchant.has_five_active_coupons?(params[:merchant_id])
      render json: ErrorSerializer.format_errors(["Merchant has too many active Coupons"]), status: :unprocessable_entity
    else
      coupon = Coupon.create!(coupon_params)
      render json: CouponSerializer.new(coupon), status: :created
    end
  end

  def show 
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def update 
    coupon = Coupon.find(params[:id])
      if !coupon[:merchant_id].nil?
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