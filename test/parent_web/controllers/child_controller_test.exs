defmodule ParentWeb.ChildControllerTest do
  use ParentWeb.ConnCase

  import Parent.FamiliesFixtures

  alias Parent.Families.Children.Child

  @create_attrs %{
    first_name: "some first_name"
  }
  @update_attrs %{
    first_name: "some updated first_name"
  }
  @invalid_attrs %{first_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all children", %{conn: conn} do
      conn = get(conn, ~p"/api/children")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create child" do
    test "renders child when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/children", child: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/children/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "some first_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/children", child: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update child" do
    setup [:create_child]

    test "renders child when data is valid", %{conn: conn, child: %Child{id: id} = child} do
      conn = put(conn, ~p"/api/children/#{child}", child: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/children/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "some updated first_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, child: child} do
      conn = put(conn, ~p"/api/children/#{child}", child: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete child" do
    setup [:create_child]

    test "deletes chosen child", %{conn: conn, child: child} do
      conn = delete(conn, ~p"/api/children/#{child}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/children/#{child}")
      end
    end
  end

  defp create_child(_) do
    child = child_fixture()
    %{child: child}
  end
end
