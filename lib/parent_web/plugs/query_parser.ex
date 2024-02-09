defmodule ParentWeb.Plugs.QueryParser do
  import Plug.Conn

  defmodule Query do
    defstruct [:expand, :fields]

    def from_query_params(m) do
      fields = Map.new(m, fn {k, v} -> {String.to_existing_atom(k), v} end)
      struct(__MODULE__, fields)
    end
  end

  def init(default), do: default

  def call(conn, opts) do
    query =
      conn
      |> fetch_query_params()
      |> Map.get(:query_params)
      |> Enum.into(opts)
      |> Query.from_query_params()
      |> Map.update!(:expand, &parse_expands/1)
      |> Map.update!(:fields, &parse_fields/1)

    assign(conn, :api_query, query)
  end

  defp parse_expands(expands) when is_binary(expands), do: parse_expands([expands])

  defp parse_expands(expands) when is_list(expands) do
    expands
    |> Enum.map(fn expand ->
      expand
      |> String.split(".")
      |> Enum.reverse()
      |> Enum.reduce([], fn preload, preloads ->
        {String.to_existing_atom(preload), List.wrap(preloads)}
      end)
    end)
  end

  defp parse_expands(_), do: nil

  defp parse_fields(fields) when is_binary(fields), do: parse_fields([fields])

  defp parse_fields(fields) when is_list(fields) do
    Enum.map(fields, fn field ->
      field
      |> String.split(".")
      |> Enum.reject(& &1 == "")
    end)

    # This reduces the fields into a nested map.
    # For example,
    # iex()> parse_fields(["first_name", "family.id", "family.parents.email"])
    # %{
    #   "family" => %{"id" => true, "parents" => %{"email" => true}},
    #   "first_name" => true
    # }
    #
    # Enum.reduce(fields, %{}, fn field, fields ->
    #   field_path =
    #     field
    #     |> String.split(".")
    #     |> Enum.reject(&(&1 == ""))

    #   put_in(fields, Enum.map(field_path, &Access.key(&1, %{})), true)
    # end)
  end

  defp parse_fields(_), do: nil
end
