class Api::V1::CouponsController < ApplicationController

  def index
    coupons = filter_coupons(get_coupons, params[:status])
    render json: CouponSerializer.new(coupons)
  end

  def active 
    coupons = filter_coupons(get_coupons, 'active')
    render json: CouponSerializer.new(coupons)
  end

  def inactive 
    coupons = filter_coupons(get_coupons, 'inactive')
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
    render json: CouponSerializer.new(coupon, { params: {include_usage_count: true}})
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

  def get_coupons
    if params[:merchant_id]
      Merchant.find(params[:merchant_id]).coupons
    else
      Coupon.all
    end
  end

  def filter_coupons(coupons, status)
    case status
    when 'active'
      coupons.where(status: 'active')
    when 'inactive'
      coupons.where(status: 'inactive')
    else
      coupons
    end
  end
end