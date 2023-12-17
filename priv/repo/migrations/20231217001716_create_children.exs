defmodule Parent.Repo.Migrations.CreateChildren do
  use Ecto.Migration

  def change do
    create table(:families) do
      timestamps(type: :utc_datetime)
    end

    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string

      add :family_id, references(:families)

      timestamps(type: :utc_datetime)
    end

    index(:users, :email, unique: true)

    create table(:children) do
      add :first_name, :string
      add :last_name, :string
      add :birthday, :date

      add :family_id, references(:families)

      timestamps(type: :utc_datetime)
    end
  end
end
