require 'csv'

VERBS = ['roll', 'crease', 'fold', 'store', 'bend', 'shorten', 'twist', 'dapple', 'crumple', 'shave', 'tear', 'chip', 'split', 'cut', 'sever', 'drop', 'remove', 'simplify', 'differ', 'disarrange', 'open', 'mix', 'splash', 'knot', 'spill', 'droop', 'flow', 'curve', 'lift', 'inlay', 'impress', 'fire', 'flood', 'smear', 'rotate', 'swirl', 'support', 'hook', 'suspend', 'spread', 'hang', 'collect', 'tension', 'gravity', 'entropy', 'nature', 'grouping', 'layering', 'felting', 'grasp', 'tighten', 'bundle', 'heap', 'gather', 'scatter', 'arrange', 'repair', 'discard', 'pair', 'distribute', 'surfeit', 'compliment', 'enclose', 'surround', 'encircle', 'hole', 'cover', 'wrap', 'dig', 'tie', 'bind', 'weave', 'join', 'match', 'laminate', 'bond', 'hinge', 'mark', 'expand', 'dilute', 'light', 'modulate', 'distill', 'waves', 'electromagnetic', 'inertia', 'ionization', 'polarization', 'refraction', 'tides', 'reflection', 'equilibrium', 'symmetry', 'friction', 'stretch', 'bounce', 'erase', 'spray', 'systematize', 'refer', 'force', 'mapping', 'location', 'context', 'time', 'cabonization', 'continue']

def check_if_verb(cur_word, path, tmp_verbs)
  if tmp_verbs.include?(cur_word)
    puts (cur_word + ": ")
    puts path.join(' --> ')
    puts
    tmp_verbs.delete(cur_word)
  end
end

#why is path the same object for each call in the stack? idk but it's probably a good thing
def recur_DFS(path, words, tmp_verbs)
  cur_word = path.last
  cur_word_index = words.bsearch_index { |w| w.first >= cur_word }
  #if the current word is not in the list the returned index will not point to
  #   the current word
  if words[cur_word_index].first == cur_word
    check_if_verb(cur_word, path, tmp_verbs)
    cur_word_synonyms = words[cur_word_index][1..-1]
    words.delete_at(cur_word_index)
    cur_word_synonyms.each do |w|
      recur_DFS(path <<  w, words, tmp_verbs)
    end
  end
  path.delete_at(-1)
end

tmp_verbs = VERBS.clone

print('Loading words.... ')
words = CSV.read('words-WordNet.csv')
puts('done')

puts VERBS.join(', ')
print('Choose your verb: ')
root = gets.strip
while not VERBS.include?(root)
  print("Verb '#{root.strip}' not in list, choose your verb: ")
  root = gets.strip
end

recur_DFS([root], words, tmp_verbs)
