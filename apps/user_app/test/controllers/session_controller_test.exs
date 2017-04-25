defmodule UserApp.SessionControllerTest do
  use UserApp.ConnCase

  @user_credentials %{username: "john", password: "johndoe"}

  setup %{conn: conn} do
    user = insert_user @user_credentials
    conn = put_req_header(conn, "accept", "application/json")
    host = insert_host()

    host_hash = %{
      host: %{"address" => host.address, "alias" => host.alias}
    }

    {:ok, conn: conn, user: user, host: host_hash}
  end

  test "creates new user session when credentials are valid", %{conn: conn, user: user, host: host} do
    params = Map.merge @user_credentials, host

    conn = post conn, session_path(conn, :create), params

    user_response = json_response(conn, 200)["data"]["user"]
    assert user_response  == %{"id" => user.id, "username" => user.username}

    token = json_response(conn, 200)["data"]["token"]
    refute token == nil
  end

  test "returns error when user's password is invalid", %{conn: conn, host: host} do
    params = Map.merge %{username: "john", password: "badpass"}, host

    conn = post conn, session_path(conn, :create), params

    assert json_response(conn, 401)["error"] == "Invalid password"
  end

  test "returns error when user doesn't exist", %{conn: conn, host: host} do
    params = Map.merge %{username: "chuck", password: "supersecret"}, host

    conn = post conn, session_path(conn, :create), params

    assert json_response(conn, 404)["error"] == "User does not exist"
  end

  test "deletes user session", %{conn: conn, user: user} do
    # Log in user
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete(session_path(conn, :delete))

    assert json_response(conn, 200)["data"]["success"] == true
  end
end
