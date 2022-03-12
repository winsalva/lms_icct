defmodule App.Periodically do
  use GenServer

  alias App.Query.Lend

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point

    Lend.overdue_pickup_dates()
    Lend.overdue_released_books()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    # Reschedule once more

    Lend.overdue_pickup_dates()
    Lend.overdue_released_books()
    schedule_work()
    {:noreply, state}
  end

  # 86400 * 1000 = 1 day
  defp schedule_work() do
    Process.send_after(self(), :work, 86400 * 1000)
  end
end