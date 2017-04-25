defmodule UserApp.Repo.Migrations.CreateHost do
  use Ecto.Migration

  def change do
    create table(:hosts) do
      add :address, :string
      add :alias, :string

      timestamps()
    end
    create unique_index(:hosts, [:address])

  end
end
