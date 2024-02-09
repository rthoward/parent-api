defmodule Parent.Scratch do
  def test() do
    ["first_name", "family.id", "family.parents.email"]
    |> parse_fields()
  end

  def parse_fields(fields) do
  end
end
