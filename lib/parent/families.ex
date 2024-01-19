defmodule Parent.Families do
  import Ecto.Query

  alias Parent.Repo
  alias Parent.Families.Family

  def get_family(id, preloads \\ []) do
    Family
    |> preload(^preloads)
    |> Repo.get(id)
  end
end
