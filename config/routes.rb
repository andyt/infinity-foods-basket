Infinity::Application.routes.draw do
  root :to => 'catalogue#search'
  match 'basket', :to => 'catalogue#basket'
  match 'update_basket', :to => 'catalogue#update_basket'
  match 'clear_basket', :to => 'catalogue#clear_basket'
  match 'send_order', :to => 'catalogue#send_order'
end
