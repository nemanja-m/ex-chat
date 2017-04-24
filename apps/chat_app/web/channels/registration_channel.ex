defmodule ChatApp.RegistrationChannel do
  use Phoenix.Channel

  alias ChatApp.UserAppClient

  # Allow anyone to enter registration:new channel
  def join("registrations:new", _message, socket) do
    {:ok, socket}
  end

  def handle_in("signup", user, socket) do

    # Socker reference for async reply to channel.push on client side
    ref = socket_ref(socket)

    UserAppClient.register(user, ref)

    {:noreply, socket}
  end

end
