defmodule ParentWeb.ChildController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families.Children
  alias Parent.Families.Children.Child

  alias ParentWeb.ChildSchema

  action_fallback ParentWeb.FallbackController

  tags ["children"]

  operation :index,
    summary: "List children",
    parameters: [],
    responses: [
      ok: {"Children response", "application/json", ChildSchema.ChildrenResponse}
    ]

  def index(conn, _params) do
    children = Children.list_children()
    render(conn, :index, %{children: children})
  end

  def create(conn, %{"child" => child_params}) do
    with {:ok, child} <- Children.create_child(child_params) do
      conn
      |> put_status(:created)
      |> render(:show, %{child: child})
    end
  end

  def show(conn, %{"id" => id}) do
    preloads = []

    id
    |> Children.get_child(preloads)
    |> case do
      %Child{} = child -> render(conn, :show, %{child: child})
      _ -> {:error, :not_found}
    end
  end

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
