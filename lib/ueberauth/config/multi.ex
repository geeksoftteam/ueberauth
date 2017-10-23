defmodule Ueberauth.Config.Multi do
  @moduledoc """
  Multiple config handler for Ueberauth
  """
  @default_conn_container :assigns
  @default_conn_field :application_id

  @spec get(Plug.Conn.t, Keyword.t) :: any
  def get(%Plug.Conn{} = conn, config) do
    container = Keyword.get(config, :conn_container, @default_conn_container)
    field = Keyword.get(config, :conn_field, @default_conn_field)
    app = get_app(conn, container, field)
    config[:configs][app]
  end

  def get_app(%Plug.Conn{assigns: assigns}, :assigns, field), do: assigns[field]
  def get_app(%Plug.Conn{private: private}, :private, field), do: private[field]
  def get_app(conn, _, field), do: conn.assigns[field]

end
