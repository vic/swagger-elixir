defmodule Swagger.Client.Generator do

  alias Swagger.{Parser, Schema}

  def generate_files(module, schema_file, dest_dir) do
    {:ok, swagger_schema} = Parser.parse_file(schema_file)
    namespace = Module.concat module, "Client"
    modules = modules(namespace, swagger_schema)
    Enum.map(modules, &generate_file(&1, dest_dir))
  end

  defp generate_file({module, module_content}, dest_dir) do
    path = Path.expand(Macro.underscore(module), dest_dir) <> ".ex"
    code = Macro.to_string defmod({module, module_content})
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, code)
  end

  def defmodules(namespace, schema) do
    modules(namespace, schema) |> Enum.map(&defmod/1)
  end

  defp modules(ns, schema) do
    params_modules(ns, schema) ++
    [
      swagger_module(ns, schema),
      rest_module(ns, schema)
    ]
  end

  defp defmod({module, module_content}) do
    quote do
      defmodule unquote(module) do
        unquote(module_content)
      end
    end
  end

  defp swagger_module(namespace, schema) do
    { Module.concat(namespace, Swagger),
      quote do
        @schema unquote(Macro.escape(schema))
        def schema, do: @schema
      end }
  end

  defp params_modules(namespace, schema) do
    Schema.operations(schema)
    |> Enum.map(&defparam(&1, namespace, schema))
  end

  defp defparam(operation, namespace, schema) do
    name = Schema.op_params_module(operation, namespace)
    {name, quote do
      defstruct []
    end}
  end

  defp rest_module(namespace, schema) do
    content =
      Schema.operations(schema)
      |> Enum.map(&defoperation(&1, namespace, schema))
    { Module.concat(namespace, Rest), content }
  end

  defp defoperation(operation, namespace, schema) do
    params = Schema.op_req_params(operation, namespace, schema)
    quote do
      def request(unquote_splicing(params)) do
        1
      end
    end
  end


end
