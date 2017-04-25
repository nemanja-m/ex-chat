defmodule UserApp.AuthTest do
  use UserApp.ConnCase, async: true

  import UserApp.RepoHelpers

  alias UserApp.{Auth, Repo, Host}

  setup %{conn: conn} do
    user = insert_user %{username: "john", password: "johndoe"}
    host = insert_host()

    {:ok, conn: conn, user: user, host: %{"address" => host.address, "alias" => host.alias}}
  end

  test "logs in user when credentials are valid", %{conn: conn, user: user, host: host} do
    {_, :ok, signed_user} = Auth.login(conn, "john", "johndoe", host)

    assert signed_user.id == user.id
  end

  test "creates new host when given host does not exist", %{conn: conn, user: user} do
    host = %{"address" => "8.8.8.8", "alias" => "Jupiter"}

    {_, :ok, signed_user} = Auth.login(conn, "john", "johndoe", host)

    assert Repo.get_by(Host, address: "8.8.8.8") != nil
    assert signed_user.id == user.id
  end

  test "returns error when password is invalid", %{conn: conn, host: host} do
    assert {conn, :error, :unauthorized} == Auth.login(conn, "john", "badpass", host)
  end

  test "returns error when user does not exist", %{conn: conn, host: host} do
    assert {conn, :error, :not_found} == Auth.login(conn, "chuck", "badpass", host)
  end
end
