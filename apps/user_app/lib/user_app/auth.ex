defmodule UserApp.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias UserApp.{User, Host, Repo}

  def login(conn, username, password, host) do
    user = Repo.get_by(User, username: username)

    cond do
      user && checkpw(password, user.password_hash) ->
        assign_host_to_user(host, user)

        {conn, :ok, user}
      user ->
        {conn, :error, :unauthorized}
      true ->
        dummy_checkpw()
        {conn, :error, :not_found}
    end
  end

  defp assign_host_to_user(%{"address" => address, "alias" => alias}, user) do
    # Host should always be present in DB before login request.
    host = Repo.get_by(Host, address: address)

    # Assigns host to logged user.
    User.host_changeset(user, %{host_id: host.id})
    |> Repo.update!
  end
end
