class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :coupon_code
      t.decimal :value

      t.timestamps
    end
  end
end
