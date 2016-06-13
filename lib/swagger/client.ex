defmodule Swagger.Client do

  defmacro __using__(schema) do
    defmodules(__CALLER__.module, schema)
  end

  def modules(ns, schema) do
    [
      {Module.concat(ns, Swagger), swagger_module(ns, schema)},
      {Module.concat(ns, Rest), rest_module(ns)}
    ]
  end

  def defmod({module, module_content}) do
    quote do
      defmodule unquote(module) do
        unquote(module_content)
      end
    end
  end

  defp defmodules(namespace, schema) do
    modules(namespace, schema) |> Enum.map(&defmod/1)
  end

  defp swagger_module(_namespace, schema) do
    quote do
      @schema unquote(schema)
      def schema, do: @schema
    end
  end

  defp rest_module(namespace) do
  end

end
