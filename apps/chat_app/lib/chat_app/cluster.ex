defmodule ChatApp.Cluster do
  use GenServer

  alias ChatApp.{Node, User, Config}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Client API

  def register_node(node) do
    GenServer.call(__MODULE__, {:register_node, node})
  end

  def unregister_node(aliaz) do
    GenServer.cast(__MODULE__, {:unregister_node, aliaz})
  end

  def add_user(aliaz, user) do
    GenServer.call(__MODULE__, {:add_user, aliaz, user})
  end

  def remove_user(aliaz, user_id) do
    GenServer.cast(__MODULE__, {:remove_user, aliaz, user_id})
  end

  def nodes do
    GenServer.call(__MODULE__, {:nodes})
  end

  def clear do
    GenServer.cast(__MODULE__, {:clear})
  end

  # Server Callbacks

  def init(_), do: {:ok, %{}}

  def handle_call({:register_node, %{"alias" => aliaz, "address" => address}}, _from, nodes) do
    case Map.has_key?(nodes, aliaz) || (aliaz == Config.alias()) do
      true ->
        {:reply, :node_exists, nodes}

      false ->
        nodes = Map.put(nodes, aliaz, %{address: address, users: %{}})

        {:reply, :ok, nodes}
    end
  end

  def handle_call({:add_user, aliaz, %User{id: id, username: username}}, _from, nodes) do
    case Map.fetch(nodes, aliaz) do
      {:ok, %{address: address, users: users}} ->
        new_users = Map.put(users, id, username)
        nodes     = Map.put(nodes, aliaz, %{address: address, users: new_users})

        {:reply, :ok, nodes}

      :error ->
        {:reply, :node_missing, nodes}
    end
  end

  def handle_call({:nodes}, _from, nodes) do
    {:reply, nodes_list(nodes), nodes}
  end

  def handle_cast({:unregister_node, aliaz}, nodes) do
    {:noreply, Map.delete(nodes, aliaz)}
  end

  def handle_cast({:clear}, _nodes) do
    {:noreply, %{}}
  end

  def handle_cast({:remove_user, aliaz, user_id}, nodes) do
    case Map.get(nodes, aliaz) do
      %{address: address, users: users} ->
        new_users = Map.delete(users, user_id)
        nodes     = Map.put(nodes, aliaz, %{address: address, users: new_users})

        {:noreply, nodes}
      nil ->
        {:noreply, nodes}
    end
  end

  defp nodes_list(nodes) do
    nodes
    |> Enum.map(fn {aliaz, data} ->
      %Node{alias: aliaz, address: data[:address], users: data[:users]}
    end)
  end
end
