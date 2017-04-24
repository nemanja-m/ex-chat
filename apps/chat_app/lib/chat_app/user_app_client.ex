defmodule ChatApp.UserAppClient do

  @moduledoc """
  Client module that handles user actions such as register, login, logout.
  """

  def register(user, socket_reference) do
    response = request(:registration, user)

    Phoenix.Channel.reply socket_reference, response
  end

  defp request(:registration, user) do
    {:ok, user}
  end

end
