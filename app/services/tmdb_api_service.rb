require 'uri'
require 'net/http'

class TmdbApiService < ApplicationService
  def initialize(action:, movie_id: nil, opts: {})
    @action = action
    @movie_id = movie_id
    @opts = opts
  end

  def call
    response = send_request
    JSON.parse(response.body)
  end

  private

  def send_request
    url = URI("#{Settings.tmdb.url}/3/#{path}?#{http_params}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = "Bearer #{Settings.tmdb.api_read_access_token}"

    http.request(request)
  end

  def http_params
    params = { language: 'en-US', region: 'UA' }
    params.merge!(@opts)
    params.to_query
  end

  def path
    {
      now_playing: 'movie/now_playing',
      upcoming: 'movie/upcoming',
      search: 'search/movie',
      details: "movie/#{@movie_id}",
      credits: "movie/#{@movie_id}/credits"
    }[@action]
  end
end
