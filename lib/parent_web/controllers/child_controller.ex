defmodule ParentWeb.ChildController do
  use ParentWeb, :controller

  alias Parent.Families.Children
  alias Parent.Families.Children.Child

  action_fallback ParentWeb.FallbackController
  defmodule View do
    def render("show.json", %{data: child} = assigns) do
      IO.inspect(child)

      %{
        id: to_string(child.id),
        type: "child",
        first_name: child.first_name,
        last_name: child.last_name,
        birthday: child.birthday,
        family: render_expandable(child, :family)
      }
    end

    defp render_expandable(relation) do
      :foo
    end
  end

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

  def show(conn, %{"id" => id} = params) do
    api_query = conn.assigns.api_query |> IO.inspect()

    id
    |> Children.get_child(api_query.expand)
    |> case do
      %Child{} = child ->
        conn
        |> put_view(View)
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
