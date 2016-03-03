module BinaryTree

  def self.from_array(array)
    Node.new(array.first).tap do |tree|
      array.each {|v| tree.insert v }
    end
  end

  class Node
    include Enumerable
    #Including enumerable gives me access to all the methods as long as I define each
    attr_accessor :data, :left, :right, :parent

    def initialize(data, parent = EmptyNode.new)
      @data = data
      @left = EmptyNode.new
      @right = EmptyNode.new
      @parent = parent
    end

    def left=(node)
      @left = node
      node.parent = self if !node.empty?
    end

    def right=(node)
      @right = node
      node.parent = self if !node.empty?
    end

    def inspect
    ##A means to introspect into the tree
      "{#{data}::#{left.inspect}|#{right.inspect}}"
    end

    def insert(value)
      case data <=> value
      when 1 then insert_left(value)
      when -1 then insert_right(value)
      when 0 then false # the value is already present
      end
    end

    def delete_node()
      if parent
        if !(left || right)
          #solve for leaf
          replace_self_with_empty!
        elsif (left && right)
          #solve for 2 children
          replace_self_with_closest_child!
        else
          #solve for one child
          replace_self_with_one_child!
        end
      else
        #cannot delete root branch
        false
      end
    end

    def include?(value)
      case data <=> value
      when 1 then left.include?(value)
      when -1 then right.include?(value)
      when 0 then true # the current node is equal to the value
      end
    end

    #recursive each implementation
    def each(&block)
    ##This is a depth first call of each, it follows down
    ##To the leaf of the left most, up to the root one level above, then down the right
    ##From that root and so on, there are many different ways you can write this each
      left.each(&block) if left
      block.call(self)
      right.each(&block) if right
    end

    #defining how I sort these items allows me to have access to sorting, min and max
    def <=>(other_node)
      data <=> other_node.data
    end

    def to_a
      left.to_a + [value] + right.to_a
    end

    def empty?
      false
    end

    private
    #can refactor this into a single function using metaprogramming
    def insert_right(value)
      right.insert(value) or self.right = Node.new(value, self)
    end

    def insert_left(value)
      left.insert(value) or self.left = Node.new(value, self)
    end

    def replace_self_with_empty!
      replace_self_with(EmptyNode.new)
    end

    def replace_self_with_one_child!
      right.empty? ? child = left : child = right
      child.parent = parent
      replace_self_with(child)
    end

    def replace_self_with_closest_child!
      closest_child = right.min #finding the smallest member of the larger branch
      closest_child.parent = parent #the following three lines set the child up to replace parent
      closest_child.left = left
      closest_child.right = right
      replace_self_with(closest_child) #remove parent from treet
    end

    def replace_self_with(node)
      parent.right == self ? parent.right = node : parent.right = node
    end
  end

  class EmptyNode
    def include?(*)
      false
    end

    def insert(*)
      false
    end

    def inspect
      "{}"
    end

    def to_a
      []
    end

    def empty?
      true
    end
  end
end
