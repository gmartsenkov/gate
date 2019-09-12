defmodule Gate.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Gate.Locale, [])
    ]

    options = [
      name: Gate.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
