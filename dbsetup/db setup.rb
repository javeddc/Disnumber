# build the adjective and nounlists from the csvs
require_relative 'list_builder'
require 'pry'
require 'active_record'
require_relative 'db_config'
require_relative 'models/adjective'
require_relative 'models/noun'
require_relative 'models/pair'




def generate_numstrings(min_length, max_length)
  length = min_length
  num_arr = []
  while length < max_length
    # starting number is always 0
    j = 0
    # loop, incrementing the number, padding it with zeros (rjust) and add it to the array
    while j < 10 ** length
      num_arr.push j.to_s.rjust(length, '0')
      j += 1
    end
    length += 1
  end
  num_arr
end

def novel_pair(a_1_int, n_1_int, a_2_int, n_2_int)
  if Pair.where(adjective_1_id: a_1_int, noun_1_id: n_1_int, adjective_2_id: a_2_int, noun_2_id: n_2_int) == []
    return true
  else
    return false
  end
end



nouns = WordList.new('./lists/test_new_nouns.csv')
nouns.chomp_list
adjectives = WordList.new('./lists/test_new_adjectives.csv')


nouns.arr.each do |noun|
  Noun.create(word: noun)
end


adjectives.arr.each do |adjective|
  Adjective.create(word: adjective)
end

adj_id_arr = Adjective.where.not(id: nil).pluck(:id)
noun_id_arr = Noun.where.not(id: nil).pluck(:id)


# numstrings = generate_numstrings(2,4)
# numstrings.each do |numstring|
#   new_pair_found = false
#   while new_pair_found == false do
#
#     a1 = adj_id_arr.sample
#     n1 = noun_id_arr.sample
#     a2 = adj_id_arr.sample
#     n2 = noun_id_arr.sample
#     new_pair_found = novel_pair(a1, n1, a2, n2)
#   end
#
#   Pair.create(
#   digits: numstring,
#   time_stamp: Time.now,
#   adjective_1_id: a1,
#   noun_1_id: n1,
#   adjective_2_id: a2,
#   noun_2_id: n2
#   )
# end


binding.pry
