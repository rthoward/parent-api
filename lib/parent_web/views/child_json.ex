defmodule ParentWeb.ChildJSON do
  alias Parent.Families.Children.Child

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
    |> ParentWeb.FamilyJSON.expand(:family, child.family)
  end

  def expand(data, key, %Child{} = child),
    do: Map.put(data, key, data(child))

  def expand(data, key, [%Child{} | _] = children),
    do: Map.put(data, key, Enum.map(children, &data/1))

  def expand(data, _, _), do: data
end
