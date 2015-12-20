defmodule Swagger.Parser do

  def parse_file!(filename) do
    parse_file(filename)
    |> case do
      {:error, message} -> raise RuntimeError, message: message
      {:ok, swagger} -> swagger
    end
  end

  def parse_file(filename) do
    filename |> guess_parser_from_ext |> read_file(filename)
  end

  defp guess_parser_from_ext(filename) do
    filename |> Path.extname |> String.downcase |> ext_parser
  end

  defp read_file({:error, _} = error, _), do: error
  defp read_file({:ok, parser}, filename) do
    filename
    |> File.read()
    |> case do
      {:ok, content} -> parser.parse(content)
      {:error, _} = error -> error
    end
  end

  defp ext_parser(".yaml"), do: {:ok, __MODULE__.YAML}
  defp ext_parser(".json"), do: {:ok, __MODULE__.JSON}
  defp ext_parser(ext) do
    {:error, "Unknown swagger file extension `#{ext}`"}
  end

  defmodule YAML do
    def parse(yaml) do
      {:ok, YamlElixir.read_from_string(yaml)}
    end
  end

  defmodule JSON do
    defdelegate parse(json), to: Poison.Parser
  end

end
