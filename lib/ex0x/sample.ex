defmodule Ex0x.Sample do
  defstruct [:name, :file]
  alias Ex0x.Sample

  def new(:bd, name) do
    %Sample{name: name, file: "/samples/bd.wav"}
  end
end
