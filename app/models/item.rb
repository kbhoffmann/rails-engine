class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  #validate numericality too
  validates :merchant_id, presence: true

  def self.find_all_items_by_name(name)
    Item.where("name ILIKE ?", "%#{name}%" )
  end

  def self.find_all_items_by_min_price(min_price)
    Item.where('unit_price >= 50')
  end

  def self.find_all_items_by_max_price(max_price)
    Item.where('unit_price <= 150')
  end

  def self.find_all_items_by_price_range(min_price, max_price)
    Item.where('unit_price >= 50 AND unit_price <= 150')
  end
end
