defmodule ParentWeb.FamilySchema do
  alias OpenApiSpex.Schema

  defmodule Family do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Family",
      description: "A family",
      type: :object,
      properties: %{
        id: %Schema{type: :integer},
        children: %Schema{type: :array, items: ParentWeb.ChildSchema.Child},
        inserted_at: %Schema{type: :string, format: :"date-time"},
        updated_at: %Schema{type: :string, format: :"date-time"}
      },
      example: %{
        "id" => 123,
        "children" => [],
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule FamilyResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "FamilyResponse",
      type: :object,
      properties: %{data: Family}
    })
  end
end
