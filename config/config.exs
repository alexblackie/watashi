import Config

config :logger_json, :backend,
  metadata: :all,
  json_encoder: Jason,
  formatter: LoggerJSON.Formatters.BasicLogger

config :logger,
  backends: [LoggerJSON]
