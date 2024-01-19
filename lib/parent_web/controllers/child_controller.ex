defmodule ParentWeb.ChildController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families.Children
  alias Parent.Families.Children.Child

  alias ParentWeb.ChildSchema

  action_fallback ParentWeb.FallbackController

  tags ["children"]

  plug JSONAPI.QueryParser,
    filter: ~w(family_id),
    include: ~w(family),
    view: ParentWeb.ChildView

  operation :index,
    summary: "List children",
    parameters: [],
    responses: [
      ok: {"Children response", "application/json", ChildSchema.ChildrenResponse}
    ]

  def index(conn, _params) do
    children = Children.list_children()

    conn
    |> put_view(ParentWeb.ChildView)
    |> render("show.json", %{data: children})
  end

  def create(conn, %{"child" => child_params}) do
    with {:ok, child} <- Children.create_child(child_params) do
      conn
      |> put_status(:created)
      |> put_view(ParentWeb.ChildView)
      |> render("show.json", %{data: child})
    end
  end

  def show(conn, %{"id" => id}) do
    preloads = conn.assigns.jsonapi_query.include

    id
    |> Children.get_child(preloads)
    |> case do
      %Child{} = child ->
        conn
        |> put_view(ParentWeb.ChildView)
        |> render("show.json", %{data: child})

      _ ->
        {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "child" => child_params}) do
    with %Child{} = child <- Children.get_child(id),
         {:ok, updated_child} <- Children.update_child(child, child_params) do
      conn
      |> put_view(ParentWeb.ChildView)
      |> render("show.json", %{data: updated_child})
    else
      nil -> {:error, :not_found}
      e -> e
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Child{} = child <- Children.get_child(id),
         {:ok, %Child{}} <- Children.delete_child(child) do
      send_resp(conn, :no_content, "")
    else
      nil -> {:error, :not_found}
      e -> e
    end
  end
end
