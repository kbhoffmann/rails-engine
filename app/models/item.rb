class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  #validate numericality too
  validates :merchant_id, presence: true

  def self.find_all_items_by_name(search)
    Item.where("name ILIKE ?", "%#{search}%" )
  end
end
