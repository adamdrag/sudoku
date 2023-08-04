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
    <div>
      <.message_section board_number={@board_number} text="Game Over!" />
    </div>
    """
  end

  def render(%{status: :win} = assigns) do
    ~H"""
    <div>
      <.message_section board_number={@board_number} text="You Win!" />
    </div>
    """
  end

  def message_section(assigns) do
    ~H"""
    <div class="bg-indigo-400 rounded-t-3xl">
      <div class="p-1 text-2xl text-white text-center">You Win!</div>
    </div>
    <div class="border-l border-r border-gray-200 pt-4 pb-8">
      <button
        phx-click="leave-game"
        phx-value-board_number={@board_number}
        class="block mx-auto text-center sm:px-20 px-4 text-xl bg-indigo-400 text-white rounded-full shadow-md shadow-gray-500 hover:scale-105"
      >
        Start New Game
      </button>
    </div>
    <div class="h-6 bg-gray-200 rounded-b-3xl" />
    """
  end
end
