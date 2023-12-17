defmodule ParentWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, SecurityScheme, Server}
  alias ParentWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    config = Application.get_env(:parent, ParentWeb.ApiSpec)

    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: Keyword.fetch!(config, :title),
        version: Keyword.fetch!(config, :version)
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{"authorization" => %SecurityScheme{type: "http", scheme: "bearer"}}
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
