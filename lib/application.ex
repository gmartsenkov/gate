defmodule ParamValidator.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(ParamValidator.Locale, [])
    ]

    options = [
      name: ParamValidator.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
