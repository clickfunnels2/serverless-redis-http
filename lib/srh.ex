defmodule Srh do
  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:srh, :port) 
    IO.puts("Using port #{port}")

    children = [
      Srh.Auth.TokenResolver,
      {GenRegistry, worker_module: Srh.Redis.Client},
      {
        Plug.Cowboy,
        scheme: :http,
        plug: Srh.Http.BaseRouter,
        options: [
          port: port
        ]
      }
    ]

    opts = [strategy: :one_for_one, name: Srh.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
