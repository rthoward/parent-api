defmodule ParentWeb.FamilyJSON do
  alias Parent.Families.Family

  def show(%{family: family}) do
    %{data: data(family)}
  end

  def data(%Family{} = family) do
    %{
      type: :family,
      id: family.id
    }
    |> ParentWeb.UserJSON.expand(:parents, family.parents)
    |> ParentWeb.ChildJSON.expand(:children, family.children)
  end

  def expand(data, key, %Family{} = family), do: Map.put(data, key, data(family))

  def expand(data, _key, _), do: data
end
