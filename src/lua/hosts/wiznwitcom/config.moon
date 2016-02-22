-- config.moon
config = require "lapis.config"

config "development", ->
  port: 8080
  num_workers: 1
  code_cache: "off"
  secret: "please-change-me"
  session_name: "lapis_session"
  logging:
    queries: true
    requests: true

config "production", ->
  port: 8080
  num_workers: 4
  code_cache: "on"
  secret: "please-change-me"
  session_name: "lapis_session"
  logging:
    queries: true
    requests: true
