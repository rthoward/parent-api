defmodule ParentWeb.ChildControllerTest do
  use ParentWeb.ConnCase

  alias Parent.Families.Children.Child

  @invalid_attrs %{"foo" => "bar"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_child]

    test "lists all children", %{conn: conn, child: %Child{id: id}} do
      assert %{"data" => [%{"id" => ^id}]} =
               conn
               |> get(~p"/api/children")
               |> json_response(200)
    end
  end

  describe "show" do
    setup [:create_child]

    test "shows a child", %{conn: conn, child: %Child{id: id} = child} do
      assert %{"data" => %{"id" => ^id}} =
               conn
               |> get(~p"/api/children/#{child}")
               |> json_response(200)
    end

    test "doesn't return family by default", %{conn: conn, child: child} do
      assert response_json =
               conn
               |> get(~p"/api/children/#{child}")
               |> json_response(200)

      refute response_json["data"]["family"]
    end

    test "can expand `family`", %{conn: conn, child: %Child{family_id: family_id} = child} do
      assert %{"data" => %{"family_id" => ^family_id, "family" => %{"id" => ^family_id}}} =
               conn
               |> get(~p"/api/children/#{child}", %{expand: ["family.parents", "family.children"]})
               |> json_response(200)
    end
  end

  describe "create child" do
    test "renders child when data is valid", %{conn: conn} do
      create_attrs = string_params_for(:child)

      assert %{"data" => %{"id" => id}} =
               conn
               |> post(~p"/api/children", child: create_attrs)
               |> json_response(201)

      assert %{
               "data" => %{
                 "id" => ^id,
                 "first_name" => _,
                 "last_name" => _,
                 "birthday" => _
               }
             } =
               conn
               |> get(~p"/api/children/#{id}")
               |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/children", child: @invalid_attrs)

      assert %{"errors" => %{"first_name" => first_name_errors}} = json_response(conn, 422)
      assert "can't be blank" in first_name_errors
    end
  end

  describe "update child" do
    setup [:create_child]

    test "renders child when data is valid", %{conn: conn, child: %Child{id: id} = child} do
      update_attrs = %{"first_name" => "updated"}

      assert %{"data" => %{"id" => ^id}} =
               conn
               |> put(~p"/api/children/#{child}", child: update_attrs)
               |> json_response(200)

      assert %{
               "data" => %{
                 "id" => ^id,
                 "first_name" => "updated"
               }
             } =
               conn
               |> get(~p"/api/children/#{id}")
               |> json_response(200)
    end
  end

  describe "delete child" do
    setup [:create_child]

    test "deletes chosen child", %{conn: conn, child: child} do
      assert conn
             |> delete(~p"/api/children/#{child}")
             |> response(204)

      assert conn
             |> get(~p"/api/children/#{child}")
             |> response(404)
    end
  end

  defp create_child(_) do
    %{child: insert(:child, family: build(:family))}
  end
end
