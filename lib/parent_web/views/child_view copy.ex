defmodule ParentWeb.UserView do
  use JSONAPI.View, type: "users"

  def fields, do: [:first_name, :last_name, :email]
  def meta(_data, _conn), do: %{}
  def relationships, do: [family: ParentWeb.FamilyView]
end
