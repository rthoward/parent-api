defmodule ParentWeb.Helpers.Preloads do
  alias Plug.Conn

  @spec parse(Conn.t(), keyword()) :: keyword()
  def parse(conn, _allowed) do
    # TODO
    # allowed_paths = paths(allowed)

    conn
    |> expands_from_conn()
    |> Enum.map(&parse_expand/1)
    |> Enum.reduce([], &merge_keywords/2)
  end

  defp expands_from_conn(conn) do
    conn
    |> Conn.fetch_query_params()
    |> Map.get(:query_params)
    |> Map.get("expand", [])
    |> List.wrap()
  end

  @spec parse_expand(String.t()) :: keyword()
  defp parse_expand(expand) do
    expand
    |> String.split(".")
    |> Enum.map(&String.to_existing_atom/1)
    |> Enum.reverse()
    |> Enum.reduce([], &nest/2)
  end

  @spec nest(any(), any()) :: keyword()
  defp nest(k, v), do: [{k, List.wrap(v)}]

  # Deep merge two keyword lists.
  @spec merge_keywords(keyword(), keyword()) :: keyword()
  defp merge_keywords(kw1, kw2), do: Keyword.merge(kw1, kw2, &merge_keywords/3)
  defp merge_keywords(_, v1 = [_ | _], v2 = [_ | _]), do: merge_keywords(v1, v2)
  defp merge_keywords(_, _v1, v2), do: v2

  # Flatten a keyword map into a list of paths.
  # TODO broken
  @spec paths(keyword()) :: [String.t()]
  def paths(kw), do: kw |> paths([]) |> List.flatten()
  def paths([{_, _} | _] = kw, path), do: Enum.map(kw, fn {k, v} -> paths(v, [k | path]) end)
  def paths([] = list, path), do: Enum.map(list, fn v -> {v, []} end) |> paths(path)
  def paths(value, path), do: {Enum.reverse(path), value}

  # def paths(keyword), do: paths(keyword, []) |> List.flatten()
  # def paths([{_, _} | _] = keyword, path), do: Enum.map(keyword, fn {k, v} -> paths(v, [k | path]) end)
  # def paths(nil, path), do: path |> Enum.reverse() |> Enum.join(".")
  # def paths([], path), do: path |> Enum.reverse() |> Enum.join(".")
  # def paths(v, path), do: [v | path] |> Enum.reverse() |> Enum.join(".")
end
