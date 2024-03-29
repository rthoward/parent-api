defmodule ParentWeb.ChildController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families.Children
  alias Parent.Families.Children.Child

  alias ParentWeb.ChildSchema
  alias ParentWeb.Helpers

  tags ["children"]

  @allowed_preloads [family: [:children, :parents]]

  operation :index,
    summary: "List children",
    responses: [
      ok: {"Children response", "application/json", ChildSchema.ChildrenResponse}
    ]

  def index(conn, _params) do
    children = Children.list_children()
    render(conn, :index, %{children: children})
  end

  operation :create,
    summary: "Create a child",
    request_body: {"Child params", "application/json", ChildSchema.ChildParams},
    responses: [
      ok: {"Child response", "application/json", ChildSchema.ChildrenResponse}
    ]

  def create(conn, %{"child" => child_params}) do
    with {:ok, child} <- Children.create_child(child_params) do
      conn
      |> put_status(:created)
      |> render(:show, %{child: child})
    end
  end

  operation :show,
    summary: "Get a child",
    responses: [
      ok: {"Child response", "application/json", ChildSchema.ChildResponse}
    ]

  def show(conn, %{"id" => id}) do
    preloads = Helpers.Preloads.from_conn(conn, @allowed_preloads)

    id
    |> Children.get_child(preloads)
    |> case do
      %Child{} = child -> render(conn, :show, %{child: child})
      _ -> {:error, :not_found}
    end
  end

  operation :update,
    summary: "Update a child",
    parameters: [id: [in: :path, type: :integer, example: 1]],
    request_body: {"Child params", "application/json", ChildSchema.ChildParams},
    responses: [
      ok: {"Child response", "application/json", ChildSchema.ChildrenResponse}
    ]

  def update(conn, %{"id" => id, "child" => child_params}) do
    with {_, %Child{} = child} <- {:get_child, Children.get_child(id)},
         {:ok, updated_child} <- Children.update_child(child, child_params) do
      conn
      |> render(:show, %{child: updated_child})
    else
      {:get_child, nil} -> {:error, :not_found}
      e -> e
    end
  end

  operation :delete,
    summary: "Delete a child",
    parameters: [id: [in: :path, type: :integer, example: 1]]

  def delete(conn, %{"id" => id}) do
    with {_, %Child{} = child} <- {:get_child, Children.get_child(id)},
         {:ok, %Child{}} <- Children.delete_child(child) do
      send_resp(conn, :no_content, "")
    else
      nil -> {:error, :not_found}
      e -> e
    end
  end
end
