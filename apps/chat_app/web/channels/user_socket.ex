defmodule ChatApp.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "registrations:*", ChatApp.RegistrationChannel
  channel "sessions:*",      ChatApp.SessionChannel
  channel "room:*",          ChatApp.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    token = params["token"]

    {:ok, assign(socket, :token, token)}
  end

  def id(socket), do: "user_socket:#{socket.assigns.token}"
end
