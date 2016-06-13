defmodule Swagger.ClientTest do

  use ExUnit.Case
  import Swagger.Parser, only: [parse_file!: 1]

  defmodule Minimal do
    use Swagger.Client, parse_file!("examples/minimal.yaml")
  end

  test "Swagger module holds the schema definition" do
    schema = parse_file!("examples/minimal.yaml")
    assert schema == Minimal.Swagger.schema
    assert "Simple API" == get_in(schema, ["info", "title"])
  end

  defmodule PetStore do
    use Swagger.Client, parse_file!("examples/petstore.yaml")
  end

end
