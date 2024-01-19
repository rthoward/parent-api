defmodule Parent.Families.Family do
  use Ecto.Schema
  import Ecto.Changeset

  schema "families" do
    timestamps(type: :utc_datetime)
  end

  def changeset(family, attrs) do
    family
    |> cast(attrs, [])
  end
end
