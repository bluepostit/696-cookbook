class Recipe
  attr_reader :name, :description, :rating

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating] || 0
  end
end
