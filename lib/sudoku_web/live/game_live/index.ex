defmodule SudokuWeb.GameLive.Index do
  use SudokuWeb, :live_view
  alias Sudoku.{GameSupervisor, GameServer, Helpers}

  def mount(%{"board" => board_number, "level" => level}, _session, socket) do
    case GameServer.game_pid(board_number) do
      pid when is_pid(pid) ->
        {:ok, assign_initial_states(socket, board_number, level)}

      nil ->
        GameSupervisor.start_game(board_number, level)
        {:ok, assign_initial_states(socket, board_number, level)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "Can't find that board. Start a new game!")
     |> push_redirect(to: ~p"/")}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp assign_initial_states(socket, board_number, level) do
    summary = GameServer.summary(board_number)

    assign(socket,
      board_number: board_number,
      level: level,
      summary: summary,
      active_square: nil,
      active_number: nil,
      board_actions: []
    )
  end

  def handle_event("leave-game", _params, socket) do
    %{assigns: %{board_number: board_number}} = socket
    GameSupervisor.stop_game(board_number)
    {:noreply, socket |> redirect(to: ~p"/")}
  end

  def handle_event("select-square", %{"selected_square_id" => selected_square_id}, socket) do
    {:noreply, assign(socket, active_square: selected_square_id)}
  end

  def handle_event("select-number", %{"selected_number" => selected_number}, socket) do
    %{assigns: %{active_square: active_square}} = socket
    place_number(socket, active_square, selected_number)
  end

  def handle_event("undo", _params, socket) do
    %{assigns: %{board_number: board_number, board_actions: board_actions}} = socket
    undo_action(socket, board_number, board_actions)
  end

  def handle_event("erase", _params, socket) do
    %{assigns: %{active_square: active_square}} = socket
    remove_number(socket, active_square)
  end

  def render(assigns) do
    ~H"""
    <.modal_no_cancel :if={@live_action in [:status]} id="modal_status" show>
      <.live_component
        module={SudokuWeb.GameLive.ModalStatus}
        id="status_component"
        action={@live_action}
        status={@summary.status}
        board_number={@board_number}
      />
    </.modal_no_cancel>

    <div class="sm:w-max w-full m-auto my-4 px-4">
      <.navigation_top level={@summary.status.level} mistakes={@summary.status.mistakes} />
      <.board board={@summary.board} active_square={@active_square} />
      <.navigation_bottom summary={@summary} />
    </div>
    """
  end

  def navigation_top(assigns) do
    ~H"""
    <div class="bg-indigo-400 rounded-t-3xl shadow-md shadow-gray-500">
      <div class="sm:h-6 h-2"></div>
      <button phx-click="leave-game" class="px-8 py-3 text-white hover:text-gray-800">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="3"
          stroke="currentColor"
          class="w-6 h-6 hover:scale-105"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
        </svg>
      </button>
    </div>
    <div class="flex justify-between sm:pt-8 pt-2 pb-1 px-8 border-l border-r text-gray-600 items-center shadow-md shadow-gray-500">
      <div>
        Mistakes: <%= @mistakes %>/3
      </div>
      <div>
        Difficulty: <%= Helpers.human_readable_level()[@level] %>
      </div>
    </div>
    """
  end

  def board(assigns) do
    ~H"""
    <div class="flex justify-center border-l border-r border-b pb-4 shadow-md shadow-gray-500">
      <div class="inline-grid grid-cols-3 gap-0 border-2 border-gray-800">
        <div
          :for={full_square <- Enum.chunk_every(@board, 9)}
          class="inline-grid grid-cols-3 gap-0 border border-gray-800"
        >
          <.square :for={square <- full_square} square={square} active_square={@active_square} />
        </div>
      </div>
    </div>
    """
  end

  def square(assigns) do
    ~H"""
    <button
      phx-click="select-square"
      phx-value-selected_square_id={@square.square_id}
      class={[
        "#{if @square.number != @square.value, do: "text-red-500"}
        #{if @active_square && @square.square_id in Helpers.focus_squares()[@active_square], do: "bg-gray-200"}
        col-span-1 flex items-center justify-center border border-gray-800 rounded-none sm:w-12 w-10 sm:h-12 h-10
        sm:text-3xl text-lg hover:bg-gray-300 hover:text-black focus:bg-indigo-400 focus:text-white"
      ]}
    >
      <%= @square.value %>
    </button>
    """
  end

  def navigation_bottom(assigns) do
    ~H"""
    <div class="bg-gray-200 rounded-b-3xl shadow-md shadow-gray-500">
      <div class="flex justify-between py-4 px-8 text-gray-600">
        <button phx-click="undo" class="hover:text-indigo-500 hover:scale-105">
          <img class="mx-auto h-5 w-auto" src="/images/undo.png" />
          <div class="">Undo</div>
        </button>
        <button phx-click="erase" class="hover:text-indigo-500 hover:scale-105">
          <img class="mx-auto h-5 w-auto" src="/images/eraser.png" />
          <div>Erase</div>
        </button>
      </div>
      <div class="flex justify-between pt-0 pb-4">
        <.number
          :for={number <- 1..9}
          number={number}
          not_used_numbers={@summary.not_used_numbers[number] > 0}
        />
      </div>
    </div>
    """
  end

  def number(assigns) when assigns.not_used_numbers == true do
    ~H"""
    <button
      phx-click="select-number"
      phx-value-selected_number={@number}
      class="flex items-center justify-center border rounded-lg shadow-md w-8 h-10 mx-2 font-light bg-white text-2xl text-indigo-500 hover:scale-105"
    >
      <div class="font-medium"><%= @number %></div>
    </button>
    """
  end

  def number(assigns) do
    ~H"""
    <div class="flex items-center justify-center border rounded-lg shadow-md w-8 h-10 mx-2 font-light bg-gray-300 text-2xl text-gray-600">
      <div class="font-medium"><%= @number %></div>
    </div>
    """
  end

  defp place_number(socket, active_square, _selected_number) when is_nil(active_square) do
    {:noreply, socket}
  end

  defp place_number(socket, active_square, selected_number) do
    %{assigns: %{board_number: board_number, board_actions: board_actions}} = socket
    selected_number = String.to_integer(selected_number)
    active_square = String.to_integer(active_square)
    board_actions = [{:added, active_square, selected_number} | board_actions]
    summary = GameServer.place_number(board_number, active_square, selected_number)

    check_status(socket, summary, board_actions)
  end

  defp undo_action(socket, _board_number, board_actions)
       when length(board_actions) == 0 do
    {:noreply, socket}
  end

  defp undo_action(socket, board_number, board_actions) do
    [{action, square_id, value} | tail_board_actions] = board_actions

    summary =
      case action do
        :added -> GameServer.remove_number(board_number, square_id, value)
        :erased -> GameServer.place_number(board_number, square_id, value)
      end

    {:noreply,
     assign(socket,
       summary: summary,
       board_actions: tail_board_actions
     )}
  end

  defp remove_number(socket, active_square) when is_nil(active_square) do
    {:noreply, socket}
  end

  defp remove_number(socket, active_square) do
    %{
      assigns: %{
        board_number: board_number,
        summary: summary,
        board_actions: board_actions
      }
    } = socket

    square_id = String.to_integer(active_square)
    value = Enum.find(summary.board, fn s -> s.square_id == square_id end).value
    board_actions = [{:erased, square_id, value} | board_actions]
    summary = GameServer.remove_number(board_number, square_id, value)

    {:noreply, assign(socket, board_actions: board_actions, summary: summary)}
  end

  defp check_status(socket, summary, _board_actions)
       when summary.status.loss == true or summary.status.win == true do
    %{assigns: %{board_number: board_number, level: level}} = socket

    {:noreply,
     socket
     |> assign(summary: summary)
     |> push_patch(to: ~p"/game/status?level=#{level}&board=#{board_number}")}
  end

  defp check_status(socket, summary, board_actions) do
    {:noreply,
     assign(socket,
       summary: summary,
       active_square: nil,
       active_number: nil,
       board_actions: board_actions
     )}
  end
end
