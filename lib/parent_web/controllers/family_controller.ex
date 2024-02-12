defmodule ParentWeb.FamilyController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families
  alias ParentWeb.Helpers.Preloads
  alias ParentWeb.FamilySchema

  tags ["families"]

  operation :show,
    summary: "Get a family",
    responses: [
      ok: {"Family response", "application/json", FamilySchema.FamilyResponse}
    ]

  def show(conn, %{"id" => id}) do
    preloads = Preloads.allow(conn, [:children, :parents])

    id
    |> Families.get_family(preloads)
    |> case do
      %Families.Family{} = family -> render(conn, :show, %{family: family})
      _ -> {:error, :not_found}
    end
  end
end
