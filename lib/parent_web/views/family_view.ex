defmodule ParentWeb.FamilyView do
  use JSONAPI.View, type: "family"

  def fields, do: []
  def meta(_data, _conn), do: %{}
  def relationships, do: [children: ParentWeb.ChildView, parents: ParentWeb.UserView]
end
