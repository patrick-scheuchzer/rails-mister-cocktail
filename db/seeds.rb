require 'open-uri'
require 'json'

Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

# Ingredients Import from 'thecocktaildb'
puts "getting ingredients..."

url_ingredients = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients = open(url_ingredients).read
ingredients_hash = JSON.parse(ingredients)

puts "adding ingredients..."

ingredients_hash['drinks'].each do |ingredient|
  Ingredient.create(name: ingredient["strIngredient1"])
end

puts "Added ingredients!"

# Import of 10 random drinks from 'thecocktaildb'
puts "getting 10 drinks..."

drinks = []

10.times do
  url_drink = 'http://www.thecocktaildb.com/api/json/v1/1/random.php'
  drink = open(url_drink).read
  drink_hash = JSON.parse(drink)

  # sample drink_name --> "Waikiki Beachcomber"
  drink_name = drink_hash['drinks'].first["strDrink"]
  # sample drink_ingredients --> ["Triple sec", "Gin", "Pineapple juice"]
  drink_ingredients = drink_hash['drinks'].first.select { |k,v| k.match(/strIngredient/) && v != "" }.values
  # sample drink_measures --> ["3/4 oz", "3/4 oz", "1 tblsp"]
  drink_measures = drink_hash['drinks'].first.select { |k,v| k.match(/strMeasure/)}.first(drink_ingredients.size).map { |measure| measure.last.strip }

  drinks << { name: drink_name, doses: drink_ingredients.zip(drink_measures).map { |dose| { ingredient: dose.first, description: dose.last }} }
end

puts "creating drinks and doses..."

drinks.each do |drink|
  cocktail = Cocktail.create(name: drink[:name])
  drink[:doses].each do |dose|
    Ingredient.create(name: dose[:ingredient]) unless Ingredient.find_by(name: dose[:ingredient])
    ingredient = Ingredient.find_by(name: dose[:ingredient])
    Dose.create(description: dose[:description], ingredient: ingredient, cocktail: cocktail)
  end
end

puts "Added drinks and doses!"
