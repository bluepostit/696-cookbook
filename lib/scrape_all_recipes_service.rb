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
    divs.first(5).map { |div| build_recipe(div) }
  end

  def build_recipe(div)
    # get name & description
    # build a Recipe object with this data and return it
    name = div.search('h3').text.strip
    description = div.search('.card__summary').text.strip
    rating = div.search('.rating-star.active').count
    prep_time = scrape_prep_time(div)
    Recipe.new(
      name: name,
      description: description,
      rating: rating,
      prep_time: prep_time
    )
  end

  # load the div's linked url, scrape the prep time, and return it
  def scrape_prep_time(div)
    link = div.search('.card__titleLink.manual-link-behavior').first
    url = link.attributes['href'].value
    html = URI.open(url).read
    doc = Nokogiri::HTML(html, nil, 'utf-8')

    regex = /total:\W+([\w\s+]+)\s+/i
    recipe_info = doc.search('.recipe-info-section').text.strip
    match_data = recipe_info.match(regex)
    match_data ? match_data[1].strip : ''
  end
end
