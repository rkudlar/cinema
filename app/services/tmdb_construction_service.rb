class TmdbConstructionService < ApplicationService
  def initialize(external_id:)
    @external_id = external_id
  end

  def call
    Movie.new({ external_id: @external_id }.merge(movie_data, credits_data))
  end

  private

  def movie_data
    attributes = TmdbApiService.call(action: :details, movie_id: @external_id)
    {
      title: attributes['title'],
      description: attributes['overview'],
      genre: attributes['genres'].map { |genre| genre['name'] },
      duration: attributes['runtime'],
      countries: attributes['production_countries'].map { |country| country['name'] },
      release_date: DateTime.parse(attributes['release_date']),
      poster_path: attributes['poster_path']
    }
  end

  def credits_data
    attributes = TmdbApiService.call(action: :credits, movie_id: @external_id)
    {
      directors: attributes['crew'].filter_map { |crew| crew['name'] if crew['job'] == 'Director' },
      actors: attributes['cast'].map{ |actor| actor['name'] }
    }
  end
end
