defmodule ParentWeb.ChildView do
  use JSONAPI.View, type: "children"

  def fields, do: [:first_name, :last_name, :birthday]
  def meta(_data, _conn), do: %{}
  def relationships, do: [family: ParentWeb.FamilyView]
end
