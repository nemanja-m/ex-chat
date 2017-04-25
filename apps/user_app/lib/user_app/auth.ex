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

  defp assign_host_to_user(params = %{"address" => address, "alias" => _alias}, user) do
    host = prepare_host params, Repo.get_by(Host, address: address)

    User.host_changeset(user, %{host_id: host.id}) |> Repo.update!
  end

  defp prepare_host(params, nil), do: Host.changeset(%Host{}, params) |> Repo.insert!
  defp prepare_host(_, host), do: host
end
