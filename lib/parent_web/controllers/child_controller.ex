defmodule ParentWeb.ChildController do
  use ParentWeb, :controller

  alias Parent.Families.Children
  alias Parent.Families.Children.Child

  action_fallback ParentWeb.FallbackController

  def index(conn, _params) do
    children = Children.list_children()
    render(conn, :index, children: children)
  end

  def create(conn, %{"child" => child_params}) do
    with {:ok, %Child{} = child} <- Children.create_child(child_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/children/#{child}")
      |> render(:show, child: child)
    end
  end

  def show(conn, %{"id" => id}) do
    child = Children.get_child!(id)
    render(conn, :show, child: child)
  end

  def update(conn, %{"id" => id, "child" => child_params}) do
    child = Children.get_child!(id)

    with {:ok, %Child{} = child} <- Children.update_child(child, child_params) do
      render(conn, :show, child: child)
    end
  end

  def delete(conn, %{"id" => id}) do
    child = Children.get_child!(id)

    with {:ok, %Child{}} <- Children.delete_child(child) do
      send_resp(conn, :no_content, "")
    end
  end
end
