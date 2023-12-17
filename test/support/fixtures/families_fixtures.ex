defmodule Parent.FamiliesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parent.Families` context.
  """

  @doc """
  Generate a child.
  """
  def child_fixture(attrs \\ %{}) do
    {:ok, child} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name"
      })
      |> Parent.Families.create_child()

    child
  end
end
