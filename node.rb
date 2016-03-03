class Node
  include Enumerable
  #Including enumerable gives me access to all the methods as long as I define each

  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
  end

  def inspect
  ##A means to introspect into the tree
    "{#{value}::#{left.inspect}|#{right.inspect}}"
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

  private
  #can refactor this into a single function using metaprogramming
  def insert_right(value)
    right ? right.insert : self.right = Node.new(v)
  end

  def insert_left(value)
    left ? left.insert : self.left = Node.new(v)
  end




end
