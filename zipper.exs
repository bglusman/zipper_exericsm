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
  alias BinTree, as: BT
  require IEx

  @type t :: %Zipper{ trail: any, tree: BinTree.t | nil }
  defstruct trail: nil, tree: nil
  # defstruct direction: nil, tree: nil, parent: nil
  @doc """
  Get a zipper focused on the root node.
  """
  # @type trail :: { :left, any, BinTree.t, trail }
  # | { :right, any, BinTree.t, trail }
  # | :top


  @spec from_tree(BT.t) :: Z.t
  def from_tree(tree) do
    z = %Zipper{tree: tree, trail: :top}
    z
  end
  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(%Zipper{trail: _, tree: tree}), do: tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(%Zipper{} = z) do
    case z do
      %Zipper{trail: :top, tree: tree} ->
        tree.value
      %Zipper{trail: {_,node,_}} ->
        node.value
    end
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  # def left(%{trail: :top, tree: bt}) do
  #   case bt.left do
  #     nil ->
  #       nil
  #     new_node -> 
  #       %{trail: {:left, new_node, bt, :top}, tree: bt} 
  #   end
  # end

  def left(%Zipper{trail: :top, tree: bt} = zipper) do
    case bt.left do
      nil ->
        nil
      new_node ->
        %Zipper{trail: {:left, new_node, zipper}, tree: bt}
    end
  end

  def left(%Zipper{trail: trail, tree: bt} = zipper) do
    {_, node, _} = trail
    case node.left do
      nil ->
        nil
      new_node ->
        %Zipper{trail: {:left, new_node, zipper}, tree: bt}
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right(%Zipper{trail: :top, tree: bt} = zipper) do
    case bt.left do
      nil ->
        nil
      new_node ->
        %Zipper{trail: {:left, new_node, zipper}, tree: bt}
    end
  end

  def right(%Zipper{trail: trail, tree: bt} = zipper) do
    {_, node, _} = trail
    case node.right do
      nil ->
        nil
      new_node ->
        %Zipper{trail: {:right, new_node, zipper}, tree: bt}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(%Zipper{trail: :top}), do: nil
  def up(%Zipper{trail: {_, _, parent_zipper}}), do: parent_zipper

  defp replace(map, symbol, value) do
    case map do
      nil ->
        struct(BT, [symbol, value])
      non_nil ->
        Map.put(map, symbol, value)
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(%Zipper{tree: tree, trail: :top} = zipper, value) do
    new_tree =  replace(tree, :value, value)
    %Zipper{trail: :top, tree: new_tree}
  end

  def set_value( %Zipper{trail: {direction, node, parent_zipper}, tree: bt} = z, v) do
    new_node = replace(node, :value, v)
    new_parent_zipper = updated_parent_zipper(z, parent_zipper, new_node)
    %Zipper{trail: {direction, new_node, new_parent_zipper}, tree: new_parent_zipper.tree}
  end

  def trail_direction(z) do
    z.trail |> elem(0)
  end


  defp updated_parent_zipper(%Zipper{} = z, %Zipper{} = parent_zipper, new_node ) do
    case trail_direction(z) do
      :left ->
        set_left(parent_zipper, new_node)
      :right ->
        set_right(parent_zipper, new_node)
    end
  end

  # @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  # defstruct value: nil, left: nil, right: nil

  # @type t :: %Zipper{ trail: any, tree: BinTree.t | nil }
  # defstruct trail: nil, tree: nil

  def trail_direction(z) do
    z.trail |> elem(0)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(%Zipper{trail: :top, tree: %BT{} = tree} = zipper,  node) do
    new_tree =  replace(tree, :left, node)
    %Zipper{trail: :top, tree: new_tree}
  end

  def set_left( %Zipper{trail: {direction, %BT{} = node, parent_zipper}, tree: %BT{} = bt} = z, node) do
    new_node = replace(node, :left, node)
    new_parent_zipper = updated_parent_zipper(z, parent_zipper, new_node)
    %Zipper{trail: {direction,node, new_parent_zipper}, tree: new_parent_zipper.tree}
  end

  def set_left(x, y) do
    IEx.pry
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(%Zipper{trail: :top, tree: %BT{} = tree} = zipper, node) do
    new_tree =  replace(tree, :right, node)
    %Zipper{trail: :top, tree: new_tree}
  end

  def set_right( %Zipper{trail: {direction, %BT{} = node, %Zipper{} = parent_zipper}, tree:%BT{} = bt} = z, node) do
    new_node = replace(node, :right, node)
    new_parent_zipper = updated_parent_zipper(z, parent_zipper, new_node)
    %Zipper{trail: {direction,node, new_parent_zipper}, tree: new_parent_zipper.tree}
  end

  # def set_right(x, y) do
  #   IEx.pry
  # end

end

defimpl Inspect, for: Zipper do
  import Inspect.Algebra


  def inspect(%{trail: t, tree: tree}, opts) do
    concat ["(Zipper:", to_doc(t, opts),
            ":", (if tree, do: to_doc(tree, opts), else: ""),
            ")"]
  end
  @type t :: %Zipper{ trail: any, tree: BinTree.t | nil }
  defstruct trail: nil, tree: nil


end

defimpl Inspect, for: Zipper do
  import Inspect.Algebra


  def inspect(%{trail: t, tree: tree}, opts) do
    concat ["(Zipper:", to_doc(t, opts),
            ":", (if tree, do: to_doc(tree, opts), else: ""),
            ")"]
  end
end
