defmodule ChatApp.RoomChannel do
  use Phoenix.Channel

  alias ChatApp.UserAppClient

  def join("room:new", _message, socket) do
    {:ok, socket}
  end

  # Logout current user on leaving room channel.
  # (Page refresh, tab/browser close etc.)
  def terminate(_reason, socket) do
    token = socket.assigns.token

    UserAppClient.logout(token)
    :ok
  end

end

