defmodule Parent.Families.Children do
  import Ecto.Query

  alias Parent.Repo
  alias Parent.Families.Children.Child

  @doc """
  Returns the list of children.

  ## Examples

      iex> list_children()
      [%Child{}, ...]

  """
  def list_children(preloads \\ []) do
    Child
    |> preload(^preloads)
    |> Repo.all()
  end

  @doc """
  Gets a single child.

  Raises `Ecto.NoResultsError` if the Child does not exist.

  ## Examples

      iex> get_child!(123)
      %Child{}

      iex> get_child!(456)
      ** (Ecto.NoResultsError)

  """
  def get_child!(id, preloads \\ []) do
    Child
    |> preload(^preloads)
    |> Repo.get!(id)
  end

  def get_child(id, preloads \\ []) do
    Child
    |> preload(^preloads)
    |> Repo.get(id)
  end

  @doc """
  Creates a child.

  ## Examples

      iex> create_child(%{field: value})
      {:ok, %Child{}}

      iex> create_child(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_child(attrs \\ %{}) do
    %Child{}
    |> Child.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a child.

  ## Examples

      iex> update_child(child, %{field: new_value})
      {:ok, %Child{}}

      iex> update_child(child, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_child(%Child{} = child, attrs) do
    child
    |> Child.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a child.

  ## Examples

      iex> delete_child(child)
      {:ok, %Child{}}

      iex> delete_child(child)
      {:error, %Ecto.Changeset{}}

  """
  def delete_child(%Child{} = child) do
    Repo.delete(child)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking child changes.

  ## Examples

      iex> change_child(child)
      %Ecto.Changeset{data: %Child{}}

  """
  def change_child(%Child{} = child, attrs \\ %{}) do
    Child.changeset(child, attrs)
  end
end
