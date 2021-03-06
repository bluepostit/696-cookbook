require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    store_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    store_csv
  end

  private

  def load_csv
    csv_options = {
      headers: :first_row,
      header_converters: :symbol
    }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      row[:rating] = row[:rating].to_i
      recipe = Recipe.new(row)
      # add to @recipes array
      @recipes << recipe
    end
  end

  def store_csv
    csv_options = {
      col_sep: ',',
      quote_char: '"',
      force_quotes: true
    }
    CSV.open(@csv_file_path, 'wb', csv_options) do |csv|
      csv << %w[name description rating prep_time]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time]
      end
    end
  end
end
