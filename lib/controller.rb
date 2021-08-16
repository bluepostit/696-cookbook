require_relative 'view'
require_relative 'scrape_all_recipes_service'

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
    rating = @view.ask_user_for_rating
    recipe = Recipe.new(
      name: name,
      description: description,
      rating: rating
    )
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
    results = ScrapeAllRecipesService.new(keyword).call

    @view.display(results)
    index = @view.ask_user_for_index
    recipe = results[index]
    @cookbook.add_recipe(recipe)
  end
end
