class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant_by_name(search)
    Merchant.where("name ILIKE ?", "%#{search}%" ).limit(1)
  end
end
