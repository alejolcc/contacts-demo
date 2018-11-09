defmodule Contacts.Instrumenter do
  @moduledoc false
  use Prometheus.EctoInstrumenter
  # use Prometheus.Metric

  # def setup() do
  #   Counter.declare(
  #     name: :tag_times_total,
  #     help: "Total tag times",
  #     labels: [:device]
  #   )
  # end

  # def inc(device) do
  #   Counter.inc(
  #     name: :tag_times_total,
  #     labels: [device]
  #   )
  # end
end
