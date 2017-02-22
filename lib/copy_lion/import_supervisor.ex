defmodule CopyLion.ImportSupervisor do
  @moduledoc """
  Umbrella app to start and supervise workers for each event stream being imported
  """
  use Supervisor

  def start_link do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [], name: CopyLion.ImportSupervisor)
    # # TEMPORARY! Used to figure out why CopyLion.ImportSupervisor is crashing
    # # Starts the dbg tracer
    # # Read all about it: http://erlang.org/doc/man/dbg.html
    # :dbg.tracer
    # # Monitor the pid, and log out all messages that this PID receives
    # # If this process is being told to shutdown, this will output
    # :dbg.p(pid, [:all])
    # {:ok, pid}
  end

  def init([]) do
    child_options
    |> Enum.map(&worker(CopyLion.EventImporter, [&1], id: make_ref))
    |> supervise(strategy: :one_for_one)
  end

  defp child_options do
    [
      [
        name: CopyLion.SurveyImporter,
      ],
    ]
  end
end
