defmodule Swagger.SchemaTest do
  use ExUnit.Case
  import Swagger.Parser, only: [parse_file!: 1, parse_yaml_string!: 1]

  alias Swagger.Schema

  test "operations returns list of single operation in minimal.yaml" do
    schema = parse_file!("examples/minimal.yaml")
    assert [index] = Schema.operations(schema)
    assert %{"path" => "/"}   = index
    assert %{"verb" => "get"} = index
    assert %{"responses" => %{"200" => _}} = index
  end

  test "operations with multiple verbs" do
    schema = parse_yaml_string! ~S"""
    paths:
      /pets:
        get:
          description: "List known pets"
        post:
          description: "Create new pet"
    """
    assert [get, post] = Schema.operations(schema)
    assert %{"verb" => "get", "path" => "/pets"} = get
    assert %{"verb" => "post", "path" => "/pets"} = post
  end

  test "op_params_module returns atom for operation params struct" do
    op = parse_yaml_string! ~S"""
    verb: get
    path: /pets
    description: "Fetch all pets"
    """
    assert Foo.GetPetsParams == Schema.op_params_module(op, Foo)
  end

  test "op_req_params yields a pattern for matching request" do
    op = parse_yaml_string! ~S"""
    verb: get
    path: /pets
    description: "Fetch all pets"
    """
    params = Schema.op_req_params(op, Foo, %{})
    assert ["get", "/pets", _params] = params
  end

end
