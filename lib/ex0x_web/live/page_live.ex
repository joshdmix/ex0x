defmodule Ex0xWeb.PageLive do
  use Ex0xWeb, :live_view

  @impl true

  @default_assigns [
    bpm: 120,
    step_opts: [4, 8, 16],
    selected_steps: [],
    selected_step_opt: 8,
    steps: 1..8 |> Enum.to_list()
  ]
  def mount(_params, _session, socket) do
    IO.inspect(label: "hit mount")
    {:ok, assign(socket, @default_assigns)}
  end

  @impl true
  def handle_event("inc_bpm", _, socket) do
    {:noreply, assign(socket, bpm: socket.assigns.bpm + 5)}
  end

  def handle_event("dec_bpm", _, socket) do
    {:noreply, assign(socket, bpm: socket.assigns.bpm - 5)}
  end

  def handle_event("select_step_opt", %{"opt" => opt}, socket) do
    steps =
      case opt do
        "4" -> 1..4 |> Enum.to_list()
        "8" -> 1..8 |> Enum.to_list()
        "16" -> 1..16 |> Enum.to_list()
      end

    {:noreply, assign(socket, steps: steps, selected_step_opt: opt |> String.to_integer())}
  end

  def handle_event("add_step", %{"id" => id}, socket) do
    id = String.to_integer(id)
    new_socket = assign(socket, selected_steps: [id | socket.assigns.selected_steps])
    {:noreply, new_socket}
  end

  def handle_event("subt_step", %{"id" => id}, socket) do
    id = String.to_integer(id)
    new_socket = assign(socket, selected_steps: List.delete(socket.assigns.selected_steps, id))
    {:noreply, new_socket}
  end
end
