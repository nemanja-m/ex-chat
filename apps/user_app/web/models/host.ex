defmodule UserApp.Host do
  use UserApp.Web, :model

  schema "hosts" do
    field :address, :string
    field :alias, :string
    has_many :users, UserApp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:address, :alias])
    |> validate_required([:address, :alias])
    |> unique_constraint(:address)
  end
end
