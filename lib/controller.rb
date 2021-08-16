require 'open-uri'
require 'nokogiri'

require_relative 'view'

BASE_URL = 'https://www.allrecipes.com/search/results/?search='

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # get recipes from the cookbook (repository)
    # send to view to display to user
    recipes = @cookbook.all
    @view.display(recipes)
  end

  def create
    # get recipe name
    # get recipe description
    # create a new Recipe object!
    # add it to the cookbook (repository)
    name = @view.ask_user_for('name')
    description = @view.ask_user_for('description')
    recipe = Recipe.new(name, description)
    @cookbook.add_recipe(recipe)
  end

  def destroy
    # display all recipes
    # ask user for number ('index')
    # ask cookbook to delete recipe at this index
    list
    index = @view.ask_user_for_index
    @cookbook.remove_recipe(index)
  end

  def import
    # Ask a user for a keyword to search
    # Make an HTTP request to the recipes website with our keyword
    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
    # Display them in an indexed list
    # Ask the user which recipe they want to import (ask for an index)
    # Add it to the Cookbook
    keyword = @view.ask_user_for('keyword to search for')
    url = "#{BASE_URL}#{keyword}"
    html = URI.open(url).read
    doc = Nokogiri::HTML(html, nil, 'utf-8')

    # We want an array of Recipe objects! Super convenient to use
    divs = doc.search('.card__detailsContainer') # => array of elements
    results = divs.first(5).map do |div|
      # get name & description
      # build a Recipe object with this data and return it
      name = div.search('h3').text.strip
      description = div.search('.card__summary').text.strip
      Recipe.new(name, description)
    end

    @view.display(results)
    index = @view.ask_user_for_index
    recipe = results[index]
    @cookbook.add_recipe(recipe)
  end
end
