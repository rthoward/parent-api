defmodule ParentWeb.UserJSON do
  alias Parent.Families.Users.User
  alias Parent.Families.Family

  def data(%User{} = user) do
    %{
      type: :user,
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      family_id: user.family_id
    }
    |> expand(:family, user.family)
  end

  defp expand(data, :family, %Family{} = family),
    do: Map.put(data, :family, ParentWeb.FamilyJSON.data(family))

  defp expand(data, _, _), do: data
end
