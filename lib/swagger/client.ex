defmodule Swagger.Client do

  defmacro __using__(schema) do
    Swagger.Client.Generator.defmodules(__CALLER__.module, schema)
  end


end
