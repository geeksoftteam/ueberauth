defmodule Ueberauth.ConfigTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import Mock

  @single_config [client_id: "123123123", client_secret: "123abc123abc"]

  @config [
      method: :multi,
      conn_container: :private,
      conn_field: :test,
      configs: %{
        "app_1" => @single_config
      }
    ]

  setup do
    conn =
      conn(:get, "/auth/simple")
      |> put_private(:test, "app_1")

    %{conn: conn}
  end

  test "gets config for multi settings", %{conn: conn} do
    assert Ueberauth.Config.Multi.get(conn, @config) == @single_config
  end

  test "gets mocked config method" do
    with_mock Application, [get_env: fn(_app, _strategy, _default) -> @config end] do
      assert Ueberauth.Config.method(:some_strategy) == {:multi, @config}
    end
  end

  test "gets mocked config", %{conn: conn} do
    with_mock Application, [get_env: fn(_app, _strategy, _default) -> @config end] do
      assert Ueberauth.Config.get(conn, :some_strategy) == @single_config
    end
  end

  test "gets config", %{conn: conn} do
    assert Ueberauth.Config.get(conn, :some_strategy) == []
  end

end
