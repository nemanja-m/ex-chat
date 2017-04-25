defmodule ChatApp.ConfigTest do
  use ExUnit.Case, async: true

  alias ChatApp.Config

  test "default alias" do
    assert Config.alias == "Mars"
  end

  test "default address" do
    assert Config.address == "localhost:4001"
  end

  test "default master node url" do
    assert Config.master_node_url === "http://localhost:3000/api"
  end
end
