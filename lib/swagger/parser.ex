defmodule Swagger.Parser do

	def parse_file!(filename) do
		parse_file(filename)
    |> case do
      {:error, message} -> raise RuntimeError, message: message
      {:ok, swagger} -> swagger
    end
	end

	def parse_file(filename) do
    filename |> parser |> parse(filename)
	end

  defp parser(filename) do
    filename |> Path.extname |> String.downcase |> file_parser
  end

  defp parse({:error, _} = error, _), do: error
  defp parse({:ok, parser}, filename) do
    filename
    |> File.read()
    |> case do
      {:ok, content} -> parser.parse(content)
      {:error, _} = error -> error
    end
  end

	defp file_parser(".yaml"), do: {:ok, Swagger.Parser.YAML}
  defp file_parser(".json"), do: {:ok, Swagger.Parser.JSON}
  defp file_parser(ext) do
    {:error, "Dont know how to parse swagger definition from file with extension `#{ext}`"}
  end

  defmodule YAML do
    def parse(yaml) do
      {:ok, YamlElixir.read_from_string(yaml)}
    end
  end

  defmodule JSON do
    def parse(json) do
      Poison.Parser.parse(json)
    end
  end

end
