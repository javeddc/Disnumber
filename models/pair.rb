class Pair < ActiveRecord::Base

  def phrase
    words = []
    # gets the words from the database using the record's adjective and noun ID properties
    words.push Adjective.find(adjective_1_id).word
    words.push Adjective.find(adjective_2_id).word unless adjective_2_id.nil?
    words.push Noun.find(noun_1_id).word unless noun_1_id.nil?
    words.join(' ')
  end

  def size
    # checks the presence of 2nd adjectives and nouns to return the phrase length
    if adjective_2_id.nil? && noun_2_id.nil?
      2
    elsif !adjective_2_id.nil? && noun_2_id.nil?
      3
    else
      4
    end
  end

end
