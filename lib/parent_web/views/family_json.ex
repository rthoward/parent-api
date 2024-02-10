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
    |> expand(:parents, family.parents)
    |> expand(:children, family.children)
  end

  defp expand(data, :parents, [_ | _] = parents),
    do: Map.put(data, :parents, Enum.map(parents, &ParentWeb.UserJSON.data/1))

  defp expand(data, :children, [_ | _] = children),
    do: Map.put(data, :children, Enum.map(children, &ParentWeb.ChildJSON.data/1))

  defp expand(data, _, _), do: data
end
