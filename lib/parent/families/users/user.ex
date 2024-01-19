defmodule Parent.Families.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    belongs_to :family, Parent.Families.Family

    timestamps(type: :utc_datetime)
  end

  @fields [:first_name, :last_name, :email]

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
