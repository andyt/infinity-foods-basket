# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Infinity::Application.initialize!


# load the DB
require 'rubygems'
require 'sequel'
require 'fastercsv'

DATAFILE = File.dirname(__FILE__) + '/../tmp/data/infinity_catalogue.csv' 

# connect to an in-memory database
DB = Sequel.sqlite

# create an items table
DB.create_table :products do
  Integer :code
  String :concatsize
  Boolean :organic
  String :concatprod
  Float :rrp
  String :brand
  Float :price
end

DB.create_table :basket_items do
  Integer :session_id
  Integer :product_code
  Integer :quantity
end

# create a dataset from the items table
Product = DB[:products]
BasketItem = DB[:basket_items]

# populate the table from sheet
FasterCSV.open(DATAFILE, :headers => true).each do |row|
  Product.insert(
    :code => row[1],
    :concatsize => row[2],
    :organic => row[3] == 'organic',
    :concatprod => row[4], 
    :rrp => row[5],
    :brand => row[6],
    :price => row[8]
  )
end