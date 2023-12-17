defmodule ParentWeb.ChildSchema do
  alias OpenApiSpex.Schema

  defmodule Child do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Child",
      description: "A child",
      type: :object,
      properties: %{
        id: %Schema{type: :integer},
        first_name: %Schema{type: :string},
        last_: %Schema{type: :string},
        birthday: %Schema{type: :string, format: :date},
        inserted_at: %Schema{type: :string, format: :"date-time"},
        updated_at: %Schema{type: :string, format: :"date-time"}
      },
      required: [:first_name, :last_name, :birthday],
      example: %{
        "id" => 123,
        "first_name" => "Ronnie",
        "last_name" => "McDonnie",
        "birthday" => "1970-01-01T12:34:55Z",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule ChildResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ChildResponse",
      type: :object,
      properties: %{data: Child}
    })
  end

  defmodule ChildrenResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ChildResponse",
      type: :object,
      properties: %{data: %Schema{type: :array, items: Child}}
    })
  end
end
