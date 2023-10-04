defmodule Sudoku.TemplatesCache do
  @moduledoc """
  A process that loads a collection of templates from an external source
  and caches them for expedient access. The cache is automatically
  refreshed every hour.
  """
  use GenServer
  require Logger

  @refresh_interval :timer.minutes(60)

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_templates() do
    GenServer.call(__MODULE__, :get_templates)
  end

  def init(:ok) do
    {:ok, %{}, {:continue, :get_templates}}
  end

  def handle_continue(:get_templates, _state) do
    state = load_templates()
    schedule_refresh()
    Logger.info("Cached: Templates")
    {:noreply, state}
  end

  def handle_call(:get_templates, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:refresh, _state) do
    state = load_templates()
    schedule_refresh()
    Logger.info("Cached: Templates")
    {:noreply, state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  # Loads templates from a method, though you could load
  # them from any source, such as an external API.
  defp load_templates() do
    Sudoku.Templates.read_templates()
  end
end
