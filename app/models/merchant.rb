class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices


  def self.find_merchant_by_name(search)
    where("name ILIKE ?", "%#{search}%" )
    .order(:name)
    .limit(1)
  end

  def self.top_merchants_by_revenue(number)
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select("SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue, merchants.*")
    .group(:id)
    .order(total_revenue: :desc)
    .limit(number)
  end

  def self.top_merchants_by_items_sold(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select("SUM(invoice_items.quantity) as items_sold, merchants.*")
    .order(items_sold: :desc)
    .group(:id)
    .limit(quantity)
  end
end
