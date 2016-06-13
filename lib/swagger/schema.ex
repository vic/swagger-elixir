defmodule Swagger.Schema do

  def operations(schema) do
    get_in(schema, ["paths"])
    |> Stream.flat_map(fn {path, operations} ->
      Enum.into(operations, [], fn {verb, operation} ->
        Map.merge(operation, %{"path" => path, "verb" => verb})
      end)
    end)
    |> Enum.to_list
  end

  def op_verb(operation), do: get_in(operation, ["verb"])
  def op_path(operation), do: get_in(operation, ["path"])

  def op_params_module(operation, namespace) do
    name =
      "#{op_verb(operation)}_#{op_path(operation)}_params"
      |> String.replace(~r{[^\w_]+}, "_")
      |> String.replace(~r{_+}, "_")
      |> String.replace(~r{^_|_$}, "")
      |> Macro.camelize
    Module.concat(namespace, name)
  end

  def op_req_params(operation, namespace, schema) do
    verb = op_verb(operation)
    path = op_path(operation)
    params_module = op_params_module(operation, namespace)
    params = quote(do: params = %unquote(params_module){})
    [verb, path, params]
  end

end
