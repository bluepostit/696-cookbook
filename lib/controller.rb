require_relative 'view'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # get recipes from the cookbook (repository)
    # send to view to display to user
    recipes = @cookbook.all
    @view.list(recipes)
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
end
