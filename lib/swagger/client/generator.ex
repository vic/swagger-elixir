defmodule Swagger.Client.Generator do

  def generate_files(module, schema_file, dest_dir) do
    {:ok, swagger_schema} = Swagger.Parser.parse_file(schema_file)
    namespace = Module.concat module, "Client"
    modules = Swagger.Client.modules(namespace, swagger_schema)
    Enum.map(modules, &generate_file(dest_dir, &1))
  end

  def generate_file(dest_dir, {module, module_content}) do
    path = Path.expand(Macro.underscore(module), dest_dir) <> ".ex"
    content = quote do
      defmodule unquote(module) do
        unquote(module_content)
      end
    end
    code = Macro.to_string content
    IO.puts code
  end

end
