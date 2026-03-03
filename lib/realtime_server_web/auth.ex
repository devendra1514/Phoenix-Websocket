defmodule RealtimeServerWeb.Auth do
  use Joken.Config

  @secret System.get_env("JWT_SECRET") || "your_development_secret_key_here"

  def token_config do
    default_claims(skip: [:aud, :iss])
  end

  def signer do
    Joken.Signer.create("HS256", @secret)
  end
end