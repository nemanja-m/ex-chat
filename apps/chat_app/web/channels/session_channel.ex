defmodule ChatApp.SessionChannel do
  use Phoenix.Channel

  alias ChatApp.UserAppClient

  # Allow anyone to enter sessions:new channel
  def join("sessions:new", _message, socket) do
    {:ok, socket}
  end

  def handle_in("login", user, socket) do

    # Socker reference for async reply to channel.push on client side
    ref = socket_ref(socket)

    UserAppClient.login(user, ref)

    {:noreply, socket}
  end

end
