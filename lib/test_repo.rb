require_relative 'cookbook'

csv_file_path = 'lib/recipes.csv'
cookbook = Cookbook.new(csv_file_path)

p cookbook.all

# Add a recipe
recipe = Recipe.new('pancakes', 'delicious breakfast')
cookbook.add_recipe(recipe)

cookbook.remove_recipe(0)
