defmodule ParentWeb.FamilyJSON do
  alias Parent.Families.Family

  def show(%{family: family}) do
    %{data: data(family)}
  end

  def data(%Family{} = family) do
    %{
      type: :family,
      id: family.id,
      parents: Enum.map(family.parents, &ParentWeb.UserJSON.data/1),
      children: Enum.map(family.children, &ParentWeb.ChildJSON.data/1)
    }
  end
end
