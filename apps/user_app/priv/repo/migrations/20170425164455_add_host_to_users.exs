defmodule UserApp.Repo.Migrations.AddHostToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :host_id, references(:hosts)
    end
  end
end
