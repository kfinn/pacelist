# frozen_string_literal: true

require 'net/http'
require 'base64'
require 'json'

class SpotifyClientCredentialsMiddleware < Faraday::Middleware
  attr_accessor :spotify_client_credentials

  def on_request(env)
    request_spotify_credentials =
      if User.authenticated_user.present?
        User.authenticated_user.spotify_credentials
      else
        SpotifyCredentials.client_credentials
      end

    env.request_headers['Authorization'] = "#{request_spotify_credentials.token_type} #{request_spotify_credentials.access_token}"
  end
end

SPOTIFY_CONNECTION = Faraday.new(url: 'https://api.spotify.com/v1') do |c|
  c.use SpotifyClientCredentialsMiddleware
  c.request :json
  c.response :json
end
