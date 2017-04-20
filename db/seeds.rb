# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'json'

Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

puts "getting ingredients"
url_ingredients = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients = open(url_ingredients).read

ingredients_hash = JSON.parse(ingredients)

puts "adding ingredients"
ingredients_hash['drinks'].each do |ingredient|
  Ingredient.create(name: ingredient["strIngredient1"])
end

puts "finished adding ingredients"


puts "creating 10 drinks"


  url_drink = 'http://www.thecocktaildb.com/api/json/v1/1/random.php'
  drink = open(url_drink).read

  drink_hash = JSON.parse(drink)

  drink_name = drink_hash['drinks'].first["strDrink"]
  drink_ingredients = drink_hash['drinks'].first.select { |k,v| k.match(/strIngredient/) && v != "" }.values
  drink_measures = drink_hash['drinks'].first.select { |k,v| k.match(/strMeasure/) && v != " " && v != "" }.values

  cocktail = Cocktail.new(name: drink_name)

  ingredients = drink_ingredients.map { |name| Ingredient.find_by(name: name) }
  cocktail.ingredients = ingredients
  cocktail.save



  # Dose.where(cocktail_id: Cocktail.find_by(name: cocktail.name).id).each_with_index do |dose, index|
  #     p dose
  #     p drink_measures[index].strip
  #   end


# drink_name = "Waikiki Beachcomber"
# drink_ingredients = ["Triple sec", "Gin", "Pineapple juice"]
# drink_measures = ["3/4 oz ", "3/4 oz ", "1 tblsp "]
