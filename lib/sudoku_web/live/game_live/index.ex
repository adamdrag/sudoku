defmodule SudokuWeb.GameLive.Index do
  use SudokuWeb, :live_view
  alias Sudoku.{GameSupervisor, GameServer, Helpers}

  def mount(%{"board" => board_number, "level" => level}, _session, socket) do
    case GameServer.game_pid(board_number) do
      pid when is_pid(pid) ->
        {:ok, assign_initial_states(socket, board_number)}

      nil ->
        GameSupervisor.start_game(board_number, level)
        {:ok, assign_initial_states(socket, board_number)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "Can't find that board. Start a new game!")
     |> push_redirect(to: ~p"/")}
  end

  defp assign_initial_states(socket, board_number) do
    summary = GameServer.summary(board_number)

    assign(socket,
      board_number: board_number,
      summary: summary,
      active_square: nil,
      active_number: nil,
      selected_numbers: []
    )
  end

  def handle_event("leave-game", %{"board_number" => board_number}, socket) do
    GameSupervisor.stop_game(board_number)
    {:noreply, socket |> redirect(to: ~p"/")}
  end

  def handle_event("select-square", %{"selected_square_id" => selected_square_id}, socket) do
    {:noreply, assign(socket, active_square: selected_square_id)}
  end

  def handle_event("select-number", %{"selected_number" => selected_number}, socket) do
    %{assigns: %{active_square: active_square}} = socket
    select_number(socket, active_square, selected_number)
  end

  def handle_event("undo", _params, socket) do
    %{assigns: %{board_number: board_number, selected_numbers: selected_numbers}} = socket
    remove_number(socket, board_number, selected_numbers)
  end

  def render(assigns) do
    ~H"""
    <div class="my-12 w-max m-auto">
      <%= case {@summary.status.win, @summary.status.loss} do %>
        <% {false, false} -> %>
          <div class="flex justify-around text-gray-600 py-2">
            <div class="flex items-center">
              <%= Helpers.human_readable_level()[@summary.status.level] %>
            </div>
            <div>
              <button
                phx-click="leave-game"
                phx-value-board_number={@board_number}
                class="p-4 border-none hover:bg-transparent hover:text-gray-900 focus:bg-transparent focus:text-gray-600 active:bg-transparent active:text-gray-600"
              >
                <.icon name="hero-chevron-left" class="h-8 w-8 m-auto" />
                <div class="text-2xl font-light hover:text-gray-900 hover:scale-125">Leave</div>
              </button>
            </div>
            <div>
              <button
                phx-click="undo"
                class="p-4 border-none hover:bg-transparent hover:text-gray-900 focus:bg-transparent focus:text-gray-600 active:bg-transparent active:text-gray-600"
              >
                <.icon name="hero-arrow-uturn-left" class="h-8 w-8 m-auto" />
                <div class="text-2xl font-light hover:text-gray-900 hover:scale-125">Undo</div>
              </button>
            </div>
            <div class="flex items-center text-gray-600">
              Mistakes: <%= @summary.status.mistakes %>/3
            </div>
          </div>

          <div class="m-auto w-max my-4">
            <div class="inline-grid grid-cols-3 gap-0 border-2 border-black">
              <%= for full_square <- Enum.chunk_every(@summary.board, 9) do %>
                <div class="inline-grid grid-cols-3 gap-0 border border-black">
                  <%= for square <- full_square do %>
                    <button
                      phx-click="select-square"
                      phx-value-selected_square_id={square.square_id}
                      class={"#{if square.number != square.value, do: "text-red-500"}  #{if @active_square && square.square_id in Helpers.focus_squares()[@active_square], do: "bg-gray-200"} col-span-1 flex items-center justify-center border border-black rounded-none w-14 h-14 font-medium text-2xl hover:bg-gray-300 hover:text-black focus:bg-blue-200"}
                    >
                      <%= square.value %>
                    </button>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
          <div class="m-auto w-max">
            <div class="flex">
              <%= for number <- 1..9 do %>
                <%= if @summary.not_used_numbers[number] > 0 do %>
                  <div
                    phx-click="select-number"
                    phx-value-selected_number={number}
                    class="flex items-center justify-center rounded-full w-14 h-14 mx-2 font-light text-2xl text-blue-500 hover:scale-125"
                  >
                    <%= number %>
                  </div>
                <% else %>
                  <div class="w-14 h-14 mx-2"></div>
                <% end %>
              <% end %>
            </div>
          </div>
        <% {true, false} -> %>
          <div class="flex h-screen justify-center items-center">
            <div class="text-center">
              <div class="text-gray-800 text-4xl">You Win!</div>
              <button
                phx-click="leave-game"
                phx-value-board_number={@board_number}
                class="my-8 px-20 text-3xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white focus:bg-blue-500 focus:text-white"
              >
                Start New Game
              </button>
            </div>
          </div>
        <% {false, true} -> %>
          <div class="flex h-screen justify-center items-center">
            <div class="text-center">
              <div class="text-gray-800 text-4xl">You Lose!</div>
              <button
                phx-click="leave-game"
                phx-value-board_number={@board_number}
                class="my-8 px-20 text-3xl bg-white rounded-full border-transparent shadow-lg shadow-gray-500/20 hover:bg-blue-500 hover:text-white focus:bg-blue-500 focus:text-white"
              >
                Start New Game
              </button>
            </div>
          </div>
      <% end %>
    </div>
    """
  end

  defp select_number(socket, active_square, _selected_number) when is_nil(active_square) do
    {:noreply, socket}
  end

  defp select_number(socket, active_square, selected_number) do
    %{assigns: %{board_number: board_number, selected_numbers: selected_numbers}} = socket
    selected_number = String.to_integer(selected_number)
    active_square = String.to_integer(active_square)
    summary = GameServer.place_number(board_number, active_square, selected_number)

    {:noreply,
     assign(socket,
       summary: summary,
       active_square: nil,
       active_number: nil,
       selected_numbers: selected_numbers ++ [{active_square, selected_number}]
     )}
  end

  defp remove_number(socket, _board_number, selected_numbers)
       when length(selected_numbers) == 0 do
    {:noreply, socket}
  end

  defp remove_number(socket, board_number, selected_numbers) do
    {square_id, value} = List.last(selected_numbers)

    {:noreply,
     assign(socket,
       summary: GameServer.remove_number(board_number, square_id, value),
       selected_numbers: Helpers.remove_last_value_from_list(selected_numbers)
     )}
  end
end
