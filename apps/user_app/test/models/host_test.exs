defmodule UserApp.HostTest do
  use UserApp.ModelCase

  alias UserApp.Host

  @valid_attrs %{
    address: "127.0.0.1:4000",
    alias: "Mars"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Host.changeset(%Host{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Host.changeset(%Host{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "unique address constraint" do
    Host.changeset(%Host{}, @valid_attrs)
    |> Repo.insert!

    changeset = Host.changeset(%Host{}, @valid_attrs)

    assert_raise Ecto.InvalidChangesetError, fn ->
      Repo.insert!(changeset)
    end
  end
end
