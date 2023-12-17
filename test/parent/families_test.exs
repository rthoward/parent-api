defmodule Parent.FamiliesTest do
  use Parent.DataCase

  alias Parent.Families

  describe "children" do
    alias Parent.Families.Child

    import Parent.FamiliesFixtures

    @invalid_attrs %{first_name: nil}

    test "list_children/0 returns all children" do
      child = child_fixture()
      assert Families.list_children() == [child]
    end

    test "get_child!/1 returns the child with given id" do
      child = child_fixture()
      assert Families.get_child!(child.id) == child
    end

    test "create_child/1 with valid data creates a child" do
      valid_attrs = %{first_name: "some first_name"}

      assert {:ok, %Child{} = child} = Families.create_child(valid_attrs)
      assert child.first_name == "some first_name"
    end

    test "create_child/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Families.create_child(@invalid_attrs)
    end

    test "update_child/2 with valid data updates the child" do
      child = child_fixture()
      update_attrs = %{first_name: "some updated first_name"}

      assert {:ok, %Child{} = child} = Families.update_child(child, update_attrs)
      assert child.first_name == "some updated first_name"
    end

    test "update_child/2 with invalid data returns error changeset" do
      child = child_fixture()
      assert {:error, %Ecto.Changeset{}} = Families.update_child(child, @invalid_attrs)
      assert child == Families.get_child!(child.id)
    end

    test "delete_child/1 deletes the child" do
      child = child_fixture()
      assert {:ok, %Child{}} = Families.delete_child(child)
      assert_raise Ecto.NoResultsError, fn -> Families.get_child!(child.id) end
    end

    test "change_child/1 returns a child changeset" do
      child = child_fixture()
      assert %Ecto.Changeset{} = Families.change_child(child)
    end
  end
end
