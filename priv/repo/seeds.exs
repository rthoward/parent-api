defmodule Seed do
  alias Parent.Families.Children.Child
  alias Parent.Families.Family
  alias Parent.Families.Users.User
  alias Parent.Repo

  def create_user(params) do
    User
    |> Repo.get_by(email: params.email)
    |> case do
      %User{} = existing_user ->
        existing_user
        |> Ecto.Changeset.change(params)
        |> Repo.update!()

      _ ->
        family = Repo.insert!(%Family{})
        params = Map.put(params, :family_id, family.id)

        user =
          User
          |> struct(params)
          |> Repo.insert!()
    end
  end

  def create_child(params) do
    Child
    |> Repo.get_by(first_name: params.first_name, last_name: params.last_name)
    |> case do
      %Child{} = existing_child ->
        existing_child
        |> Ecto.Changeset.change(params)
        |> Repo.update!()

      _ ->
        Child
        |> struct(params)
        |> Repo.insert!()
    end
  end
end

user =
  Seed.create_user(%{
    first_name: "Drogo",
    last_name: "Baggins",
    email: "drogo.baggins@example.com"
  })

Seed.create_child(%{
  first_name: "Frodo",
  last_name: "Baggins",
  birthday: ~D[1990-02-01],
  family_id: user.family_id
})

Seed.create_child(%{
  first_name: "Samwise",
  last_name: "Gamgee",
  birthday: ~D[1998-10-17],
  family_id: user.family_id
})
