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

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
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
    select_number(socket, active_square, selected_number)
  end

  def handle_event("undo", _params, socket) do
    %{assigns: %{board_number: board_number, selected_numbers: selected_numbers}} = socket
    remove_number(socket, board_number, selected_numbers)
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

    <div class="my-12 w-max m-auto">
      <.navigation level={@summary.status.level} mistakes={@summary.status.mistakes} />
      <.board board={@summary.board} active_square={@active_square} />
      <div class="flex m-auto w-max">
        <.select_number
          :for={number <- 1..9}
          number={number}
          not_used_numbers={@summary.not_used_numbers[number] > 0}
        />
      </div>
    </div>
    """
  end

  def navigation(assigns) do
    ~H"""
    <div class="flex justify-around text-gray-600 py-2">
      <div class="flex items-center">
        <%= Helpers.human_readable_level()[@level] %>
      </div>
      <div>
        <button
          phx-click="leave-game"
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
        Mistakes: <%= @mistakes %>/3
      </div>
    </div>
    """
  end

  def board(assigns) do
    ~H"""
    <div class="m-auto w-max my-4">
      <div class="inline-grid grid-cols-3 gap-0 border-2 border-black">
        <div
          :for={full_square <- Enum.chunk_every(@board, 9)}
          class="inline-grid grid-cols-3 gap-0 border border-black"
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
        col-span-1 flex items-center justify-center border border-black rounded-none w-14 h-14 font-medium
        text-2xl hover:bg-gray-300 hover:text-black focus:bg-blue-200"
      ]}
    >
      <%= @square.value %>
    </button>
    """
  end

  def select_number(assigns) when assigns.not_used_numbers == true do
    ~H"""
    <button
      phx-click="select-number"
      phx-value-selected_number={@number}
      class="flex items-center justify-center rounded-full w-14 h-14 mx-2 font-light text-2xl text-blue-500 hover:scale-125"
    >
      <%= @number %>
    </button>
    """
  end

  def select_number(assigns) do
    ~H"""
    <div class="flex items-center justify-center rounded-full w-14 h-14 mx-2 font-light text-2xl text-red-500 hover:scale-125">
      <%= @number %>
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
    selected_numbers = [{active_square, selected_number} | selected_numbers]
    summary = GameServer.place_number(board_number, active_square, selected_number)

    check_status(socket, summary, selected_numbers)
  end

  defp remove_number(socket, _board_number, selected_numbers)
       when length(selected_numbers) == 0 do
    {:noreply, socket}
  end

  defp remove_number(socket, board_number, selected_numbers) do
    [{square_id, value} | tail_selected_numbers] = selected_numbers

    {:noreply,
     assign(socket,
       summary: GameServer.remove_number(board_number, square_id, value),
       selected_numbers: tail_selected_numbers
     )}
  end

  defp check_status(socket, summary, _selected_numbers)
       when summary.status.loss == true or summary.status.win == true do
    {:noreply, socket |> assign(summary: summary) |> push_patch(to: ~p"/game/status")}
  end

  defp check_status(socket, summary, selected_numbers) do
    {:noreply,
     assign(socket,
       summary: summary,
       active_square: nil,
       active_number: nil,
       selected_numbers: selected_numbers
     )}
  end
end
