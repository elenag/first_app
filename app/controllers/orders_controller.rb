class OrdersController < ApplicationController
  def search
  end

  def review
    render(:text => 'Hello Everyone')
  end

  def confirm
  end

  def list_all
    @orders = Order.order("orders.created_at")
  end

  def show_current
    @order = Order.find(params[:id])
  end
end
