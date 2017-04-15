defmodule UserApp.AuthTest do
  use UserApp.ModelCase, async: true

  import UserApp.RepoHelpers

  alias UserApp.Auth

  setup do
    user = insert_user %{username: "john", password: "johndoe"}

    {:ok, user: user}
  end

  test "logs in user when credentials are valid", %{user: user} do
    {:ok, signed_user} = Auth.login("john", "johndoe")

    assert signed_user.id == user.id
  end

  test "returns error when password is invalid" do
    assert Auth.login("john", "badpass") == {:error, :unauthorized}
  end

  test "returns error when user does not exist" do
    assert Auth.login("chuck", "badpass") == {:error, :not_found}
  end
end
