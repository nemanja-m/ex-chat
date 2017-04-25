defmodule ChatApp.UserAppClient do
  require Logger

  alias ChatApp.Config

  @moduledoc """
  Client module that handles user actions such as register, login, logout.
  """

  def register(user, socket_reference) do
    response = request(:registration, user)

    Phoenix.Channel.reply socket_reference, response
  end

  def login(user, socket_reference) do
    response = request(:login, user)

    Phoenix.Channel.reply socket_reference, response
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
