defmodule ChatApp.ClusterTest do
  use ExUnit.Case

  alias ChatApp.{Cluster, Node, User, Config}

  @node %{"alias" => "Neptune", "address" => "localhost"}

  def this do
    Config.this()
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, to_string(k), v) end)
  end

  def this_as_node do
    %{"alias" => aliaz, "address" => address} = this()

    %Node{alias: aliaz, address: address}
  end

  setup do
    Cluster.clear
  end

  test ".nodes" do
    assert Cluster.nodes == [ this_as_node() ]

    Cluster.register_node @node

    node = %Node{alias: @node["alias"], address: @node["address"], users: %{}}

    assert Cluster.nodes == [ this_as_node(), node ]
  end

  test ".register_node" do
    assert :ok = Cluster.register_node @node
    assert :node_exists = Cluster.register_node @node
    assert :node_exists = Cluster.register_node this()
    assert Enum.count(Cluster.nodes) == 2
  end

  test ".unregister_node" do
    :ok = Cluster.register_node @node

    Cluster.unregister_node @node["alias"]

    assert Enum.count(Cluster.nodes) == 1
    assert Cluster.nodes == [ this_as_node() ]
  end

  test ".add_user" do
    :ok = Cluster.add_user Config.alias, %User{}

    [node] = Cluster.nodes

    assert Enum.count(node.users) == 1
    assert node.users == %{42 => "John"}

    # Node doesn't exists
    assert :node_missing = Cluster.add_user "Jupiter", %User{}
  end

  test ".remove_user" do
    :ok = Cluster.add_user Config.alias, %User{}

    [node] = Cluster.nodes
    assert node.users == %{42 => "John"}

    {:ok, %{id: 42, username: "John"}} = Cluster.remove_user Config.alias, 42
    {:error, :user_not_found} = Cluster.remove_user Config.alias, 23
    {:error, :node_not_found} = Cluster.remove_user "Jupiter", 42

    [node] = Cluster.nodes
    assert node.users == %{}
  end

  test ".users" do
    :ok = Cluster.add_user Config.alias, %User{id: 1, username: "Chuck"}
    :ok = Cluster.add_user Config.alias, %User{id: 2, username: "Borris"}
    :ok = Cluster.add_user Config.alias, %User{id: 3, username: "John"}

    users = [
      %User{id: 1, username: "Chuck"},
      %User{id: 2, username: "Borris"},
      %User{id: 3, username: "John"},
    ]

    assert Cluster.users == users
  end

  test ".clear" do
    Cluster.register_node @node

    assert Enum.count(Cluster.nodes) == 2

    Cluster.clear

    assert Enum.count(Cluster.nodes) == 1
    assert Cluster.nodes == [ this_as_node() ]
  end

end
