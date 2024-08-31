# frozen_string_literal: true

class SpotifyCredentials
  def self.for_client
    spotify_client_credentials_response = Net::HTTP.post(
      URI('https://accounts.spotify.com/api/token'),
      { grant_type: 'client_credentials' }.to_query,
      CREDENTIALS_HEADERS
    )

    new(JSON.parse(spotify_client_credentials_response.body))
  end

  def self.for_user(user)
    spotify_refresh_token_repsonse = Net::HTTP.post(
      URI('https://accounts.spotify.com/api/token'),
      {
        grant_type: 'refresh_token',
        refresh_token: user.spotify_credential_refresh_token,
        client_id: Rails.application.credentials.spotify_client_id
      }.to_query,
      CREDENTIALS_HEADERS
    )

    new(JSON.parse(spotify_refresh_token_repsonse.body))
  end

  attr_reader :attributes, :created_at

  def initialize(attributes)
    @attributes = attributes.with_indifferent_access
    @created_at = Time.zone.now
  end

  def access_token
    attributes.fetch(:access_token)
  end

  def token_type
    attributes.fetch(:token_type)
  end

  def expires_in
    attributes.fetch(:expires_in)
  end

  CREDENTIALS_HEADERS = {
    'Content-Type': 'application/x-www-form-urlencoded',
    Authorization: "Basic #{
      Base64.strict_encode64(
        "#{Rails.application.credentials.spotify_client_id}:#{Rails.application.credentials.spotify_client_secret}"
      )
    }"
  }.freeze

  def valid?
    Time.zone.now < (created_at + expires_in.seconds)
  end
end
