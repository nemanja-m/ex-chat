defmodule UserApp.RepoHelpers do
  alias UserApp.{User, Host, Repo}

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      username: "user-#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "spersecret"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_host(attrs \\ %{}) do
    changes = Map.merge(%{
      address: "localhost:4000",
      alias: "Mars"
    }, attrs)

    %Host{}
    |> Host.changeset(changes)
    |> Repo.insert!
  end

end
