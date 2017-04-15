defmodule UserApp.RepoHelpers do
  alias UserApp.Repo
  alias UserApp.User

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      username: "user-#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "spersecret"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

end
