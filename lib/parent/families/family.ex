defmodule Parent.Families.Family do
  use Ecto.Schema
  import Ecto.Changeset

  schema "families" do
    has_many :children, Parent.Families.Children.Child
    has_many :parents, Parent.Families.Users.User

    timestamps(type: :utc_datetime)
  end

  def changeset(family, attrs) do
    family
    |> cast(attrs, [])
  end
end
