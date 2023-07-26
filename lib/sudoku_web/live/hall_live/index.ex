defmodule SudokuWeb.HallLive.Index do
  use SudokuWeb, :live_view
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_level_buttons: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="h-full w-96 mt-96 m-auto text-center">
      <div class="text-blue-500">
        <div class="text-4xl">Sudoku</div>
        <button
          phx-click={
            JS.show(to: "#levels", transition: {"ease-out duration-300", "opacity-0", "opacity-100"})
          }
          class="my-8 px-20 text-3xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white focus:bg-blue-500 focus:text-white"
        >
          New Game
        </button>
        <div id="levels" class={unless @show_level_buttons, do: "hidden"}>
          <.level level_id="1" text="Easy" />
          <.level level_id="2" text="Medium" />
          <.level level_id="3" text="Hard" />
          <.level level_id="4" text="Expert" />
        </div>
      </div>
    </div>
    """
  end

  defp level(assigns) do
    assigns = assign(assigns, :board_number, Enum.random(0..9999))

    ~H"""
    <.link
      navigate={~p"/game?level=#{@level_id}&board=#{@board_number}"}
      class="block m-auto my-4 px-16 text-2xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white"
    >
      <%= @text %>
    </.link>
    """
  end
end
