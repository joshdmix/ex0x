defmodule Ex0xWeb.PageLive do
  use Ex0xWeb, :live_view

  @impl true

  @default_assigns [
    active_step: 1,
    bpm: 60,
    bd: "/samples/bd.wav",
    play: false,
    timer_ref: nil,
    step_opts: [4, 8, 16],
    selected_steps: [],
    selected_step_opt: 8,
    steps: 1..8 |> Enum.to_list(),
    instruments: ~w[bd sn hh oh pc]
  ]
  def mount(_params, _session, socket), do: {:ok, assign(socket, @default_assigns)}

  @impl true
  def handle_info(
        :tick,
        socket = %{
          assigns: %{active_step: active_step, play: true, selected_step_opt: selected_step_opt}
        }
      ) do
    active_step =
      cond do
        active_step < selected_step_opt -> active_step + 1
        true -> 1
      end

    {:noreply, assign(socket, active_step: active_step)}
  end

  @impl true
  def handle_info(
        :tick,
        socket
      ) do
    {:noreply, assign(socket, active_step: 1)}
  end

  # def handle_info({:set_bpm, bpm, timer_ref}, socket = %{assign: %{play: play}}) do
  #   :timer.cancel(timer_ref)
  #   time_per_beat = (60 / bpm * 1000) |> trunc

  #   {:ok, timer_ref} =
  #     if not play do
  #       :timer.send_interval(time_per_beat, self(), :tick)
  #     else
  #       {:ok, timer_ref}
  #     end

  #   {:noreply, assign(socket, play: true, timer_ref: timer_ref)}
  # end

  @impl true
  def handle_event("inc_bpm", _, socket = %{assigns: %{bpm: bpm}}) do
    bpm = bpm + 5
    socket = assign(socket, bpm: bpm)
    # send(self(), {:set_bpm, bpm, timer_ref})
    {:noreply, socket}
  end

  def handle_event("dec_bpm", _, socket = %{assigns: %{bpm: bpm}}) do
    bpm = bpm - 5
    socket = assign(socket, bpm: bpm)
    # send(self(), {:set_bpm, bpm, timer_ref})
    {:noreply, socket}
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

  def handle_event("play", _, socket) do
    time_per_beat = (60 / socket.assigns.bpm * 1000) |> trunc
    {:ok, timer_ref} = :timer.send_interval(time_per_beat, self(), :tick)

    {:noreply, assign(socket, play: true, timer_ref: timer_ref)}
  end

  def handle_event("stop", _, socket = %{assigns: %{timer_ref: timer_ref}}) do
    :timer.cancel(timer_ref)
    {:noreply, assign(socket, play: false)}
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, active_step: 1)}
  end
end
