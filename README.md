# Swagger

*Work in progress*

Generate elixir client/server implementation from a [swagger](http://swagger.io/) spec file.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add swagger to your list of dependencies in `mix.exs`:

```elixir
        def deps do
          [{:swagger, "~> 0.0.1"}]
        end
```

  2. Ensure swagger is started before your application:

```elixir
        def application do
          [applications: [:swagger]]
        end
```
