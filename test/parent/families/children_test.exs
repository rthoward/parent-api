defmodule Parent.Families.ChildrenTest do
  use Parent.DataCase

  alias Parent.Families.Children

  describe "children" do
    alias Parent.Families.Children.Child

    @invalid_attrs %{first_name: nil}

    test "list_children/0 returns all children" do
      child = insert(:child)
      assert Children.list_children() == [child]
    end

    test "get_child!/1 returns the child with given id" do
      child = insert(:child)
      assert Children.get_child!(child.id) == child
    end

    test "create_child/1 with valid data creates a child" do
      valid_attrs = params_for(:child)

      assert {:ok, %Child{} = child} = Children.create_child(valid_attrs)
      assert child.first_name == valid_attrs[:first_name]
    end

    test "create_child/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Children.create_child(@invalid_attrs)
    end

    test "update_child/2 with valid data updates the child" do
      child = insert(:child)
      update_attrs = %{first_name: "some updated first_name"}

      assert {:ok, %Child{} = child} = Children.update_child(child, update_attrs)
      assert child.first_name == "some updated first_name"
    end

    test "update_child/2 with invalid data returns error changeset" do
      child = insert(:child)
      assert {:error, %Ecto.Changeset{}} = Children.update_child(child, @invalid_attrs)
      assert child == Children.get_child!(child.id)
    end

    test "delete_child/1 deletes the child" do
      child = insert(:child)
      assert {:ok, %Child{}} = Children.delete_child(child)
      assert_raise Ecto.NoResultsError, fn -> Children.get_child!(child.id) end
    end

    test "change_child/1 returns a child changeset" do
      child = insert(:child)
      assert %Ecto.Changeset{} = Children.change_child(child)
    end
  end
end
