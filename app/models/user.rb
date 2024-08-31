# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, :trackable, omniauth_providers: %i[spotify]

  has_many :playlists, dependent: :destroy
  has_many :saved_tracks, dependent: :destroy
  has_many :user_syncs, dependent: :destroy

  def self.from_omniauth(omniauth)
    find_or_initialize_by(
      provider: omniauth[:provider],
      uid: omniauth[:uid]
    ).tap do |user|
      user.update! user_attributes_from_omniauth(omniauth)
    end
  end

  def self.user_attributes_from_omniauth(omniauth)
    {
      email: omniauth[:info][:email],
      spotify_credential_token: omniauth[:credentials][:token],
      spotify_credential_refresh_token: omniauth[:credentials][:refresh_token],
      spotify_credential_expires_at: Time.zone.at(omniauth[:credentials][:expires_at]).to_datetime,
      spotify_credential_expires: omniauth[:credentials][:expires]
    }.compact
  end

  def authenticated(&)
    self.class.authenticated_as(self, &)
  end

  def spotify_credentials
    @spotify_credentials ||= SpotifyCredentials.new(
      access_token: spotify_credential_token,
      token_type: 'Bearer',
      expires_in: spotify_credential_expires_at - Time.zone.now
    )

    unless @spotify_credentials.valid?
      @spotify_credentials = SpotifyCredentials.for_user(self)

      update!(
        spotify_credential_token: @spotify_credentials.access_token,
        spotify_credential_expires_at: @spotify_credentials.expires_in.seconds.from_now
      )
    end

    @spotify_credentials
  end

  class << self
    AUTHENTICATED_USER_THREAD_LOCAL_KEY = "#{name}.authenticated_user".freeze

    def authenticated_user
      Thread.current[AUTHENTICATED_USER_THREAD_LOCAL_KEY]
    end

    def authenticated_as(user)
      authenticated_user_was = authenticated_user
      Thread.current[AUTHENTICATED_USER_THREAD_LOCAL_KEY] = user
      yield
    ensure
      Thread.current[AUTHENTICATED_USER_THREAD_LOCAL_KEY] = authenticated_user_was
    end
  end
end
