defmodule ChatApp.RoomChannel do
  use Phoenix.Channel

  alias ChatApp.UserAppClient

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("message:public", message, socket) do
    IO.inspect message

    {:reply, :ok, socket}
  end
  def handle_in("message:private", message, socket) do
    IO.inspect message

    {:reply, :ok, socket}
  end

  # Logout current user on leaving room channel.
  # (Page refresh, tab/browser close etc.)
  def terminate(_reason, socket) do
    token = socket.assigns.token

    UserAppClient.logout(token)

    {:ok, socket}
  end

end

