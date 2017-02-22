defmodule CopyLion.EventImporter do
  @moduledoc """
  Starts and manages the event stream, importing the deserialized events and
  using long-polling to keep up with updates.
  """

  @wait_time 30_000

  def start_link(opts) do
    pid = spawn_link(fn -> import end)
    Process.register(pid, Keyword.fetch!(opts, :name))
    {:ok, pid}
  end

  def import do
    Mongo.find(:mongo, "response_events", %{"$where" => "sleep(5000)"}, pool: DBConnection.Poolboy) |> Enum.to_list
  end
end
