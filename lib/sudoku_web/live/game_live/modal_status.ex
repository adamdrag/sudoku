defmodule SudokuWeb.GameLive.ModalStatus do
  use SudokuWeb, :live_component

  def update(%{status: %{loss: true}} = assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(status: :loss)}
  end

  def update(%{status: %{win: true}} = assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(status: :win)}
  end

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  def render(%{status: :loss} = assigns) do
    ~H"""
    <div class="flex text-center">
      <div class="text-gray-800 text-4xl">Game Over!</div>
      <button
        phx-click="leave-game"
        phx-value-board_number={@board_number}
        class="my-8 px-20 text-3xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white focus:bg-blue-500 focus:text-white"
      >
        Start New Game
      </button>
    </div>
    """
  end

  def render(%{status: :win} = assigns) do
    ~H"""
    <div class="flex text-center">
      <div class="text-gray-800 text-4xl">You Win!</div>
      <button
        phx-click="leave-game"
        phx-value-board_number={@board_number}
        class="my-8 px-20 text-3xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white focus:bg-blue-500 focus:text-white"
      >
        Start New Game
      </button>
    </div>
    """
  end
end
