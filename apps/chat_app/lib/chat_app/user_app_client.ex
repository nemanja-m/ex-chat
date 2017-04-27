defmodule ChatApp.UserAppClient do
  require Logger

  alias ChatApp.{Config, Cluster, User}

  @moduledoc """
  Client module that handles user actions such as register, login, logout.
  """

  def register(user, socket_reference) do
    response = request(:registration, user)

    Phoenix.Channel.reply socket_reference, response
  end

  def login(user, socket_reference) do
    response =
      request(:login, user)
      |> add_active_users_for(user)

    Phoenix.Channel.reply socket_reference, response
  end

  defp add_active_users_for({:ok, response}, user) do
    users=
      Cluster.users
      |> Enum.reject(fn %User{username: username} -> username == user["username"] end)

    new_data = Map.put(response["data"], "users", users)

    {:ok, response |> Map.put("data", new_data)}
  end
  defp add_active_users_for({:error, response}, _user), do: {:error, response}

  def logout(token) do
    headers = [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"}
    ]

    HTTPoison.delete("#{Config.master_node_url}/sessions", headers)
  end

  defp request(:registration, user) do
    user_data = Poison.encode!(%{user: user})

    HTTPoison.post("#{Config.master_node_url}/users", user_data, [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  defp request(:login, user) do
    params =
      user
      |> Map.merge(Config.host_info)
      |> Poison.encode!

    HTTPoison.post("#{Config.master_node_url}/sessions", params, [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body, status_code: code}}) do
    response = Poison.decode!(body)

    case code do
      200 -> {:ok, response}
      201 -> {:ok, response}
      _   -> {:error, response}
    end
  end

  defp handle_response({:error, reason}) do
    Logger.error reason

    {:error, %{}}
  end

end
