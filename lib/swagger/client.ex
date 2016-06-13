defmodule Swagger.Client do

  defmacro __using__(schema) do
    {schema, _} = Code.eval_quoted(schema, [], __CALLER__)
    Swagger.Client.Generator.defmodules(__CALLER__.module, schema)
  end

end
