defmodule UserApp.UserControllerTest do
  use UserApp.ConnCase

  alias UserApp.User

  @valid_attrs %{
    username: "john",
    password: "johndoe"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all users on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)

    assert json_response(conn, 200)["data"] == []
  end

  test "creates and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{username: "john"})
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes user", %{conn: conn} do
    user = insert_user %{username: "john", password: "johndoe"}
    conn = delete conn, user_path(conn, :delete, user)

    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
