defmodule ChatApp.Node do
  defstruct alias: "Mars", address: "localhost:4000", users: %{}
end

defmodule ChatApp.User do
  defstruct id: 42, username: "John"
end
