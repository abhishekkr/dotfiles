defmodule IExAbk do
  def type?(term) when is_nil(term), do: "Type: Nil"
  def type?(term) when is_binary(term), do: "Type: Binary"
  def type?(term) when is_boolean(term), do: "Type: Boolean"
  def type?(term) when is_atom(term), do: "Type: Atom"
  def type?(term) when is_number(term), do: "Type: Number"
  def type?(term) when is_list(term), do: "Type: List"
  def type?(term) when is_map(term), do: "Type: Map"
  def type?(term) when is_tuple(term), do: "Type: Tuple"
  def type?(term) when is_pid(term), do: "Type: PID"
  def type?(term) when is_port(term), do: "Type: Port"
  def type?(term) when is_reference(term), do: "Type: Reference"
  def type?(_term), do: "Type: Unknown"
end
