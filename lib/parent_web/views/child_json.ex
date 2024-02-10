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
      first_name: child.first_name,
      last_name: child.last_name,
      birthday: child.birthday
    }
  end
end
