defmodule Igdb.Url do
  @moduledoc """
  Generates IGDB URLs.
  """

  alias Igdb.Config

  def generate_url(module, options, resource_ids \\ nil) do
    "#{Config.api_root()}/#{module.resource_collection_name}/#{resource_ids}" <>
      build_query(options)
  end

  def auth_headers do
    ["user-key": Config.api_key(), Accept: "Application/json; Charset=utf-8"]
  end

  defp build_query(options) do
    query =
      options
      |> to_query

    if String.length(query) > 0, do: "?" <> URI.encode(query), else: ""
  end

  # Query building taken from
  # https://gist.github.com/desmondhume/0fcb73bf6b7f4d9ed267d1c99c96471d
  def to_query(input, namespace) do
    input
    |> Enum.map(fn {key, value} -> parse_query("#{namespace}[#{key}]", value) end)
    |> Enum.join("&")
  end

  def to_query(input) do
    input
    |> Enum.map(fn {key, value} -> parse_query(key, value) end)
    |> Enum.join("&")
  end

  def parse_query(key, value) when is_map(value) do
    to_query(value, key)
  end

  def parse_query(key, value), do: "#{key}=#{value}"
end