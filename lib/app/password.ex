defmodule App.Password do

  def hash_pwd_salt(password) do
    Pbkdf2.hash_pwd_salt(password)
  end

  def verify_pass(password, hashed) do
    Pbkdf2.verify_pass(password, hashed)
  end

  def no_user_verify, do: Pbkdf2.no_user_verify
end