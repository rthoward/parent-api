defmodule ParentWeb.UserJSON do
  alias Parent.Families.Users.User

  def data(%User{} = user) do
    %{
      type: :user,
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      family_id: user.family_id
    }
    |> ParentWeb.FamilyJSON.expand(:family, user.family)
  end

  def expand(data, key, %User{} = user),
    do: Map.put(data, key, data(user))

  def expand(data, key, [%User{} | _] = users),
    do: Map.put(data, key, Enum.map(users, &data/1))

  def expand(data, _, _), do: data
end
