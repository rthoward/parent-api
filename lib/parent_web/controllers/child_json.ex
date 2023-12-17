defmodule ParentWeb.ChildJSON do
  alias Parent.Families.Children.Child

  @doc """
  Renders a list of children.
  """
  def index(%{children: children}) do
    %{data: for(child <- children, do: data(child))}
  end

  @doc """
  Renders a single child.
  """
  def show(%{child: child}) do
    %{data: data(child)}
  end

  defp data(%Child{} = child) do
    %{
      id: child.id,
      first_name: child.first_name
    }
  end
end
