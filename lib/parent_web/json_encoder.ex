defmodule ParentWeb.JSONEncoder do
  def encode_to_iodata!(data) do
    data
    |> Recase.Enumerable.convert_keys(&Recase.to_camel/1)
    |> Jason.encode_to_iodata!()
  end
end
