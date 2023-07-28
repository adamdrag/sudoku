defmodule Sudoku.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SudokuWeb.Telemetry,
      {Phoenix.PubSub, name: Sudoku.PubSub},
      {Registry, keys: :unique, name: Sudoku.GameRegistry},
      Sudoku.TemplatesCache,
      Sudoku.GameSupervisor,
      {Finch, name: Sudoku.Finch},
      SudokuWeb.Endpoint
    ]

    :ets.new(:games_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: Sudoku.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SudokuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
