def tell_the_truth(options = {})
  if options[:profession] == :lawyer
    'it could be believed that this is almost certainly not false.'
  else
    true
  end
end

tell_the_truth(profession: :lawyer)
tell_the_truth(prefession: :shipbuilder)
tell_the_truth

# Code Blocks and Yield
3.times { puts 'hiya there, kiddo' }

animals = ['lions and', 'tigers and', 'bears', 'oh my']
animals.each { |a| puts a }

# You can pass around blocks
def call_block
  yield
end

def pass_block(&block)
  call_block(&block)
end

pass_block { puts 'Hello, Block' }

# Defining Classes
class Tree
  attr_accessor :children, :node_name

  def initialize(name, children = [])
    @children = children
    @node_name = name
  end

  def visit_all(&block)
    visit &block
    children.each { |c| c.visit_all &block }
  end

  def visit(&block)
    yield block
  end
end

ruby_tree = Tree.new('Ruby',
                     [Tree.new('Reia'),
                      Tree.new('MacRuby')])

puts 'Visiting a node'
ruby_tree.visit { |node| puts node }

puts 'Visiting entire tree'
ruby_tree.visit_all { |node| puts node }

# Writing a Mixin
module ToFile
  def filename
    "object_#{object_id}.txt"
  end

  def to_f
    File.open(filename, 'w') { |f| f.write(to_s) }
  end
end

class Person
  include ToFile
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def to_s
    name
  end
end

Person.new('matz').to_f

### Problems

# Research

# Find out how to access files with and without code blocks. What is the benefit
# of the code block?

## Looks like the code block will be run and then the file closed for you
## automatically.

# How would you translate a hash to an array? Can you translate arrays to
# hashes?

## I would use some method of each, or each_key to go from hash -> array, going
## from array to hash seems easy with .each_slice(2)

# Can you iterate through a hash?

## Yes

# You can use Ruby arrays as stacks. What other common data structures do arrays
# support?

# queues, Lists

# Do

# Print the contents of an array of sixteen numbers, four numbers at a time,
# using just each. Now, do the same with each_slice in Enumerable.
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

# With only each
so_far = 0
current_group = []
numbers.each do |num|
  currentGroup.push(num)
  so_far += 1
  next unless soFar == 4
  puts currentGroup
  puts ''
  current_group = []
  so_far = 0
end

# With each_slice
numbers.each_slice(4) do |num_group|
  puts num_group
  puts ''
end

# The Tree class was interesting, but it did not allow you to specify a new tree
# with a clean user interface. Let the initializer accept a nested structure of
# hashes. You should be able to specify a tree like this:
# my_tree = { 'grandpa' => { 'dad' => { 'child 1' => {},
#                                       'child 2' => {} },
#                            'uncle' => { 'child 3' => {},
#                                         'child 4' => {} } } }

class TreeTwo
  attr_accessor :children, :node_name

  def initialize(current_hash)
    @children = []
    current_hash.each_pair do |key, value|
      @node_name = key
      @children.push(Tree.new(value))
    end
  end

  def visit_all(&block)
    visit block
    children.each { |c| c.visit_all block }
  end

  def visit
    yield self
  end
end

# Write a simple grep that will print the lines of a file having any occurrences
# of a phrase anywhere in that line. You will need to do a simple regular
# expression match and read lines from a file. (This is surprisingly simple in
# Ruby.) If you want, include line numbers.

# phrase = 'hi there'
# currentLine = 0
# File.open('file_name_here.extension', 'r') do |f1|
#   while line = f1.gets
#     currentLine += 1
#     puts line if line.match(phrase)
#   end
# end
