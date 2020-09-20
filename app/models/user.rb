class User < ApplicationRecord
  devise :omniauthable, :trackable, omniauth_providers: %i[spotify]

  has_many :playlists
  has_many :saved_tracks
  has_many :user_syncs

  def self.from_omniauth(omniauth)
    find_or_initialize_by(
    provider: omniauth[:provider],
    uid: omniauth[:uid]
    ).tap do |user|
      user.update! subscriber_params_from_omniauth(omniauth)
    end
  end
  
  def self.subscriber_params_from_omniauth(omniauth)
    {
      email: omniauth[:info][:email],
      spotify_credential_token: omniauth[:credentials][:token],
      spotify_credential_refresh_token: omniauth[:credentials][:refresh_token],
      spotify_credential_expires_at: Time.zone.at(omniauth[:credentials][:expires_at]).to_datetime,
      spotify_credential_expires: omniauth[:credentials][:expires]
    }.compact
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.new to_rspotify_params
  end

  private

  def to_rspotify_params
    {
      info: {
        id: uid,
        email: email
      },
      credentials: {
      token: spotify_credential_token,
      refresh_token: spotify_credential_refresh_token,
      expires_at: spotify_credential_expires_at.to_i,
      expires: spotify_credential_expires
      }
    }.with_indifferent_access
  end
end
