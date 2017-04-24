defmodule ChatApp.UserAppClient do
  require Logger

  @moduledoc """
  Client module that handles user actions such as register, login, logout.
  """

  def register(user, socket_reference) do
    response = request(:registration, user)

    Phoenix.Channel.reply socket_reference, response
  end

  @user_api_url "http://localhost:4001/api/"

  defp request(:registration, user) do
    user_data = Poison.encode!(%{user: user})

    HTTPoison.post("#{@user_api_url}/users", user_data, [{"Content-Type", "application/json"}])
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body, status_code: code}}) do
    response = Poison.decode!(body)

    case code do
      422 -> {:error, response}
      201 -> {:ok, response}
    end
  end

  defp handle_response({:error, reason}) do
    Logger.error reason

    {:error, %{}}
  end

end
