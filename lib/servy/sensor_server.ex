defmodule Servy.SensorServer do
  @name :sensor_server

  use GenServer

  defmodule State do
    defstruct interval: 60, data: nil
  end

  # Client Interface

  def start_link(interval) do
    IO.puts("Starting the Sensor Server with #{interval} min refresh ...")
    interval = :timer.minutes(interval)
    GenServer.start_link(__MODULE__, %State{interval: interval}, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  # Server Interface

  def init(%State{interval: interval} = state) do
    sensor_data = run_tasks_to_get_sensor_data()
    schedule_refresh(interval)
    {:ok, %{state | data: sensor_data}}
  end

  def handle_info(:refresh, %State{interval: interval} = state) do
    sensor_data = run_tasks_to_get_sensor_data()
    schedule_refresh(interval)
    {:noreply, %{state | data: sensor_data}}
  end

  defp schedule_refresh(interval) when is_number(interval) do
    Process.send_after(self(), :refresh, interval)
  end

  def handle_call(:get_sensor_data, _from, %State{data: data} = state) do
    {:reply, data, state}
  end

  def run_tasks_to_get_sensor_data do
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
