defmodule Mix.Tasks.Swagger.Gen.Client do
  @shortdoc "Generate swagger client from yaml or json definition."

  def run([module, swagger_file]) do
    Swagger.Client.Generator.generate_files(module, swagger_file, "tmp")
  end
end
