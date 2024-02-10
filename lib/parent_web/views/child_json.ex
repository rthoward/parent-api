defmodule ParentWeb.ChildJSON do
  alias Parent.Families.Children.Child
  alias Parent.Families.Family

  def index(%{children: children}) do
    %{data: for(child <- children, do: data(child))}
  end

  def show(%{child: child}) do
    %{data: data(child)}
  end

  def data(%Child{} = child) do
    %{
      type: :child,
      id: child.id,
      family_id: child.family_id,
      first_name: child.first_name,
      last_name: child.last_name,
      birthday: child.birthday
    }
    |> expand(:family, child.family)
  end

  defp expand(data, :family, %Family{} = family),
    do: Map.put(data, :family, ParentWeb.FamilyJSON.data(family))

  defp expand(data, _child, _), do: data
end
