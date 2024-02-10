defmodule Parent.Factory do
  use ExMachina.Ecto, repo: Parent.Repo

  def child_factory do
    %Parent.Families.Children.Child{
      first_name: "Ronnie",
      last_name: "McDonnie",
      birthday: ~D[2023-12-16]
    }
  end

  def family_factory do
    %Parent.Families.Family{}
  end
end
