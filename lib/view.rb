class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.name} (#{recipe.description}) [#{recipe.rating}] - #{recipe.prep_time}"
    end
  end

  def ask_user_for(thing)
    puts "Please enter the #{thing}:"
    gets.chomp
  end

  def ask_user_for_rating
    ask_user_for('rating').to_i
  end

  def ask_user_for_index
    ask_user_for('recipe number').to_i - 1
  end
end
