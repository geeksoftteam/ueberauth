defmodule Ueberauth.Config do
  @moduledoc """
  Config helpers for Ueberauth
  """
  @default_method :single

  @spec get(Plug.Conn.t, atom) :: any
  def get(%Plug.Conn{} = conn, strategy) do
    case method(strategy) do
      {:multi, config} -> Ueberauth.Config.Multi.get(conn, config)
      {_, config} -> config
    end
  end

  @spec method(atom) :: {atom, Keyword.t}
  def method(strategy) do
    config = Application.get_env(:ueberauth, strategy, [])
    method = Keyword.get(config, :method, @default_method)
    {method, config}
  end

end
