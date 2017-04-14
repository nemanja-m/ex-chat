defmodule UserApp.User do
  use UserApp.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> put_hashed_password
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:username, :password])
    |> validate_user
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  defp validate_user(changeset) do
    changeset
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3, max: 20)
    |> validate_length(:password, min: 6, max: 20)
  end
end
