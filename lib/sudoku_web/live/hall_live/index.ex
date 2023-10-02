defmodule SudokuWeb.HallLive.Index do
  use SudokuWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="m-auto my-4 px-4 sm:w-111 w-full">
      <div class="bg-indigo-400 rounded-t-3xl shadow-md shadow-gray-500">
        <div class="pt-12 pb-1 text-2xl text-white text-center">Sudoku</div>
      </div>
      <div class="py-16 border-l border-r shadow-md shadow-gray-500">
        <.level level_id="1" text="Easy" />
        <.level level_id="2" text="Medium" />
        <.level level_id="3" text="Hard" />
        <.level level_id="4" text="Expert" />
        <.level level_id="5" text="Evil" />
      </div>
      <div class="bg-gray-200 rounded-b-3xl h-24 shadow-md shadow-gray-500" />
    </div>
    """
  end

  defp level(assigns) do
    assigns = assign(assigns, :board_number, Enum.random(100_000..999_999))

    ~H"""
    <.link
      href={~p"/game?level=#{@level_id}&board=#{@board_number}"}
      method="post"
      class="block mx-auto w-80 my-4 text-center px-20 text-xl bg-indigo-400 text-white rounded-full shadow-md shadow-gray-800 hover:scale-105"
    >
      <%= @text %>
    </.link>
    """
  end
end
