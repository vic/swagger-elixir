defmodule Swagger.Client.Generator do

  def generate_files(module, schema_file, dest_dir) do
    {:ok, swagger_schema} = Swagger.Parser.parse_file(schema_file)
    namespace = Module.concat module, "Client"
    modules = modules(namespace, swagger_schema)
    Enum.map(modules, &generate_file(dest_dir, &1))
  end

  def generate_file(dest_dir, {module, module_content}) do
    path = Path.expand(Macro.underscore(module), dest_dir) <> ".ex"
    code = Macro.to_string defmod({module, module_content})
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, code)
  end

  def defmodules(namespace, schema) do
    modules(namespace, schema)
    |> Enum.map(&defmod/1)
  end

  defp modules(ns, schema) do
    [
      {Module.concat(ns, Swagger), swagger_module(ns, schema)},
      {Module.concat(ns, Rest), rest_module(ns)}
    ]
  end

  defp defmod({module, module_content}) do
    quote do
      defmodule unquote(module) do
        unquote(module_content)
      end
    end
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
