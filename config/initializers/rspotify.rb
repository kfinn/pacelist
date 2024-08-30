# frozen_string_literal: true

RSpotify.authenticate(
  Rails.application.credentials.spotify_client_id,
  Rails.application.credentials.spotify_client_secret
)

RSpotify::User.class_variable_set(:@@users_credentials, {}) # rubocop:disable Style/ClassVars
