defmodule ParentWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ParentWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint ParentWeb.Endpoint

      use ParentWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Parent.Factory
      import ParentWeb.ConnCase
      import ParentWeb.ConnCase, only: [assert_schema: 2]
    end
  end

  def assert_schema(data, resource),
    do: OpenApiSpex.TestAssertions.assert_schema(data, resource, ParentWeb.ApiSpec.spec())

  setup tags do
    Parent.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
