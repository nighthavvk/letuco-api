class CreateJoinTableShopSeller < ActiveRecord::Migration[5.2]
  def change
    create_join_table :shops, :sellers do |t|
      t.index [:shop_id, :seller_id]
      t.index [:seller_id, :shop_id]
    end
  end
end
