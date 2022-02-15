class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices


  def self.find_merchant_by_name(search)
    Merchant.where("name ILIKE ?", "%#{search}%" )
    #can take out Merchant (self)
            .order(:name)
            .limit(1)
  end

  def self.top_merchants_by_revenue(number)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    # GET /api/v1/revenue/merchants?quantity=x
    #can take out Merchant (self)
            .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
            .select("SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue, merchants.*")
            .group(:id)
            .order(total_revenue: :desc)
            .limit(number)
  end

  def self.top_merchants_by_items_sold(quantity)
    # GET /api/v1/merchants/most_items?quantity=x
    #can take out Merchant (self)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
            .select("SUM(invoice_items.quantity) as items_sold, merchants.*")
            .order(items_sold: :desc)
            .group(:id)
            .limit(quantity)
            # Merchant.joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: 'success'}, invoices: {status: 'shipped'}).select("SUM(invoice_items.quantity) as quantity_sold, merchants.*").order(quantity_sold: :desc).group(:id).limit(5)
  end
end
