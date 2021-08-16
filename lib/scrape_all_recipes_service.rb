require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.allrecipes.com/search/results/?search='

class ScrapeAllRecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    # Scrape AllRecipes and give me an array of Recipe objects!
    url = "#{BASE_URL}#{@keyword}"
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
    results
  end
end
