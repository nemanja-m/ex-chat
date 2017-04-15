defmodule UserApp.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias UserApp.User
  alias UserApp.Repo

  def login(username, password) do
    user = Repo.get_by(User, username: username)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
end
