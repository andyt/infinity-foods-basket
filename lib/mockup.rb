#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

require 'rubygems'
require 'sequel'
require 'fastercsv'

DATAFILE = File.dirname(__FILE__) + '/../tmp/data/infinity_catalogue.csv' 

# connect to an in-memory database
DB = Sequel.sqlite

# create an items table
DB.create_table :items do
  Integer :code
  String :concatsize
  Boolean :organic
  String :concatprod
  Float :rrp
  String :brand
  Float :price
end

# create a dataset from the items table
Product = DB[:items]

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

puts "DB populated!"

# print out the number of records
puts "Item count: #{Product.count}"

# print out the average price
puts "The average price is: #{Product.avg(:price)}"
puts "The average RRP is: #{Product.avg(:rrp)}"

#concatsizes = Product.distinct.select(:concatsize)
#puts "Distinct concatsizes are: #{concatsizes.collect { |r| r[:concatsize] }.join(", ")}"

barley_flakes = Product.filter(:concatprod.like('%barley flakes%')).select(:concatsize, :concatprod)
puts "Barley flakes are:\n#{barley_flakes.collect { |r| "%s, %s" % [r[:concatprod], r[:concatsize]] }.join("\n")}"