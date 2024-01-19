defmodule Parent.Families.Children.Child do
  use Ecto.Schema
  import Ecto.Changeset

  schema "children" do
    field :first_name, :string
    field :last_name, :string
    field :birthday, :date

    belongs_to :family, Parent.Families.Family
    has_many :parents, through: [:family, :parents]

    timestamps(type: :utc_datetime)
  end

  @fields [:first_name, :last_name, :birthday]

  def changeset(child, attrs) do
    child
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
