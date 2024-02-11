defmodule ParentWeb.Helpers.Preloads do
  alias Plug.Conn

  # A string representing a flattened keyword list.
  # Ex: "foo.bar.baz" represents [foo: [bar: :baz]]
  @type expand :: String.t()

  @type preloads :: keyword()

  @spec from_conn(Conn.t(), preloads()) :: preloads()
  def from_conn(conn, allowed) do
    allowed_preloads = normalize(allowed)

    conn
    |> expands_from_conn()
    |> parse_expands()
    |> allow(allowed_preloads)
  end

  @doc """
    Converts preloads into their canonical form.

    Ex:
      normalize(cyan: [:teal, :turquoise])
      [cyan: [teal: [], turquoise: []]]
  """
  @spec normalize(keyword()) :: keyword()
  def normalize(preloads) when is_list(preloads), do: Enum.map(preloads, &normalize/1)
  def normalize({key, value}) when is_list(value), do: {key, normalize(value)}
  def normalize({key, value}), do: {key, [normalize(value)]}
  def normalize(value) when is_atom(value), do: {value, []}
  def normalize(value), do: raise("Invalid preload value #{inspect(value)}")

  @spec allow(preloads(), preloads()) :: preloads()
  def allow(preloads, allowed_preloads) do
    preloads
    |> Keyword.filter(fn {k, _v} -> Keyword.has_key?(allowed_preloads, k) end)
    |> Enum.map(fn {k, v} -> {k, allow(v, allowed_preloads[k])} end)
  end

  defp expands_from_conn(conn) do
    conn
    |> Conn.fetch_query_params()
    |> Map.get(:query_params)
    |> Map.get("expand", [])
    |> List.wrap()
  end

  @spec parse_expands([expand()]) :: preloads()
  defp parse_expands(expands) do
    expands
    |> Enum.map(&parse_expand/1)
    |> Enum.reduce([], &merge_keywords/2)
    |> normalize()
  end

  @spec parse_expand(expand()) :: preloads()
  defp parse_expand(expand) do
    expand
    |> String.split(".")
    |> Enum.map(&to_atom/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.reverse()
    |> Enum.reduce([], &nest/2)
  end

  @spec to_atom(String.t()) :: atom() | nil
  defp to_atom(value) do
    String.to_existing_atom(value)
  rescue
    _ -> nil
  end

  @spec nest(atom(), any()) :: keyword()
  defp nest(k, v), do: [{k, List.wrap(v)}]

  # Deep merge two keyword lists.
  @spec merge_keywords(keyword(), keyword()) :: keyword()
  defp merge_keywords(kw1, kw2), do: Keyword.merge(kw1, kw2, &merge_keywords/3)
  defp merge_keywords(_, v1 = [_ | _], v2 = [_ | _]), do: merge_keywords(v1, v2)
  defp merge_keywords(_, _v1, v2), do: v2
end
