class OrderCreationService
  def initialize(seller, params)
    @params = params
    @seller = seller
  end

  def call
    products = @params[:products].split(/,/).map { |id| Product.find(id) }
    raise Exceptions::NoProductsFound, "Order can't be created without products" if products.empty?

    Order.transaction do
      customer = set_customer

      order = Order.create!(seller: @seller, customer: customer, status: @params[:status])
      order.products << products
      order
    end
  end

  private

  def set_customer
    if @params[:customer_id].blank?
      Customer.create!(name: @params[:customer_name], account: @seller.account)
    else
      @seller.account.customers.find(@params[:customer_id])
    end
  end
end
