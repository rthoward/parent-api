defmodule ParentWeb.FamilyController do
  use ParentWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Parent.Families

  action_fallback ParentWeb.FallbackController

  tags ["families"]

  def show(conn, %{"id" => id}) do
    preloads = [:children, :parents]

    id
    |> Families.get_family(preloads)
    |> case do
      %Families.Family{} = family -> render(conn, :show, %{family: family})
      _ -> {:error, :not_found}
    end
  end
end
