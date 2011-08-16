class CatalogueController < ApplicationController
  
  before_filter :find_basket
  
  def search
    if params[:q]
      @query = session[:q] = params[:q]
    else
      @query = session[:q]
    end
    @limit = 100
    @page_title = "Items matching '#{@query}'"
    if @query
      @products = Product.filter(:concatprod.like("%#{@query}%")).
        left_join(BasketItem, :product_code => :code, :session_id => request.session_options[:id]).limit(@limit) 
      flash.now[:notice] = "Showing only the first #{@limit} products. Perhaps use a more specific search?" if @products.count == @limit
    end
  end
  
  def basket
    @page_title = "Your shopping basket"
    @query = session[:q]
    find_basket
  end
  
  def update_basket
    increment = params[:increment].to_i
    attributes = {
      :product_code => params[:product_code],
      :session_id => request.session_options[:id]
    }
    filter = BasketItem.filter(attributes)
    if filter.empty?
      BasketItem.insert(attributes.merge(:quantity => increment)) if increment > 0
    else
      BasketItem.filter(attributes).update(:quantity => :quantity + increment)
    end
    BasketItem.filter(attributes.merge(:quantity => 0)).delete
    respond_to do |format|
      find_basket
      format.js do
        render :js => { 
          :product_code => params[:product_code], 
          :increment => increment, 
          :basket_count => view_context.pluralize(@basket_count, 'item'),
          :basket_total => view_context.number_with_precision(@basket_total, :precision => 2) }.to_json
      end
    end
  end
  
  def clear_basket
    BasketItem.filter(:session_id => request.session_options[:id]).delete
    flash[:info] = 'Your basket has been emptied.'
    redirect_to root_url(:q => session[:q])
  end
  
  def send_order
    if params[:email] && !params[:email].blank?
      find_basket
      OrderMailer.confirm(params[:email], 
        :products => @basket, 
        :count => @basket_count,
        :total => @basket_total).deliver
      flash[:notice] = 'We have sent your order. Please check your email inbox.'
    else
      flash[:error] = 'Please enter an email address!'
    end
    redirect_to :back
  end
  
  protected
  
  def find_basket
    @basket = Product.join(BasketItem, :product_code => :code, :session_id => request.session_options[:id])
    @basket_count = @basket.count
    @basket_total = @basket.inject(0){|sum, p| sum + p[:quantity] * p[:price] }
  end
end
