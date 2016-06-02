defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil
end

defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    # %{tree: bt}
    # |> &Map.merge(if Map.has_key?(bt, :left), do: %{left: bt.left}, else: %{})
    # |> &Map.merge(if Map.has_key?(bt, :right), do: %{right: bt.right}, else: %{})
    # |> &Map.merge(if Map.has_key?(bt, :value), do: %{value: bt.value}, else: %{})
    bt
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(z) do
    z
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(z) do
   z.value 
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left(z) do
    #%(left: z.left, up: z)
    z.left
  end
  
  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right(z) do
    #%(left: z.left, up: z)
    z.right
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(z) do
    
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(z, v) do

  end
  
  @doc """
  Replace the left child tree of the focus node. 
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(z, l) do

  end
  
  @doc """
  Replace the right child tree of the focus node. 
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(z, r) do

  end
end
