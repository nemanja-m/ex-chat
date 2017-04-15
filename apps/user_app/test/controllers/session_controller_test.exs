defmodule UserApp.SessionControllerTest do
  use UserApp.ConnCase

  @user_credentials %{username: "john", password: "johndoe"}

  setup %{conn: conn} do
    user = insert_user @user_credentials
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn, user: user}
  end

  test "creates new user session when credentials are valid", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), @user_credentials

    user_response = json_response(conn, 200)["data"]["user"]
    assert user_response  == %{"id" => user.id, "username" => user.username}

    token = json_response(conn, 200)["data"]["token"]
    refute token == nil
  end

  test "returns error when user's password is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), %{username: "john", password: "badpass"}

    assert json_response(conn, 401)["error"] == "Invalid password"
  end

  test "returns error when user doesn't exist", %{conn: conn} do
    conn = post conn, session_path(conn, :create), %{username: "chuck", password: "supersecret"}

    assert json_response(conn, 404)["error"] == "User does not exist"
  end
end
