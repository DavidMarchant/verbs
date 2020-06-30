#!/usr/bin/env ruby

require 'csv'
require 'set'

#NB - tides and waves have been singularized and layering and felting have
#   been changed to the infinitive
VERBS = ['roll', 'crease', 'fold', 'store', 'bend', 'shorten', 'twist', 'dapple', 'crumple', 'shave', 'tear', 'chip', 'split', 'cut', 'sever', 'drop', 'remove', 'simplify', 'differ', 'disarrange', 'open', 'mix', 'splash', 'knot', 'spill', 'droop', 'flow', 'curve', 'lift', 'inlay', 'impress', 'fire', 'flood', 'smear', 'rotate', 'swirl', 'support', 'hook', 'suspend', 'spread', 'hang', 'collect', 'tension', 'gravity', 'entropy', 'nature', 'grouping', 'layer', 'felt', 'grasp', 'tighten', 'bundle', 'heap', 'gather', 'scatter', 'arrange', 'repair', 'discard', 'pair', 'distribute', 'surfeit', 'compliment', 'enclose', 'surround', 'encircle', 'hole', 'cover', 'wrap', 'dig', 'tie', 'bind', 'weave', 'join', 'match', 'laminate', 'bond', 'hinge', 'mark', 'expand', 'dilute', 'light', 'modulate', 'distill', 'wave', 'electromagnetic', 'inertia', 'ionization', 'polarization', 'refraction', 'tide', 'reflection', 'equilibrium', 'symmetry', 'friction', 'stretch', 'bounce', 'erase', 'spray', 'systematize', 'refer', 'force', 'mapping', 'location', 'context', 'time', 'carbonization', 'continue']

$tmp_verbs = VERBS.clone

class Graph
  attr_reader :words, :adj_list

  def self.read_from_file(path)
    csv = CSV.read(path)
    adj_list = Hash[csv.map { |line| [line.first, line[1..-1]] } ]
    words = csv.flatten.to_set
    return Graph.new(words, adj_list)
  end

  def initialize(words, adj_list)
    @words = words
    @adj_list = adj_list
  end
end

print('Loading verbs.... ')
graph = Graph.read_from_file('words.csv.2nd')
puts('done')

puts VERBS.join(', ')
print('Choose your verb: ')
root = gets.strip
while not VERBS.include?(root)
  print("Verb '#{root.strip}' not in list, choose your verb: ")
  root = gets.strip
end
puts

def check_if_verb(cur_word, path)
  if $tmp_verbs.include?(cur_word)
    puts (cur_word + ": ")
    puts path.join(' --> ')
    #puts ("no. of words remaining: #{$words.length} - no. of targets remaning: #{$tmp_verbs.length}")
    puts
    $tmp_verbs.delete(cur_word)
  end
end

def iter_BFS(graph, root)
  discovered = Hash[graph.words.map { |x| [x, false] } ]
  queue_of_paths = [[root]]
  while not $tmp_verbs.empty? and not queue_of_paths.empty?
    cur_path = queue_of_paths.shift
    cur_word = cur_path[-1]
    check_if_verb(cur_word, cur_path)
    if graph.adj_list[cur_word]
      graph.adj_list[cur_word].each do |dest|
        unless discovered[dest]
          discovered[dest] = true
          new_path = cur_path.clone
          new_path.push(dest)
          queue_of_paths.push(new_path)
        end
      end
    else
      next
    end
  end
end

iter_BFS(graph, root)

puts "#{$tmp_verbs.length} verbs not found: #{$tmp_verbs.join(', ')}"
