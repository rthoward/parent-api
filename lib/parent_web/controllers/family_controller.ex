defmodule ParentWeb.FamilyController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families

  action_fallback ParentWeb.FallbackController

  tags ["families"]

  plug JSONAPI.QueryParser,
    include: ~w(children parents),
    view: ParentWeb.FamilyView

  def show(conn, %{"id" => id}) do
    preloads = conn.assigns.jsonapi_query.include

    id
    |> Families.get_family(preloads)
    |> case do
      %Families.Family{} = family ->
      conn
      |> put_view(ParentWeb.FamilyView)
      |> render("show.json", %{data: family})

      _ -> {:error, :not_found}
    end
  end
end
