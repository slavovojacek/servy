defmodule Servy do

  use Application

  def start(_type, _args) do
    IO.puts "Starting the Application ..."
    Servy.Supervisor.start_link()
  end

  @moduledoc """
  Documentation for Servy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello("World")
      "Howdy, World!"

  """
  def hello(name) do
    "Howdy, #{name}!"
  end
end
