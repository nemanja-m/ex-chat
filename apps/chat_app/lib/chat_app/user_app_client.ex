defmodule ChatApp.UserAppClient do
  require Logger

  @moduledoc """
  Client module that handles user actions such as register, login, logout.
  """

  @user_api_url "http://localhost:4001/api"

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

    HTTPoison.post("#{@user_api_url}/users", user_data, [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  defp request(:login, user) do
    user_data = Poison.encode!(user)

    HTTPoison.post("#{@user_api_url}/sessions", user_data, [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body}}) do
    response = Poison.decode!(body)

    {:ok, response}
  end

  defp handle_response({:error, reason}) do
    Logger.error reason

    {:error, %{}}
  end

end
