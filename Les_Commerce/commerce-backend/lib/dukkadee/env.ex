defmodule Dukkadee.Env do
  @moduledoc """
  Module for handling environment variables.
  Loads values from .env file if available.
  """

  def get(key, default \\ nil) do
    System.get_env(key) || default
  end

  @doc """
  Loads .env file when application starts.
  Should be called in application.ex
  """
  def load_env do
    case File.read(".env") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.each(fn line ->
          case String.split(line, "=", parts: 2) do
            [key, value] ->
              key = String.trim(key)
              value = String.trim(value)
              System.put_env(key, value)

            _ ->
              # Skip invalid lines
              :ok
          end
        end)

        {:ok, "ENV loaded"}

      {:error, _} ->
        {:error, ".env file not found"}
    end
  end
end
