defmodule Swagger.ParserTest do

  alias Swagger.Parser

  use ExUnit.Case
  doctest Parser

  test "minimal.yaml file parsed as elixir map" do
  	assert %{"swagger" => "2.0"} = Parser.parse_file!("examples/minimal.yaml")
  end

  test "minimal.json file parsed as elixir map" do
    assert %{"swagger" => "2.0"} = Parser.parse_file!("examples/minimal.json")
  end

  test "minimal.yaml and minimal.json result in same map" do
    yaml = Parser.parse_file!("examples/minimal.yaml")
    json = Parser.parse_file!("examples/minimal.json")
    assert ^yaml = json
  end

end
